//
//  MyMasterTableViewCell.m
//  ClockReminder
//
//  Created by 張星星 on 11/12/16.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import "MyMasterTableViewCell.h"

@implementation MyMasterTableViewCell
@synthesize delegate;
@synthesize rKey;
@synthesize aSwitch;
@synthesize reminderTimeLabel;
@synthesize endReminderTimeLabel;
@synthesize repeatIntervalLabel;
@synthesize memoLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        // Initialization code
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [aSwitch setHidden:editing];
    [super setEditing:editing animated:animated];
}
- (IBAction)switchValueChange:(id)sender
{
    [delegate MyMasterTableViewCell:self switchValueChange:aSwitch.isOn];
}

@end
