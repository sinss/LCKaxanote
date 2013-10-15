//
//  reminderDetailController.h
//  ClockReminder
//
//  Created by 張星星 on 11/12/15.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/ALAsset.h>
#import <CoreLocation/CoreLocation.h>
#import "MyPictureTableViewCell.h"
#import "MyMemoTableViewCell.h"
#import "MyCustomButtonTableViewCell.h"
#import "MyDateTimePickerViewController.h"
#import "MyRepeatIntervalViewController.h"
#import "UIImage+Resize.h"

#define reminderTableViewCellCount 6

enum 
{
    reminderTableViewCellTypePicture = 0,
    reminderTableViewCellTypeReminderTime = 1,
    reminderTableViewCellTypeEndReminderTime = 2,
    reminderTableViewCellTypeRepeatInterval = 3,
    reminderTableViewCellTypeReminderMemo = 4,
    reminderTableViewCellTypeButton = 5,
};
typedef NSUInteger reminderTableViewCellType;

@class reminderItem;
@class reminderDetailController;
@protocol reminderDetailDelegate <NSObject>

- (void)reminderDetailController:(reminderDetailController*)detailController didPressSaveWithReminderItem:(reminderItem*)newReminderItem isSaveToEvent:(BOOL)saveInd;

@end

@interface reminderDetailController : UITableViewController
<MyCustomButtonTableViewCellDelegate, 
MyPictureTableViewCellDelegate,
MyDateTimePickerDelegate,
MyRepeatIntervalDelegate,
UITextFieldDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>
{
    id<reminderDetailDelegate> delegate;
    reminderItem *currentReminderItem;
    BOOL isSaveToEKevent;
    NSDictionary *imageInfo;
}
@property (assign) id<reminderDetailDelegate> delegate;
@property (nonatomic, retain) reminderItem *currentReminderItem;


@end
