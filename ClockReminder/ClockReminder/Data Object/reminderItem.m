//
//  reminderItem.m
//  ClockReminder
//
//  Created by 張星星 on 11/12/14.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import "reminderItem.h"
#import "ProcessDate.h"

static reminderItem *_instance;

@implementation reminderItem

@synthesize rKey;
@synthesize reminderTime;
@synthesize endReminderTime;
@synthesize repeatInterval;
@synthesize reminderDelayUnit;
@synthesize imageFilePath;
@synthesize image;
@synthesize memoContent;
@synthesize isEnable;

- (id)init
{
    if (self = [super init])
    {

    }
    return self;
}

- (void)dealloc
{
    [rKey release], rKey = nil;
    [reminderTime release], reminderTime = nil;
    [endReminderTime release], endReminderTime = nil;
    [imageFilePath release], imageFilePath = nil;
    [image release], image = nil;
    [memoContent release], memoContent = nil;
    [super dealloc];
}

+ (reminderItem*) shareInstance
{
    @synchronized(self)
    {
        if (_instance == nil)
        {
             _instance = [[super allocWithZone:NULL] init];
        }
    }
    return _instance;
}

#pragma mark - user define function
- (NSDictionary*)createDictionaryWithReminderItem:(reminderItem*)item
{
    NSLog(@"1:%@",item.imageFilePath);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:8];
    [dict setObject:item.rKey forKey:reminderKeyRkey];
    [dict setObject:[[ProcessDate shareInstance] DateToString:item.reminderTime] forKey:reminderKeyReminderTime];
    [dict setObject:[[ProcessDate shareInstance] DateToString:item.endReminderTime] forKey:reminderKeyEndReminderTime];
    [dict setObject:[NSString stringWithFormat:@"%i",item.repeatInterval] forKey:reminderKeyRepeatInterval];
    [dict setObject:[NSString stringWithFormat:@"%i",item.reminderDelayUnit] forKey:reminderKeyReminderDelayUnit];
    [dict setObject:[NSString stringWithFormat:@"%@",item.imageFilePath] forKey:reminderKeyImageFilePath];
    [dict setObject:[NSString stringWithFormat:@"%@",(item.isEnable?@"YES":@"NO")] forKey:reminderKeyIsEnable];
    [dict setObject:[NSString stringWithFormat:@"%@",item.memoContent] forKey:reminderKeyMemoContent];
    
    NSLog(@"1-1:%@",[dict objectForKey:reminderKeyImageFilePath]);
    return dict;
}
- (reminderItem*)createReminderItemWithDictionary:(NSDictionary*)dict
{
    reminderItem *item = [[reminderItem alloc] init];
    item.rKey = [dict objectForKey:reminderKeyRkey];
    //NSLog(@"2:%@",[dict objectForKey:reminderKeyMemoContent]);
    item.reminderTime = [[ProcessDate shareInstance] StringToDate:[dict objectForKey:reminderKeyReminderTime]];
    item.endReminderTime = [[ProcessDate shareInstance] StringToDate:[dict objectForKey:reminderKeyEndReminderTime]];
    item.repeatInterval = [[dict objectForKey:reminderKeyRepeatInterval] intValue];
    item.reminderDelayUnit = [[dict objectForKey:reminderKeyReminderDelayUnit] intValue];
    item.imageFilePath = [dict objectForKey:reminderKeyImageFilePath];
    item.memoContent = [dict objectForKey:reminderKeyMemoContent];
    item.isEnable = [[dict objectForKey:reminderKeyIsEnable] boolValue];
    
    return item;
}
@end
