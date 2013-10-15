//
//  PushPictureViewController.h
//  ClockReminder
//
//  Created by 張星星 on 11/12/22.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushPictureViewController : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIImageView *originalImageView;
    IBOutlet UIScrollView *originalScrollView;
    IBOutlet UILabel *memoLabel;
    NSString *imageFilePath;
    NSString *memoContent;
}
@property (nonatomic, retain) NSString *imageFilePath;
@property (nonatomic, retain) NSString *memoContent;

@end
