//
//  GlobalFunctions.h
//  ClockReminder
//
//  Created by 張星星 on 11/12/16.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProcessImage.h"
#import "ProcessDate.h"
#import "ProcessNotification.h"

@interface GlobalFunctions : NSObject

+(GlobalFunctions*)shareInstance;

-(NSString*) getUserDefaultsforKey:(NSString*)key DefValue:(NSString*)value;
-(void) writeUserDefaultsValue:(NSString*)value Key:(NSString*)key;
-(void) saveDefualtFile;


- (NSString*)getStringInAppInfoForKey:(NSString*)key;
- (id)getArrayInAppInfoForKey:(NSString*)key;
- (void)saveAppInfoWithKey:(NSString*)key andValue:(NSString*)value;
- (void)saveAppInfoWithKey:(NSString *)key andArray:(NSArray*)array;
- (NSString*)getDocumentFullPath:(NSString*)fileName;
- (NSArray*)getReminderKeyList;
- (NSDictionary*)getReminderDictionary;
- (BOOL)saveReminderKeyList:(NSArray*)keyList;
- (BOOL)saveReminderDictionary:(NSDictionary*)reminderDict;
- (NSString*)repeatIntervalName:(MyRepeatIntervalUnit)unit;
- (NSString*)repeatIntervalDisplayString:(MyRepeatIntervalUnit)repeatIntervalUnit andDelayUunit:(NSInteger)unit;
- (MyRepeatIntervalUnit)repeatIntervalValue:(NSInteger)unitNo;
- (NSString*)getRepeatIntervalUnitString:(NSInteger)unit;
- (NSString*)getRepeatIntervalDayOfWeek:(NSInteger)unit;
- (NSInteger)currentLanguageInd;

@end
