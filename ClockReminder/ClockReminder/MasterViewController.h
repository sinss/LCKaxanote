//
//  MasterViewController.h
//  ClockReminder
//
//  Created by 張星星 on 11/12/14.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/Eventkit.h>
#import <EventKitUI/EventKitUI.h>
#import "MyMasterTableViewCell.h"
#import "reminderDetailController.h"

@interface MasterViewController : UITableViewController 
<reminderDetailDelegate, MyMasterCellDelegate, EKEventEditViewDelegate>
{
    NSArray *reminderKeyList;
    NSDictionary *reminderDict;
    reminderDetailController *reminderDetail;
}


@end
