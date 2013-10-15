//
//  MyAbourMeTableViewCell.h
//  ClockReminder
//
//  Created by 張星星 on 11/12/27.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAbourMeTableViewCell : UITableViewCell
{
    UITextView *introTextView;
}

@property (nonatomic, retain) IBOutlet UITextView *introTextView;

@end
