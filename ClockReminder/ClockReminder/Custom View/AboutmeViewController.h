//
//  AboutmeViewController.h
//  ClockReminder
//
//  Created by 張星星 on 11/12/25.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "GlobalFunctions.h"
#import "MyAbourMeTableViewCell.h"
@interface AboutmeViewController : UITableViewController <MFMailComposeViewControllerDelegate>
{
    NSArray *titleItems;
    NSDictionary *appInfoDict;
}
- (void)showMail;
- (void)showMessageAlert:(NSString*)message;
@end
