//
//  ProcessNotification.h
//  ClockReminder
//
//  Created by 張星星 on 11/12/19.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProcessNotification : NSObject

- (void)registerLocalNotificationWithDate:(NSDate*)reminderDate endReminderDate:(NSDate*)endDate andMemo:(NSString*)memoContent andMyRepeatIntervalUnit:(MyRepeatIntervalUnit)unit andKey:(NSString*)rKey andDelayUnit:(NSInteger)delayUnit;
- (void)removeLocalNotificationWithDate:(NSDate*)reminderDate endReminderDate:(NSDate*)endDate andMemo:(NSString*)memoContent andMyRepeatIntervalUnit:(MyRepeatIntervalUnit)unit andKey:(NSString*)rKey andDelayUnit:(NSInteger)delayUnit;

@end
