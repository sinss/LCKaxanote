//
//  ProcessDate.m
//  Mignon
//
//  Created by 張星星 on 11/11/1.
//  Copyright (c) 2011年 張星星. All rights reserved.
//

#import "ProcessDate.h"

static ProcessDate *_instance;

@implementation ProcessDate

+ (ProcessDate*)shareInstance
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

- (NSString*)DateToString:(NSDate*) aDate
{
    if (aDate == nil)
        return @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:aDate];
    return strDate;
}
- (NSDate*)StringToDate:(NSString*) aString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [dateFormatter dateFromString:aString];
    return date;
}
@end
