//
//  AppDelegate.h
//  ClockReminder
//
//  Created by 張星星 on 11/12/14.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutmeViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UINavigationController *aboutmeNavitagionController;


@property (strong, nonatomic) UITabBarController *tabController;

@end
