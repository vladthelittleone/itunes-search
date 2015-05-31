//
//  ItunesSearchViewCell.h
//  itunes-search
//
//  Created by Владислав Скуришин on 30.05.15.
//  Copyright (c) 2015 vladthelittleone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItunesSearchViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
