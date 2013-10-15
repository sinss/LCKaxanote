//
//  GlobalFunctions.m
//  ClockReminder
//
//  Created by 張星星 on 11/12/16.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import "GlobalFunctions.h"
static GlobalFunctions *_instance;
@implementation GlobalFunctions

#pragma mark - UserDefaults

+ (GlobalFunctions*)shareInstance
{
    @synchronized(self)
    {
        if (_instance == nil)
        {
            //iOS4 compatibility check
            Class notificationClass = NSClassFromString(@"UILocalNotification");
            if (notificationClass == nil)
            {
                return _instance = nil;
            }
            else
            {
                _instance = [[super allocWithZone:NULL] init];
            }
        }
    }
    return _instance;
}

- (NSString*) getUserDefaultsforKey:(NSString*)key DefValue:(NSString*)value 
{
    NSUserDefaults* Defualt = [NSUserDefaults standardUserDefaults];
	//NSDictionary* defaultTemp = [NSDictionary dictionaryWithObjectsAndKeys:value, key, nil];

	//[Defualt registerDefaults:defaultTemp];
	return [Defualt stringForKey:key];
}
- (void) writeUserDefaultsValue:(NSString*)value Key:(NSString*)key 
{
	NSUserDefaults* Defualt = [NSUserDefaults standardUserDefaults];
	[Defualt setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) saveDefualtFile
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - save and load saved reminderData
- (NSString*)getStringInAppInfoForKey:(NSString *)key
{
    NSString *bundleFile = [[NSBundle mainBundle] pathForResource:@"appInfo" ofType:@"plist"];
    NSString *fileName = [self getDocumentFullPath:appInfoFilePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileName])
    {
        NSLog(@"appInfo.plist not exist create it!");
        [[NSFileManager defaultManager] copyItemAtPath:bundleFile toPath:fileName error:nil];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:fileName];
    return [dict objectForKey:key];
}
- (NSMutableArray*)getArrayInAppInfoForKey:(NSString*)key
{
    NSString *bundleFile = [[NSBundle mainBundle] pathForResource:@"appInfo" ofType:@"plist"];
    NSString *fileName = [self getDocumentFullPath:appInfoFilePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileName])
    {
        NSLog(@"appInfo.plist not exist create it!");
        [[NSFileManager defaultManager] copyItemAtPath:bundleFile toPath:fileName error:nil];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:fileName];
    if ([dict objectForKey:key] != nil)
        return [[NSMutableArray alloc] initWithObjects:[dict objectForKey:key],nil];
    return [[NSMutableArray alloc] initWithCapacity:0];
}
- (void)saveAppInfoWithKey:(NSString *)key andValue:(NSString *)value
{
    NSString *fileName = [self getDocumentFullPath:appInfoFilePath];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:fileName];
    [dict setValue:value forKey:key];
    [dict writeToFile:fileName atomically:YES];
}
- (void)saveAppInfoWithKey:(NSString *)key andArray:(NSArray*)array
{
    NSString *fileName = [self getDocumentFullPath:appInfoFilePath];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:fileName];
    [dict setValue:array forKey:key];
    [dict writeToFile:fileName atomically:YES];
}
- (NSString*)getDocumentFullPath:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullName = [documentsDirectory stringByAppendingPathComponent:fileName];
    return fullName;
}
- (NSArray*)getReminderKeyList
{
    NSString *fileName = [self getDocumentFullPath:reminderKeyListPath];
    NSArray *keyList = [NSArray arrayWithContentsOfFile:fileName];
    return keyList;
}
- (NSDictionary*)getReminderDictionary
{
    NSString *fileName = [self getDocumentFullPath:reminderFilePath];
    NSDictionary *mutableDict = [NSDictionary dictionaryWithContentsOfFile:fileName];
    return mutableDict;
}
- (BOOL)saveReminderKeyList:(NSMutableArray*)keyList
{
    NSString *fileName = [self getDocumentFullPath:reminderKeyListPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
        NSLog(@"reminderKeyList File Exist!");

    return [keyList writeToFile:fileName atomically:YES];
}
- (BOOL)saveReminderDictionary:(NSMutableDictionary*)reminderDict
{
    NSString *fileName = [self getDocumentFullPath:reminderFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
        NSLog(@"reminderFilePath File Exist!");
    return [reminderDict writeToFile:fileName atomically:YES];
}

#pragma mark - repetaInterval Check
- (NSString*)repeatIntervalName:(MyRepeatIntervalUnit)unit
{
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"appInfo" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:fileName];
    NSArray *array = nil;
    if ([self currentLanguageInd] == 0)
        array = [dict valueForKey:@"repeatIntervalName_tw"];
    else
        array = [dict valueForKey:@"repeatIntervalName_en"];
    return [array objectAtIndex:unit];
}
- (NSString*)repeatIntervalDisplayString:(MyRepeatIntervalUnit)repeatIntervalUnit andDelayUunit:(NSInteger)unit
{
    /*
    if (repeatIntervalUnit == MyRepeatIntervalUnitDelaySeconds)
    {
        if ([[GlobalFunctions shareInstance] currentLanguageInd] == 0)
            return [NSString stringWithFormat:@"從現在起，在%i %@通知我",unit,[self repeatIntervalName:repeatIntervalUnit]];
        else
            return [NSString stringWithFormat:@"reminder me Delay %i %@",unit,[self repeatIntervalName:repeatIntervalUnit]];
    }
    else
    {
        return [self repeatIntervalName:repeatIntervalUnit];
    }
    */
    if ([self currentLanguageInd] == 0)
    {
        //繁體中文
        if (repeatIntervalUnit == MyRepeatIntervalUnitDelaySeconds)
        {
            return [NSString stringWithFormat:@"在%i%@提醒",unit,[self repeatIntervalName:repeatIntervalUnit]];
        }
        else if (repeatIntervalUnit == MyRepeatIntervalUnitYear)
        {
            if (unit == 0)
                return [NSString stringWithFormat:@"每年提醒(開始曰期)"];
            else
                return [NSString stringWithFormat:@"每年的%@個月提醒",[self getRepeatIntervalUnitString:unit]];
        }
        else if (repeatIntervalUnit == MyRepeatIntervalUnitMonth)
        {
            if (unit == 0)
                return [NSString stringWithFormat:@"每月提醒(開始曰期)"];
            else
                return [NSString stringWithFormat:@"每月的第%@天提醒",[self getRepeatIntervalUnitString:unit]];
        }
        else if (repeatIntervalUnit == MyRepeatIntervalUnitWeek)
        {
            if (unit == 0)
                return [NSString stringWithFormat:@"每週提醒(開始曰期)"];
            else
                return [NSString stringWithFormat:@"每週的%@提醒",[self getRepeatIntervalDayOfWeek:unit]];
        }
        else if (repeatIntervalUnit == MyRepeatIntervalUnitDay)
        {
            if (unit == 0)
                return [NSString stringWithFormat:@"每天提醒(開始曰期)"];
            else
                return [NSString stringWithFormat:@"每天的%@點提醒",[self getRepeatIntervalUnitString:unit]];
        }
        else if (repeatIntervalUnit == MyRepeatIntervalUnitHour)
        {
            if (unit == 0)
                return [NSString stringWithFormat:@"每小時提醒(開始曰期)"];
            else
                return [NSString stringWithFormat:@"每小時的%@分提醒",[self getRepeatIntervalUnitString:unit]];
        }
        else
            return [self repeatIntervalName:repeatIntervalUnit];
    }
    else
    {
        //英文
        if (repeatIntervalUnit == MyRepeatIntervalUnitDelaySeconds)
        {
            return [NSString stringWithFormat:@"remind me after %i seconds",unit];
        }
        else if (repeatIntervalUnit == MyRepeatIntervalUnitYear)
        {
            if (unit == 0)
                return [NSString stringWithFormat:@"remind me every year(start date)"];
            else
                return [NSString stringWithFormat:@"remind me at %@ months of year",[self getRepeatIntervalUnitString:unit]];
        }
        else if (repeatIntervalUnit == MyRepeatIntervalUnitMonth)
        {
            if (unit == 0)
                return [NSString stringWithFormat:@"remind me every month(start date)"];
            else
                return [NSString stringWithFormat:@"remind me at %@ days of month",[self getRepeatIntervalUnitString:unit]];
        }
        else if (repeatIntervalUnit == MyRepeatIntervalUnitWeek)
        {
            if (unit == 0)
                return [NSString stringWithFormat:@"remind me every week(start date)"];
            else
                return [NSString stringWithFormat:@"remind me every %@",[self getRepeatIntervalDayOfWeek:unit]];
        }
        else if (repeatIntervalUnit == MyRepeatIntervalUnitDay)
        {
            if (unit == 0)
                return [NSString stringWithFormat:@"remind me every day(start date)"];
            else
                return [NSString stringWithFormat:@"remind me at %@ hours of day",[self getRepeatIntervalUnitString:unit]];
        }
        else if (repeatIntervalUnit == MyRepeatIntervalUnitHour)
        {
            if (unit == 0)
                return [NSString stringWithFormat:@"remind me every hour(start date)"];
            else
                return [NSString stringWithFormat:@"remind me at %@ minutes of hour",[self getRepeatIntervalUnitString:unit]];
        }
        else
            return [self repeatIntervalName:repeatIntervalUnit];  
    }
}
- (MyRepeatIntervalUnit)repeatIntervalValue:(NSInteger)unitNo
{
    switch (unitNo)
    {
        case 0:
            return MyRepeatIntervalUnitNone;
            break;
        case 1:
            return MyRepeatIntervalUnitSpecific;
            break;
        case 2:
            return MyRepeatIntervalUnitYear;
            break;
        case 3:
            return MyRepeatIntervalUnitSeason;
            break;
        case 4:
            return MyRepeatIntervalUnitMonth;
            break;
        case 5:
            return MyRepeatIntervalUnitWeek;
            break;
        case 6:
            return MyRepeatIntervalUnitDay;
            break;
        case 7:
            return MyRepeatIntervalUnitHour;
            break;
        case 8:
            return MyRepeatIntervalUnitMinute;
            break;
        case 9:
            return MyRepeatIntervalUnitDelaySeconds;
            break;
        default:
            return MyRepeatIntervalUnitNone;
            break;
    }
}
- (NSString*)getRepeatIntervalUnitString:(NSInteger)unit
{
    if ([self currentLanguageInd] == 0)
    {
        return [NSString stringWithFormat:@"第%i",unit];
    }
    else
    {
        if (unit == 1)
             return @"1st";
        else if (unit == 2)
            return @"2nd";
        else if (unit == 3)
            return @"3rd";
        else
            return [NSString stringWithFormat:@"%ith",unit];
    }
}
- (NSString*)getRepeatIntervalDayOfWeek:(NSInteger)unit
{
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"appInfo" ofType:@"plist"];
    NSDictionary *appInfo = [[NSDictionary alloc] initWithContentsOfFile:fileName];
    NSDictionary *dict = nil;
    if ([self currentLanguageInd] == 0)
    {
        dict =[appInfo valueForKey:@"week_tw"];
    }
    else
    {
        dict = [appInfo valueForKey:@"week_en"];
    }
    NSLog(@"week:%@",[dict valueForKey:[NSString stringWithFormat:@"%i",unit]]);
    return [dict valueForKey:[NSString stringWithFormat:@"%i",unit]];
}
- (NSInteger)currentLanguageInd
{
    //zh-Hant  繁體中文
    //zh-Hans  簡體中文
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"zh-Hant"])
    {
        return 0;
    }
    else
    {
        return 1;
    }
    NSLog(@"%@",language);
}
@end
