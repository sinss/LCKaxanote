//
//  MyDateTimePickerViewController.h
//  ClockReminder
//
//  Created by 張星星 on 11/12/16.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import <UIKit/UIKit.h>

enum
{
    MyDateTimePickerPressButtonTypeSelect = 0,
    MyDateTimePickerPressButtonTypeCancel = 1,
    MyDateTimePickerPressButtonTypeClear = 2
};
typedef NSInteger MyDateTimePickerPressButtonType;

@class MyDateTimePickerViewController;
@protocol MyDateTimePickerDelegate <NSObject>

- (void)MyDateTimePickerViewController:(MyDateTimePickerViewController*)dateTimePicker didPressButtonIndex:(MyDateTimePickerPressButtonType)pressButtonIndex selectedDate:(NSDate*)aDate andCellRow:(NSInteger)row;

@end

@interface MyDateTimePickerViewController : UIViewController
{
    id<MyDateTimePickerDelegate> delegate;
    IBOutlet UIDatePicker *datePicker;
    NSDate *currentReminderDate;
    NSInteger cellRow;
}
@property (assign) id<MyDateTimePickerDelegate> delegate;
@property (nonatomic, retain) NSDate *currentReminderDate;
@property NSInteger cellRow;

- (IBAction)pressSelectButton:(id)sender;
- (IBAction)pressCancelButton:(id)sender;
- (IBAction)pressClearButton:(id)sender;
@end
