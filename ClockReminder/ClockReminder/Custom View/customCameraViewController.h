//
//  customCameraViewController.h
//  ClockReminder
//
//  Created by 張星星 on 12/2/9.
//  Copyright (c) 2012年 星星. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/ALAsset.h>
#import "MKInfoPanel.h"

enum
{
    customCameraButtonOptionTakePicture = 0,
    customCameraButtonOptionPhotoLibrary = 1
};
typedef NSInteger customCameraButtonOption;

@interface customCameraViewController : UIViewController
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate>
{
    
}

@end
