//
//  ProcessNotification.m
//  ClockReminder
//
//  Created by 張星星 on 11/12/19.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import "ProcessNotification.h"
#import "MKLocalNotificationsScheduler.h"

@interface ProcessNotification()

- (NSCalendarUnit)getNSCalendarUnit:(MyRepeatIntervalUnit)unit;

@end

@implementation ProcessNotification

- (void)registerLocalNotificationWithDate:(NSDate*)reminderDate endReminderDate:(NSDate*)endDate andMemo:(NSString*)memoContent andMyRepeatIntervalUnit:(MyRepeatIntervalUnit)unit andKey:(NSString*)rKey andDelayUnit:(NSInteger)delayUnit
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification != nil)
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:rKey,reminderKeyRkey, nil];
        [[MKLocalNotificationsScheduler sharedInstance] scheduleNotificationOn:reminderDate endReminderDate:endDate repeatInterval:[self getNSCalendarUnit:unit] text:memoContent action:@"View" sound:UILocalNotificationDefaultSoundName launchImage:@"pictest.png" andInfo:userInfo delayUnit:delayUnit];
        NSLog(@"Local Push Registered!!");
    }
    [notification release];
}
- (void)removeLocalNotificationWithDate:(NSDate*)reminderDate endReminderDate:endDate andMemo:(NSString*)memoContent andMyRepeatIntervalUnit:(MyRepeatIntervalUnit)unit andKey:(NSString*)rKey andDelayUnit:(NSInteger)delayUnit
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification != nil)
    {   
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:rKey,reminderKeyRkey, nil];
        [[MKLocalNotificationsScheduler sharedInstance] cancelNotificationOn:reminderDate endReminderDate:(NSDate*)endDate repeatInterval:[self getNSCalendarUnit:unit] text:memoContent action:@"View" sound:UILocalNotificationDefaultSoundName launchImage:@"pictest.png" andInfo:userInfo delayUnit:delayUnit];
        NSLog(@"Local Push Removed!");
    }
    [notification release];
}
/*
 EKEventStore *eventStore = [[EKEventStore alloc] init];
 
 EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
 event.title     = @"Demo XXXXX";
 
 event.startDate = [[NSDate alloc] init];
 event.endDate   = [[NSDate alloc] initWithTimeInterval:600 sinceDate:event.startDate];
 
 [event setCalendar:[eventStore defaultCalendarForNewEvents]];
 NSError *err;
 [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
 */
- (NSCalendarUnit)getNSCalendarUnit:(MyRepeatIntervalUnit)unit
{
    switch (unit)
    {
        case MyRepeatIntervalUnitSpecific:
            return 0;
            break;
        case MyRepeatIntervalUnitYear:
            return NSYearCalendarUnit;
            break;
        case MyRepeatIntervalUnitSeason:
            return NSQuarterCalendarUnit;
            break;
        case MyRepeatIntervalUnitMonth:
            return NSMonthCalendarUnit;
            break;
        case MyRepeatIntervalUnitWeek:
            return NSWeekdayCalendarUnit;
            break;
        case MyRepeatIntervalUnitDay:
            return NSDayCalendarUnit;
            break;
        case MyRepeatIntervalUnitHour:
            return NSHourCalendarUnit;
            break;
        case MyRepeatIntervalUnitMinute:
            return NSMinuteCalendarUnit;
            break;
        case MyRepeatIntervalUnitDelaySeconds:
            return -1;
            break;
        case MyRepeatIntervalUnitNone:
            return -2;
            break;
        default:
            return 0;
            break;
    }
}
@end
