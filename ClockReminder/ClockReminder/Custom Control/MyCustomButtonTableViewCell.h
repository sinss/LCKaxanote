//
//  MyCustomButtonTableViewCell.h
//  ClockReminder
//
//  Created by 張星星 on 11/12/15.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import <UIKit/UIKit.h>

//define press button type
enum
{
    MyCustomButtonTableViewCellTypeSave = 0,       //按下註冊本機知通
    MyCustomButtonTableviewCellTypeCancel = 1      //解除本機通知
};
typedef NSInteger MyCustomButtonTableViewCellType;

@class MyCustomButtonTableViewCell;
@protocol MyCustomButtonTableViewCellDelegate <NSObject>

- (void) MyCustomButtonTableViewCell:(MyCustomButtonTableViewCell*)myCustomCell didPressButton:(MyCustomButtonTableViewCellType)pressButtonIndex;
- (void) MyCustomButtonTableViewCell:(MyCustomButtonTableViewCell*)cell saveToEvent:(BOOL)saveInd;

@end

@interface MyCustomButtonTableViewCell : UITableViewCell
{
    id <MyCustomButtonTableViewCellDelegate> delegate;
    BOOL isSaveToEvent;
    IBOutlet UISwitch *saveToEventSwitch;
    UILabel *titleLabel;
}
@property (assign) id<MyCustomButtonTableViewCellDelegate> delegate;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;

- (IBAction)switchValueChange:(id)sender;

@end
