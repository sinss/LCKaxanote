//
//  ProcessDate.h
//  Mignon
//
//  Created by 張星星 on 11/11/1.
//  Copyright (c) 2011年 張星星. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProcessDate : NSObject
{

}
+ (ProcessDate*)shareInstance;
- (NSString*)DateToString:(NSDate*) aDate;
- (NSDate*)StringToDate:(NSString*) aString;
@end
