//
//  MyAbourMeTableViewCell.m
//  ClockReminder
//
//  Created by 張星星 on 11/12/27.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import "MyAbourMeTableViewCell.h"

@implementation MyAbourMeTableViewCell
@synthesize introTextView;

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

    // Configure the view for the selected state
}

@end
