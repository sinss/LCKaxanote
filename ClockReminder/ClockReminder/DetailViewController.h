//
//  DetailViewController.h
//  ClockReminder
//
//  Created by 張星星 on 11/12/14.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
