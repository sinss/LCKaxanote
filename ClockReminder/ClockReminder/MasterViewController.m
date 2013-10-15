//
//  MasterViewController.m
//  ClockReminder
//
//  Created by 張星星 on 11/12/14.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "reminderItem.h"
#import "GlobalFunctions.h"
#import "ProcessDate.h"
#import "OriginalPictureController.h"
#import "MKInfoPanel.h"

@interface MasterViewController()

- (void)createAddBarButton;
- (void)reloadSaveData;
- (void)registerLocalNotification:(NSIndexPath*)indexPath;
- (void)cancelLocalNotification:(NSIndexPath*)indexPath;
- (void)resetLocalNotification;
- (void)saveReminderItem:(reminderItem*)item;
- (void)navigateToNotification:(NSString*)rKey;
- (void)didReceiveNotification:(NSNotification*)notification;
- (void)pushReminderViewControllerWithKey:(NSString*)rKey;
- (void)pushToOriginalPictureController:(NSString*)rKey;
- (void)saveToEKEvent:(reminderItem*)item;

@end
@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        if ([[GlobalFunctions shareInstance] currentLanguageInd] == 0)
            self.tabBarItem.title = @"KaxaNote";
        else
            self.tabBarItem.title = @"KaxaNote";
        
        self.tabBarItem.image = [UIImage imageNamed:tabbarKaxanoteImage];
    }
    
    return self;
}
							
- (void)dealloc
{
    [reminderDetail release], reminderDetail = nil;
    [reminderKeyList release], reminderKeyList = nil;
    [reminderDict release], reminderDict = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.editButtonItem.tintColor = [UIColor colorWithRed:0.078 green:0.46274 blue:0.6745098 alpha:1];
    self.editButtonItem.title = @"Edit";
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    [self createAddBarButton];
    //載入儲存的 reminderFile
    [self reloadSaveData];
    if (reminderDict == nil | reminderKeyList == nil)
    {
        reminderDict = [[NSDictionary alloc] init];
        reminderKeyList = [[NSArray alloc] init];
    }
    self.tableView.sectionIndexMinimumDisplayRowCount = [reminderKeyList count];
    [self performSelectorOnMainThread:@selector(resetLocalNotification) withObject:nil waitUntilDone:YES];
    //self.navigationController.view.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1];
    //self.tableView.backgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:receiveLocalNotificationKey object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self   name:receiveLocalNotificationKey object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //增加你好歡迎你回來我是
    if ([reminderKeyList count] == 0)
        [self.editButtonItem setEnabled:NO];
    else
        [self.editButtonItem setEnabled:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return NO;
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing)
    {
        self.editButtonItem.title = @"Done";
    }
    else
    {
        self.editButtonItem.title = @"Edit";
    }
}
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [reminderKeyList count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reminderMasterCell = @"reminderMasterCell";
    NSUInteger row = [indexPath row];
    MyMasterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reminderMasterCell];
    if (cell == nil) 
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle]
                                    loadNibNamed:@"MyMasterTableViewCell"
                                    owner:self
                                    options:nil];
        for (id currentObj in topLevelObjects)
        {
            if ([currentObj isKindOfClass:[MyMasterTableViewCell class]])
            {
                cell = currentObj;
                break;
            }
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setDelegate:self];
    }
    NSString *rKey = [reminderKeyList objectAtIndex:row];
    NSDictionary *dict = [reminderDict valueForKey:rKey];
    reminderItem *item = [[reminderItem shareInstance] createReminderItemWithDictionary:dict];
    cell.rKey = rKey;
    if (item.reminderTime != nil)
        [cell.reminderTimeLabel setText:[[ProcessDate shareInstance] DateToString:item.reminderTime]];
    else
        [cell.reminderTimeLabel setText:@""];
    if (item.endReminderTime == nil)
        [cell.endReminderTimeLabel setText:@""];
    else
        [cell.endReminderTimeLabel setText:[[ProcessDate shareInstance] DateToString:item.endReminderTime]];
    [cell.repeatIntervalLabel setText:[[GlobalFunctions shareInstance] repeatIntervalDisplayString:item.repeatInterval andDelayUunit:item.reminderDelayUnit]];
    if (item.memoContent != nil)
        [cell.memoLabel setText:item.memoContent];
    else
        [cell.memoLabel setText:@"Need Memo"];
    [cell.aSwitch setOn:item.isEnable];
    [item release];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Detemine if it's in editing mode
    if (self.editing) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        //先移除Notification
        NSInteger row = [indexPath row];
        //[self cancelLocalNotification:indexPath];
        // Delete the row from the data source.
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[GlobalFunctions shareInstance] getReminderDictionary]];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[[GlobalFunctions shareInstance] getReminderKeyList]];
        NSString *rKey = [array objectAtIndex:row];
        [array removeObjectAtIndex:row];
        [dict removeObjectForKey:rKey];
        reminderKeyList = array;
        reminderDict = dict;
        [[GlobalFunctions shareInstance] saveReminderDictionary:reminderDict];
        [[GlobalFunctions shareInstance] saveReminderKeyList:reminderKeyList];
        self.tableView.sectionIndexMinimumDisplayRowCount = [reminderKeyList count];
        [tableView beginUpdates];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:[indexPath row] inSection:[indexPath section]];
        NSArray *indexpathes = [NSArray arrayWithObject:newIndexPath];
        [tableView deleteRowsAtIndexPaths:indexpathes withRowAnimation:UITableViewRowAnimationRight];
        [tableView endUpdates];
        [self reloadSaveData];
        [self resetLocalNotification];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
    if ([reminderKeyList count] == 0)
    {
        [self.editButtonItem setEnabled:NO];
        [self setEditing:NO animated:YES];
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *rKey = [reminderKeyList objectAtIndex:([indexPath row])];
    [self pushReminderViewControllerWithKey:rKey];
}
#pragma mark - reminderDetailController delegate
- (void)reminderDetailController:(reminderDetailController *)detailController didPressSaveWithReminderItem:(reminderItem *)newReminderItem isSaveToEvent:(BOOL)saveInd
{
    /*
     1.新增NewReminderItem至dictionary中，首次新增預設為啟用
     2.更新Cell
    */
    //新增
    NSMutableArray *mutableKeyList = [[NSMutableArray alloc] initWithArray:reminderKeyList];
    NSMutableDictionary *mutableReminderList = [[NSMutableDictionary alloc] initWithDictionary:reminderDict];
    NSLog(@"rKey:%@",newReminderItem.rKey);
    NSDictionary *dict = [reminderDict valueForKey:newReminderItem.rKey];
    if (dict == nil)
    {
        [mutableKeyList addObject:newReminderItem.rKey];
        [mutableReminderList setObject:[[reminderItem shareInstance] createDictionaryWithReminderItem:newReminderItem] forKey:newReminderItem.rKey];
        reminderKeyList = mutableKeyList;
        reminderDict = mutableReminderList;
        NSIndexPath *newIndex = [NSIndexPath indexPathForRow:[reminderKeyList count] - 1 inSection:0];
        [self.tableView beginUpdates];
        
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndex] 
                              withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];

        //新增cell
        //儲存物件
        BOOL saveInd1 = [[GlobalFunctions shareInstance] saveReminderKeyList:reminderKeyList];
        BOOL saveInd2 = [[GlobalFunctions shareInstance] saveReminderDictionary:reminderDict];
        if (saveInd1 & saveInd2)
        {
            NSInteger currNo = [newReminderItem.rKey intValue] + 1;
            [[GlobalFunctions shareInstance] saveAppInfoWithKey:reminderKeyCurrentNumber andValue:[NSString stringWithFormat:@"%i",currNo]];
            [self registerLocalNotification:newIndex];
        }
    }
    else
    {
        //先移除先前嚨註冊之Notification
        NSInteger row = [reminderKeyList indexOfObject:newReminderItem.rKey];
        [self cancelLocalNotification:[NSIndexPath indexPathForRow:row inSection:0]];
        //取代先前之物件
        dict = [[reminderItem shareInstance] createDictionaryWithReminderItem:newReminderItem];
        [mutableReminderList setObject:dict forKey:newReminderItem.rKey];
        reminderDict = mutableReminderList;
        [[GlobalFunctions shareInstance] saveReminderDictionary:reminderDict];
        NSIndexPath *newIndex = [NSIndexPath indexPathForRow:row inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:newIndex] withRowAnimation:UITableViewRowAnimationNone];
        if (newReminderItem.isEnable)
            [self registerLocalNotification:newIndex];
        //修改cell
    }
    if (saveInd)
    {
        //儲存至行事曆
        [self saveToEKEvent:newReminderItem];
    }
    [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeInfo title:@"Information!" subtitle:@"kaxanote Saved Succeed!" hideAfter:2];
    //[self.tableView reloadData];
}
#pragma mark - MyMasterTableViewCell delegate
- (void)MyMasterTableViewCell:(MyMasterTableViewCell *)cell switchValueChange:(BOOL)changeValue
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (changeValue)
    {
        //YES
        [self registerLocalNotification:indexPath];
    }
    else
    {
        //NO
        [self cancelLocalNotification:indexPath];
    }
}
#pragma mark - EKEventEditing delegate
-(void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action 
{
    
    switch (action) {
		case EKEventEditViewActionCanceled:
			// Adding the event was cancelled. 
			break;
			
		case EKEventEditViewActionSaved:
			// The event was saved
			break;
			
		case EKEventEditViewActionDeleted:
			// The event was deleted
			break;
			
		default:
			break;
	}
    
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark - user define functions
- (void) createAddBarButton
{
    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] 
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                  target:self 
                                  action:@selector(addNewReminderItem)] autorelease];
    self.navigationItem.rightBarButtonItem = addButton;
}
- (void)addNewReminderItem
{
    reminderDetail = [[[reminderDetailController alloc] initWithStyle:UITableViewStyleGrouped] autorelease]; 
    reminderDetail.delegate = self;
    [self.navigationController pushViewController:reminderDetail animated:YES];
}
- (void) reloadSaveData
{
    reminderDict = [[[GlobalFunctions shareInstance] getReminderDictionary] retain];
    reminderKeyList = [[[GlobalFunctions shareInstance] getReminderKeyList] retain];
}

//註冊本機通知
- (void) registerLocalNotification:(NSIndexPath*)indexPath
{
    ProcessNotification *notification = [[ProcessNotification alloc] init];
    NSString *rKey = [reminderKeyList objectAtIndex:[indexPath row]];
    NSDictionary *dict = [reminderDict valueForKey:rKey];
    reminderItem *item = [[reminderItem shareInstance] createReminderItemWithDictionary:dict];
    [notification registerLocalNotificationWithDate:item.reminderTime endReminderDate:item.endReminderTime andMemo:item.memoContent andMyRepeatIntervalUnit:item.repeatInterval andKey:item.rKey andDelayUnit:item.reminderDelayUnit];
    [notification release];
    item.isEnable = YES;
    [self saveReminderItem:item];
}
//取消註冊本機通知
- (void) cancelLocalNotification:(NSIndexPath*)indexPath
{
    NSInteger row = [indexPath row] ;
    ProcessNotification *notification = [[ProcessNotification alloc] init];
    NSString *rKey = [reminderKeyList objectAtIndex:row];
    NSDictionary *dict = [reminderDict valueForKey:rKey];
    reminderItem *item = [[reminderItem shareInstance] createReminderItemWithDictionary:dict];
    [notification removeLocalNotificationWithDate:item.reminderTime endReminderDate:item.endReminderTime andMemo:item.memoContent andMyRepeatIntervalUnit:item.repeatInterval andKey:item.rKey andDelayUnit:item.reminderDelayUnit];
    [notification release];
    item.isEnable = NO;
    [self saveReminderItem:item];
}
- (void)resetLocalNotification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    for (NSString *rKey in reminderKeyList)
    {
        NSInteger row = [reminderKeyList indexOfObject:rKey];
        NSDictionary *dict = [reminderDict valueForKey:rKey];
        reminderItem *item = [[reminderItem shareInstance] createReminderItemWithDictionary:dict];
        if ([item isEnable])
        {
            [self registerLocalNotification:[NSIndexPath indexPathForRow:row inSection:0]];
        }
    }
}
- (void)saveReminderItem:(reminderItem*)item
{
    //儲存switch狀態
    NSDictionary *dict = [[reminderItem shareInstance] createDictionaryWithReminderItem:item];
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] initWithDictionary:[[GlobalFunctions shareInstance] getReminderDictionary]];
    [mutableDict setObject:dict forKey:item.rKey];
    reminderDict = mutableDict;
    [[GlobalFunctions shareInstance] saveReminderDictionary:reminderDict];
}
- (void)navigateToNotification:(NSString*)rKey
{
    if (rKey != nil)
    {
        [self pushReminderViewControllerWithKey:rKey];
    }
}
- (void)didReceiveNotification:(NSNotification *)notification
{
    NSLog(@"rKey:%@",[[notification userInfo] valueForKey:reminderKeyRkey]);
    NSString *rKey = [notification.userInfo valueForKey:reminderKeyRkey];
    [self pushToOriginalPictureController:rKey];
}
- (void)pushReminderViewControllerWithKey:(NSString*)rKey
{
    NSDictionary *dict = [reminderDict objectForKey:rKey];
    reminderItem *item = [[reminderItem shareInstance] createReminderItemWithDictionary:dict];
    reminderDetail = [[[reminderDetailController alloc] initWithStyle:UITableViewStyleGrouped] autorelease]; 
    reminderDetail.currentReminderItem = item;
    reminderDetail.delegate = self;
    [self.navigationController pushViewController:reminderDetail animated:YES];
}
- (void)pushToOriginalPictureController:(NSString*)rKey
{
    NSDictionary *dict = [reminderDict objectForKey:rKey];
    reminderItem *item = [[reminderItem shareInstance] createReminderItemWithDictionary:dict];
    /*
    PushPictureViewController *pushPictureView = [[[PushPictureViewController alloc] initWithNibName:@"PushPictureViewController" bundle:nil] autorelease];
    [pushPictureView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    pushPictureView.imageFilePath = item.imageFilePath;
    pushPictureView.memoContent = item.memoContent;
    [self.navigationController pushViewController:pushPictureView animated:YES];
    */
    OriginalPictureController *originalView = [[OriginalPictureController alloc] initWithNibName:@"OriginalPictureController" bundle:nil];
    originalView.imageFilePath = item.imageFilePath;
    originalView.memoContent = item.memoContent;
    [self presentModalViewController:originalView animated:YES];
}
- (void)saveToEKEvent:(reminderItem *)item
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    EKEvent *myEvent  = [EKEvent eventWithEventStore:eventStore];
	myEvent.title = @"kaxanote";
    myEvent.notes = item.memoContent;
    NSDate *startDate = item.reminderTime;
    NSDate *endDate = item.endReminderTime;
    
    [myEvent setStartDate:startDate];
    if (endDate != nil)
        [myEvent setEndDate:endDate];
    else
        [myEvent setEndDate:[startDate dateByAddingTimeInterval:10]];
    //NSTimeInterval secondsInOneHour = 60 * 60;
    
    //[myEvent setEndDate:[startDate dateByAddingTimeInterval:secondsInOneHour]];  
    
    [myEvent setCalendar:[eventStore defaultCalendarForNewEvents]];
    
    NSError *err;
    [eventStore saveEvent:myEvent span:EKSpanFutureEvents error:&err];
    
    if(err)
    {
        NSLog(@"%@",err);
    }
    [eventStore release];
}
@end
