//
//  MyCustomButtonTableViewCell.m
//  ClockReminder
//
//  Created by 張星星 on 11/12/15.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import "MyCustomButtonTableViewCell.h"

@implementation MyCustomButtonTableViewCell
@synthesize delegate;
@synthesize titleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
}
- (IBAction)switchValueChange:(id)sender
{
    [delegate MyCustomButtonTableViewCell:self saveToEvent:saveToEventSwitch.isOn];
}
@end
