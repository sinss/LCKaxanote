//
//  MKLocalNotificationsScheduler.m
//  LocalNotifs
//
//  Created by Mugunth Kumar on 9-Aug-10.
//  Copyright 2010 Steinlogic. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://mugunthkumar.com
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import "MKLocalNotificationsScheduler.h"
#import "ProcessDate.h"


static MKLocalNotificationsScheduler *_instance;
@implementation MKLocalNotificationsScheduler

@synthesize badgeCount = _badgeCount;
+ (MKLocalNotificationsScheduler*)sharedInstance
{
	@synchronized(self) {
		
        if (_instance == nil) {
			
			// iOS 4 compatibility check
			Class notificationClass = NSClassFromString(@"UILocalNotification");
			
			if(notificationClass == nil)
			{
				_instance = nil;
			}
			else 
			{				
				_instance = [[super allocWithZone:NULL] init];				
				_instance.badgeCount = 0;
			}
        }
    }
    return _instance;
}


#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone
{	
   return [[self sharedInstance] retain];
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{	
    return self;	
}

- (unsigned)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (id)autorelease
{
    return self;	
}


- (void) scheduleNotificationOn:(NSDate*)fireDate endReminderDate:(NSDate*)endDate repeatInterval:(NSCalendarUnit)unit text:(NSString*)alertText action:(NSString*)alertAction sound:(NSString*)soundfileName launchImage:(NSString*)launchImage  andInfo:(NSDictionary*)userInfo delayUnit:(NSInteger)delayUnit
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    //取得年、月、曰
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
    NSInteger unitFlags = NSYearCalendarUnit | 
    NSMonthCalendarUnit |
    NSDayCalendarUnit | 
    NSWeekdayCalendarUnit | 
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:fireDate];
    int year=[comps year];       //年
    int mon = [comps month];     //月
    int day = [comps day];       //曰
    int week = [comps weekday];      //週
    int hour = [comps hour];     //小時
    int min = [comps minute];    //分
    int sec = [comps second];    //秒
    NSLog(@"==========");
    NSLog(@"年:%i",year);
    NSLog(@"月:%i",mon);
    NSLog(@"週:%i",week);
    NSLog(@"曰:%i",day);
    NSLog(@"小時:%i",hour);
    NSLog(@"分:%i",min);
    NSLog(@"秒:%i",sec);
    NSLog(@"==========");
    //---------------------------------
    //unit = 0  指定曰期通知一次
    //unit = -1 幾秒鐘之後通知
    //unit = -2 完全不通知
    //如果曰期已過不通知
    if (unit == 0)
    {
        //如果指定曰期已過期，則取消註冊
        NSTimeInterval timeIntervalSinceNow = [fireDate timeIntervalSinceNow];
        if (timeIntervalSinceNow <= 0)
            return;
        localNotification.fireDate = fireDate;
        localNotification.repeatInterval = 0;   //表示不重覆
    }
    else if (unit == -1)
    {
        //如果幾秒之後已經過去，則取消註冊
        //NSTimeInterval timeIntervalSinceNow = [[fireDate dateByAddingTimeInterval:delayUnit] timeIntervalSinceNow];
        //if (timeIntervalSinceNow <= 0)
        //    return;
        localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:delayUnit];
    }
    else if (unit == -2)
    {
        return;
    }
    else
    {
        //指定頻率  default or 特定曰期
        //如果結束曰期已過則取消註冊通知
        if (endDate != nil &[endDate timeIntervalSinceNow] <= 0)
            return;
        if (delayUnit != 0)
        {
            //@"yyyy/MM/dd HH:dd:ss"
                    //年
            if (unit == NSYearCalendarUnit)
            {
                mon = delayUnit;
                
                NSString *newFireDateString =[[NSString alloc] initWithFormat:@"%04i-%02i-%02i %02i:%02i", year, mon, day, hour, min, sec];
                NSDate *newFireDate = [[ProcessDate shareInstance] StringToDate:newFireDateString];
                NSLog(@"fireDate:%@",fireDate);
                NSLog(@"newFireDateString:%@",newFireDateString);
                NSLog(@"newFireDate:%@",newFireDate);
                
                localNotification.fireDate = newFireDate;
                localNotification.repeatInterval = unit;
            }
        //月
            else if (unit == NSMonthCalendarUnit)
            {
                day = delayUnit;
                NSString *newFireDateString =[[NSString alloc] initWithFormat:@"%04i-%02i-%02i %02i:%02i", year, mon, day, hour, min, sec];
                NSDate *newFireDate = [[ProcessDate shareInstance] StringToDate:newFireDateString];
                NSLog(@"fireDate:%@",fireDate);
                NSLog(@"newFireDateString:%@",newFireDateString);
                NSLog(@"newFireDate:%@",newFireDate);
                
                localNotification.fireDate = newFireDate;
                localNotification.repeatInterval = unit;
            }
        //季
            else if (unit == NSQuarterCalendarUnit)
            {
                //無作用
                NSString *newFireDateString =[[NSString alloc] initWithFormat:@"%04i-%02i-%02i %02i:%02i", year, mon, day, hour, min, sec];
                NSDate *newFireDate = [[ProcessDate shareInstance] StringToDate:newFireDateString];
                NSLog(@"fireDate:%@",fireDate);
                NSLog(@"newFireDateString:%@",newFireDateString);
                NSLog(@"newFireDate:%@",newFireDate);
                
                localNotification.fireDate = newFireDate;
                localNotification.repeatInterval = unit;
            }
        //週
            else if (unit == NSWeekdayCalendarUnit)
            {
                /*
                 星期天  1
                 星期一  2
                 星期三  3
                 星期四  4
                 星期五  5
                 星期六  6
                 星期天  7
                 */
                int intervalOfDay = 60 * 60 * 24;
                NSDate *newFireDate = [fireDate dateByAddingTimeInterval:(intervalOfDay) * (delayUnit - week)];
                //無作用
                NSLog(@"fireDate:%@",fireDate);
                NSLog(@"newFireDate:%@",newFireDate);
                localNotification.fireDate = newFireDate;
                localNotification.repeatInterval = unit;
            }
        //曰
            else if (unit == NSDayCalendarUnit)
            {
                //須重新計算
                //int intervalOfHour = 60 * 60;
                /*
                 1 : 午夜12點
                 2 : 凌晨一點
                 ...
                 23: 晚上10點
                 24: 晚上11點
                */
                NSString *newFireDateString =[[NSString alloc] initWithFormat:@"%04i-%02i-%02i %02i:%02i", year, mon, day, delayUnit, min, sec];
                NSDate *newFireDate = [[ProcessDate shareInstance] StringToDate:newFireDateString];
                NSLog(@"fireDate:%@",fireDate);
                NSLog(@"newFireDateString:%@",newFireDateString);
                NSLog(@"newFireDate:%@",newFireDate);
                
                localNotification.fireDate = newFireDate;
                localNotification.repeatInterval = unit;
            }
        //小時
            else if (unit == NSHourCalendarUnit)
            {
                min = delayUnit;
                
                NSString *newFireDateString =[[NSString alloc] initWithFormat:@"%04i-%02i-%02i %02i:%02i", year, mon, day, hour, min, sec];
                NSDate *newFireDate = [[ProcessDate shareInstance] StringToDate:newFireDateString];
                NSLog(@"fireDate:%@",fireDate);
                NSLog(@"newFireDateString:%@",newFireDateString);
                NSLog(@"newFireDate:%@",newFireDate);
                
                localNotification.fireDate = newFireDate;
                localNotification.repeatInterval = unit;
            }
        }
        else
        {
            //預設值
            localNotification.fireDate = fireDate;
            localNotification.repeatInterval = unit;
        }
    }
    localNotification.timeZone = [NSTimeZone defaultTimeZone];	
	if (alertText == nil || [alertText isEqualToString:@""])
        alertText = [NSString stringWithFormat:@"    "];
    localNotification.alertBody = alertText;
    //localNotification.alertAction = alertAction;
	
	if(soundfileName == nil)
	{
		localNotification.soundName = UILocalNotificationDefaultSoundName;
	}
	else 
	{
		localNotification.soundName = soundfileName;
	}

	//localNotification.alertLaunchImage = launchImage;
	
	self.badgeCount ++;
    localNotification.applicationIconBadgeNumber += 1;			
    localNotification.userInfo = userInfo;
	
	// Schedule it with the app
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    //[app scheduleLocalNotification:localNotification];
    [localNotification release];
}

- (void) cancelNotificationOn:(NSDate*)fireDate endReminderDate:(NSDate*)endDate repeatInterval:(NSCalendarUnit)unit text:(NSString*)alertText action:(NSString*)alertAction sound:(NSString*)soundfileName launchImage:(NSString*)launchImage  andInfo:(NSDictionary*)userInfo delayUnit:(NSInteger)delayUnit
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    //取得年、月、曰
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
    NSInteger unitFlags = NSYearCalendarUnit | 
    NSMonthCalendarUnit |
    NSDayCalendarUnit | 
    NSWeekdayCalendarUnit | 
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:fireDate];
    int year=[comps year];       //年
    int mon = [comps month];     //月
    int day = [comps day];       //曰
    int week = [comps weekday];      //週
    int hour = [comps hour];     //小時
    int min = [comps minute];    //分
    int sec = [comps second];    //秒
    NSLog(@"==========");
    NSLog(@"年:%i",year);
    NSLog(@"月:%i",mon);
    NSLog(@"週:%i",week);
    NSLog(@"曰:%i",day);
    NSLog(@"小時:%i",hour);
    NSLog(@"分:%i",min);
    NSLog(@"秒:%i",sec);
    NSLog(@"==========");
    //---------------------------------
    //unit = 0  指定曰期通知一次
    //unit = -1 幾秒鐘之後通知
    //unit = -2 完全不通知
    //如果曰期已過不通知
    if (unit == 0)
    {
        //如果指定曰期已過期，則取消註冊
        NSTimeInterval timeIntervalSinceNow = [fireDate timeIntervalSinceNow];
        if (timeIntervalSinceNow <= 0)
            return;
        localNotification.fireDate = fireDate;
        localNotification.repeatInterval = 0;   //表示不重覆
    }
    else if (unit == -1)
    {
        //如果幾秒之後已經過去，則取消註冊
        //NSTimeInterval timeIntervalSinceNow = [[fireDate dateByAddingTimeInterval:delayUnit] timeIntervalSinceNow];
        //if (timeIntervalSinceNow <= 0)
        //    return;
        localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:delayUnit];
    }
    else if (unit == -2)
    {
        return;
    }
    else
    {
        //指定頻率  default or 特定曰期
        //如果結束曰期已過則取消註冊通知
        if (endDate != nil &[endDate timeIntervalSinceNow] <= 0)
            return;
        if (delayUnit != 0)
        {
            //@"yyyy/MM/dd HH:dd:ss"
            //年
            if (unit == NSYearCalendarUnit)
            {
                mon = delayUnit;
                
                NSString *newFireDateString =[[NSString alloc] initWithFormat:@"%04i-%02i-%02i %02i:%02i", year, mon, day, hour, min, sec];
                NSDate *newFireDate = [[ProcessDate shareInstance] StringToDate:newFireDateString];
                NSLog(@"fireDate:%@",fireDate);
                NSLog(@"newFireDateString:%@",newFireDateString);
                NSLog(@"newFireDate:%@",newFireDate);
                
                localNotification.fireDate = newFireDate;
                localNotification.repeatInterval = unit;
            }
            //月
            else if (unit == NSMonthCalendarUnit)
            {
                day = delayUnit;
                NSString *newFireDateString =[[NSString alloc] initWithFormat:@"%04i-%02i-%02i %02i:%02i", year, mon, day, hour, min, sec];
                NSDate *newFireDate = [[ProcessDate shareInstance] StringToDate:newFireDateString];
                NSLog(@"fireDate:%@",fireDate);
                NSLog(@"newFireDateString:%@",newFireDateString);
                NSLog(@"newFireDate:%@",newFireDate);
                
                localNotification.fireDate = newFireDate;
                localNotification.repeatInterval = unit;
            }
            //季
            else if (unit == NSQuarterCalendarUnit)
            {
                //無作用
                NSString *newFireDateString =[[NSString alloc] initWithFormat:@"%04i-%02i-%02i %02i:%02i", year, mon, day, hour, min, sec];
                NSDate *newFireDate = [[ProcessDate shareInstance] StringToDate:newFireDateString];
                NSLog(@"fireDate:%@",fireDate);
                NSLog(@"newFireDateString:%@",newFireDateString);
                NSLog(@"newFireDate:%@",newFireDate);
                
                localNotification.fireDate = newFireDate;
                localNotification.repeatInterval = unit;
            }
            //週
            else if (unit == NSWeekdayCalendarUnit)
            {
                /*
                 星期天  1
                 星期一  2
                 星期三  3
                 星期四  4
                 星期五  5
                 星期六  6
                 星期天  7
                 */
                int intervalOfDay = 60 * 60 * 24;
                NSDate *newFireDate = [fireDate dateByAddingTimeInterval:(intervalOfDay) * (delayUnit - week)];
                //無作用
                NSLog(@"fireDate:%@",fireDate);
                NSLog(@"newFireDate:%@",newFireDate);
                localNotification.fireDate = newFireDate;
                localNotification.repeatInterval = unit;
            }
            //曰
            else if (unit == NSDayCalendarUnit)
            {
                //須重新計算
                //int intervalOfHour = 60 * 60;
                /*
                 1 : 午夜12點
                 2 : 凌晨一點
                 ...
                 23: 晚上10點
                 24: 晚上11點
                 */
                NSString *newFireDateString =[[NSString alloc] initWithFormat:@"%04i-%02i-%02i %02i:%02i", year, mon, day, delayUnit, min, sec];
                NSDate *newFireDate = [[ProcessDate shareInstance] StringToDate:newFireDateString];
                NSLog(@"fireDate:%@",fireDate);
                NSLog(@"newFireDateString:%@",newFireDateString);
                NSLog(@"newFireDate:%@",newFireDate);
                
                localNotification.fireDate = newFireDate;
                localNotification.repeatInterval = unit;
            }
            //小時
            else if (unit == NSHourCalendarUnit)
            {
                min = delayUnit;
                
                NSString *newFireDateString =[[NSString alloc] initWithFormat:@"%04i-%02i-%02i %02i:%02i", year, mon, day, hour, min, sec];
                NSDate *newFireDate = [[ProcessDate shareInstance] StringToDate:newFireDateString];
                NSLog(@"fireDate:%@",fireDate);
                NSLog(@"newFireDateString:%@",newFireDateString);
                NSLog(@"newFireDate:%@",newFireDate);
                
                localNotification.fireDate = newFireDate;
                localNotification.repeatInterval = unit;
            }
        }
        else
        {
            //預設值
            localNotification.fireDate = fireDate;
            localNotification.repeatInterval = unit;
        }
    }
    localNotification.timeZone = [NSTimeZone defaultTimeZone];	
	if (alertText == nil || [alertText isEqualToString:@""])
        alertText = [NSString stringWithFormat:@"    "];
    localNotification.alertBody = alertText;
	
	if(soundfileName == nil)
	{
		localNotification.soundName = UILocalNotificationDefaultSoundName;
	}
	else 
	{
		localNotification.soundName = soundfileName;
	}
    
	localNotification.alertLaunchImage = launchImage;
	
	self.badgeCount ++;
    localNotification.applicationIconBadgeNumber += 1;			
    localNotification.userInfo = userInfo;
	
	// Schedule it with the app
    [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
    [localNotification release];
}
- (void) clearBadgeCount
{
	self.badgeCount = 0;
	[UIApplication sharedApplication].applicationIconBadgeNumber = self.badgeCount;
}

- (void) decreaseBadgeCountBy:(int) count
{
	self.badgeCount -= count;
	if(self.badgeCount < 0) self.badgeCount = 0;
	
	[UIApplication sharedApplication].applicationIconBadgeNumber = self.badgeCount;
}

- (void) handleReceivedNotification:(UILocalNotification*) thisNotification
{
	NSLog(@"Received: %@",[thisNotification description]);
	[self decreaseBadgeCountBy:1];
}

@end
