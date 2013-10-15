//
//  MyRepeatIntervalViewController.h
//  ClockReminder
//
//  Created by 張星星 on 11/12/16.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import <UIKit/UIKit.h>

enum
{
    MyRepeatIntervalPressButtonTypeSelect = 0,
    MyRepeatIntervalPressButtonTypeCancel = 1
};
typedef NSInteger MyRepeatIntervalPressButtonType;
enum
{
    MyRepeatIntervalComponentTypeRepeatInterval = 0,
    MyRepeatIntervalComponentTypeDelayUnit = 1
};
typedef NSInteger MyRepeatIntervalComponentType;

@class MyRepeatIntervalViewController;
@protocol MyRepeatIntervalDelegate <NSObject>

- (void)MyRepeatIntervalViewController:(MyRepeatIntervalViewController*)repeatIntervalView didPressButtonIndex:(MyRepeatIntervalPressButtonType)pressButtonIndex selectedRepeatInterval:(MyRepeatIntervalUnit)repeatUnit delayUnit:(NSInteger)unit;

@end

@interface MyRepeatIntervalViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    id<MyRepeatIntervalDelegate> delegate;
    IBOutlet UIPickerView *repeatIntervalPicker;
    NSArray *repeatIntervalItems;
    MyRepeatIntervalUnit currentRepeatInterval;
    NSInteger currentDelayUnit;
    NSArray *delayUnit;
    NSDictionary *appInfoDict;
}
@property (assign) id<MyRepeatIntervalDelegate> delegate;
@property MyRepeatIntervalUnit currentRepeatInterval;
@property NSInteger currentDelayUnit;
- (IBAction)pressSelectButton:(id)sender;
- (IBAction)pressCancelButton:(id)sender;
@end
