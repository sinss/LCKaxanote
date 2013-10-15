//
//  reminderItem.h
//  ClockReminder
//
//  Created by 張星星 on 11/12/14.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface reminderItem : NSObject
{
    NSString *rKey;
    NSDate *reminderTime;
    NSDate *endReminderTime;
    MyRepeatIntervalUnit repeatInterval;
    NSInteger reminderDelayUnit;       //幾分鐘  or  幾秒鐘
    NSString *imageFilePath;
    UIImage *image;
    NSString *memoContent;
    BOOL isEnable;
}
+ (reminderItem*)shareInstance;
@property (nonatomic, retain) NSString *rKey;
@property (nonatomic, retain) NSDate *reminderTime;
@property (nonatomic, retain) NSDate *endReminderTime;
@property MyRepeatIntervalUnit repeatInterval;
@property NSInteger reminderDelayUnit;
@property (nonatomic, retain) NSString *imageFilePath;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *memoContent;
@property BOOL isEnable;

- (NSDictionary*)createDictionaryWithReminderItem:(reminderItem*)item;
- (reminderItem*)createReminderItemWithDictionary:(NSDictionary*)dict;

@end
