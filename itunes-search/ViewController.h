//
//  ViewController.h
//  itunes-search
//
//  Created by Владислав Скуришин on 28.05.15.
//  Copyright (c) 2015 vladthelittleone. All rights reserved.
//

#import <UIKit/UIKit.h>

// UITableViewDataSource is the link between your data and the table view.
// UITableViewDelegate, on the other hand, deals with the appearance of the UITableView.
@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

