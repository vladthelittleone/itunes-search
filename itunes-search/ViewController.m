//
//  ViewController.m
//  itunes-search
//
//  Created by Владислав Скуришин on 28.05.15.
//  Copyright (c) 2015 vladthelittleone. All rights reserved.
//

#import "ViewController.h"
#import "ItunesSearchViewCell.h"
#import "AFNetworking.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSMutableArray *searchResult;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    searchResult = [[NSMutableArray alloc] init];
    
    self.indicator.center = self.view.center;
    [self.indicator startAnimating];
    
    // Initialize table data
    NSString *BASE_URL = @"https://itunes.apple.com/search/";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@"jack" forKey:@"term"];
    [parameters setObject:@200    forKey:@"limit"];
    [parameters setObject:@"RU"   forKey:@"country"];

    NSURL *baseURL = [NSURL URLWithString: BASE_URL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET: [baseURL absoluteString] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            [searchResult addObjectsFromArray:[responseObject valueForKey:@"results"]];
            [self.indicator stopAnimating];
            [self.tableView reloadData];
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"Error: %@", error);
    }];

    self.tableView.estimatedRowHeight = 68.0;
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
    
    cell.titleLabel.text = [[searchResult objectAtIndex:indexPath.row] valueForKey:@"artistName"];
    cell.descriptionLabel.text = [[searchResult objectAtIndex:indexPath.row] valueForKey:@"longDescription"];

    return cell;
}

@end
