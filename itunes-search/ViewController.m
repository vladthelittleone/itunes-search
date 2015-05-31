//
//  ViewController.m
//  itunes-search
//
//  Created by Владислав Скуришин on 28.05.15.
//  Copyright (c) 2015 vladthelittleone. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFNetworking.h>

#import "ViewController.h"
#import "ItunesSearchViewCell.h"

NSString * const BASE_URL = @"https://itunes.apple.com/search/";

@interface ViewController ()

@end

@implementation ViewController
{
    NSMutableArray *searchResult;
}

// Parameters for GET-request.
- (NSMutableDictionary *)initializeParameters
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@"jack" forKey:@"term"];
    [parameters setObject:@200    forKey:@"limit"];
    [parameters setObject:@"RU"   forKey:@"country"];
    
    return parameters;
}

// Handle response from ITunes API.
- (void)search:(NSMutableDictionary *)parameters
{
    searchResult = [[NSMutableArray alloc] init];
    
    NSURL *baseURL = [NSURL URLWithString: BASE_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET: [baseURL absoluteString] parameters:parameters
    success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            [searchResult addObjectsFromArray:[responseObject valueForKey:@"results"]];
            
            // As this block of code is run in a background thread, we need to ensure the GUI
            // update is executed in the main thread
            [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"Error: %@", error);
    }];
}

- (void)update
{
    [self search:[self initializeParameters]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(update) forControlEvents:UIControlEventValueChanged];
    
    [self update];

    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResult count];
}

- (void)reloadData
{
    // Reload table data
    [self.tableView reloadData];
    
    // End the refreshing
    if (self.refreshControl)
    {
        // Set format of title
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (searchResult == nil || [searchResult count] == 0)
    {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        self.tableView.backgroundView = nil;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ItunesSearchCell";
    
    ItunesSearchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[ItunesSearchViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.titleLabel.text = [[searchResult objectAtIndex:indexPath.row] valueForKey:@"trackCensoredName"];
    cell.descriptionLabel.text = [[searchResult objectAtIndex:indexPath.row] valueForKey:@"longDescription"];

    NSString *imageUrl = [[searchResult objectAtIndex:indexPath.row] valueForKey:@"artworkUrl100"];
    
    // Here we use the new provided sd_setImageWithURL: method to load the web image
    [cell.image sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *viewUrl = [[searchResult objectAtIndex:indexPath.row] valueForKey:@"trackViewUrl"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:viewUrl]];
}

@end
