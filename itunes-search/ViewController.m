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

- (NSMutableDictionary *)initializeParameters
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@"jack" forKey:@"term"];
    [parameters setObject:@200    forKey:@"limit"];
    [parameters setObject:@"RU"   forKey:@"country"];
    
    return parameters;
}

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
            [self.tableView reloadData];
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"Error: %@", error);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self search:[self initializeParameters]];

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ItunesSearchCell";
    
    ItunesSearchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
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
