//
//  MyMasterTableViewCell.h
//  ClockReminder
//
//  Created by 張星星 on 11/12/16.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyMasterTableViewCell;

@protocol MyMasterCellDelegate <NSObject>

- (void)MyMasterTableViewCell:(MyMasterTableViewCell*)cell switchValueChange:(BOOL)changeValue;

@end

@interface MyMasterTableViewCell : UITableViewCell
{
    id<MyMasterCellDelegate> delegate;
    UISwitch *aSwitch;
    UILabel *reminderTimeLabel;
    UILabel *endReminderTimeLabel;
    UILabel *repeatIntervalLabel;
    UILabel *memoLabel;
    NSString *rKey;
}
@property (assign) id<MyMasterCellDelegate> delegate;
@property (nonatomic, retain) NSString *rKey;
@property (nonatomic, retain) IBOutlet UISwitch *aSwitch;
@property (nonatomic, retain) IBOutlet UILabel *reminderTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *endReminderTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *repeatIntervalLabel;
@property (nonatomic, retain) IBOutlet UILabel *memoLabel;

- (IBAction)switchValueChange:(id)sender;

@end
