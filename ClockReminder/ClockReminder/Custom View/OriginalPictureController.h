//
//  OriginalPictureController.h
//  ClockReminder
//
//  Created by 張星星 on 11/12/15.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OriginalPictureController : UIViewController <UIScrollViewDelegate>
{

    IBOutlet UIImageView *originalImageView;
    IBOutlet UIScrollView *originalScrollView;
    IBOutlet UILabel *memoLabel;
    NSString *imageFilePath;
    NSString *memoContent;
}
@property (nonatomic, retain) NSString *imageFilePath;
@property (nonatomic, retain) NSString *memoContent;

- (IBAction)closeViewPress:(id)sender;
@end
