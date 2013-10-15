//
//  AppDelegate.m
//  ClockReminder
//
//  Created by 張星星 on 11/12/14.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "GlobalFunctions.h"
#import "MKLocalNotificationsScheduler.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize aboutmeNavitagionController = _aboutmeNavitagionController;
@synthesize tabController = _tabController;
- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [_tabController release];
    [_aboutmeNavitagionController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.tabController = [[UITabBarController alloc] init];
    MasterViewController *masterViewController = [[[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil] autorelease];
    AboutmeViewController *aboutmeViewController = [[[AboutmeViewController alloc] initWithNibName:@"AboutmeViewController" bundle:nil] autorelease];
   
    //self.tabBarContoroller.viewControllers = [NSArray arrayWithObject:masterViewController];
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
    self.aboutmeNavitagionController = [[[UINavigationController alloc] initWithRootViewController:aboutmeViewController] autorelease];
    self.aboutmeNavitagionController.navigationBar.tintColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    self.tabController.viewControllers =[NSArray arrayWithObjects:self.navigationController, self.aboutmeNavitagionController, nil];
    self.window.rootViewController = self.tabController;
    [self.window makeKeyAndVisible];
    
    UIDevice *device = [UIDevice currentDevice];
    double  ver = [[device systemVersion] floatValue];
    if (ver >= 5.0)
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:navigationBarBackground] forBarMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:navigationBarButtonColor];
        [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:toolbarBackground] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil] setTintColor:toolBarButtonColor];
    }
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
	
    if (localNotification) 
	{
		[[MKLocalNotificationsScheduler sharedInstance] handleReceivedNotification:localNotification];
        [[NSNotificationCenter defaultCenter] postNotificationName:receiveLocalNotificationKey object:self userInfo:localNotification.userInfo];
    }
    [NSThread sleepForTimeInterval:1];
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"%@",language);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
    //1
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
    //2
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    
    //3
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    //4
    //應用程式每次都會進入的工作區，將數字清除。
    [[MKLocalNotificationsScheduler sharedInstance] clearBadgeCount];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}
#pragma mark - receive local Notification
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0)
{
    //將local notification產生的rKey儲存
    NSLog(@"memo:%@",[[notification userInfo] valueForKey:reminderKeyRkey]);
    //[[NSNotificationCenter defaultCenter] postNotificationName:receiveLocalNotificationKey object:notification];
    [[NSNotificationCenter defaultCenter] postNotificationName:receiveLocalNotificationKey object:self userInfo:notification.userInfo];
    [[MKLocalNotificationsScheduler sharedInstance] handleReceivedNotification:notification]; 
}

@end










