//
//  MyMemoTableViewCell.h
//  ClockReminder
//
//  Created by 張星星 on 11/12/15.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMemoTableViewCell : UITableViewCell
{
    UITextField *memoTextField;
}
@property (nonatomic, retain) IBOutlet UITextField *memoTextField;


@end
