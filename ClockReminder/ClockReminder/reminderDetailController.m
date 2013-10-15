//
//  reminderDetailController.m
//  ClockReminder
//
//  Created by 張星星 on 11/12/15.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import "reminderDetailController.h"
#import "OriginalPictureController.h"
#import "reminderItem.h"
#import "GlobalFunctions.h"
#import "MKInfoPanel.h"

@interface reminderDetailController()

- (void)saveLocalNotification;
- (void)viewOriginalPicture;
- (void)askPicutreSource;
- (void)takePictureWithButtonIndex:(MyPictureSourceType)buttonIndex;
- (NSString*)makeNewkey;
- (BOOL)checkIsCanAdd;
- (void)showAlertMessage:(NSString*)message;
- (void)handleImageLocation:(CLLocation *)location;

@end

@implementation reminderDetailController

@synthesize currentReminderItem;
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, navigationBarTitleView_width, navigationBarTitleView_height)] autorelease];
        [imageView setImage:[UIImage imageNamed:@""]];
        self.navigationItem.titleView = imageView;
        if ([[GlobalFunctions shareInstance] currentLanguageInd] == 0)
            self.title = NSLocalizedString(@"詳細", @"詳細");
        else
            self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [imageInfo release], imageInfo = nil;
}
- (void)dealloc
{
    [currentReminderItem release], currentReminderItem = nil;
    [imageInfo release], imageInfo = nil;
    [super dealloc];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableviewBackground]]];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(saveLocalNotification)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
    if (currentReminderItem == nil)
    {
        currentReminderItem = [[reminderItem alloc] init];
        //建立新rKey
        currentReminderItem.repeatInterval = MyRepeatIntervalUnitSpecific;   //預設為提醒一次
        currentReminderItem.reminderTime = [NSDate date];
        currentReminderItem.imageFilePath = [[NSBundle mainBundle] pathForResource:noImageName ofType:@"png"];
        currentReminderItem.memoContent = @"";
        currentReminderItem.rKey = [self makeNewkey];
        currentReminderItem.isEnable = YES;
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return reminderTableViewCellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reminderPictureCellIdentifier = @"reminderPictureCellIden";
    static NSString *reminderMemoCellIdentifier = @"reminderMemoCellIden";
    static NSString *reminderButtonCellIdentifier = @"reminderButtonCellIden";
    static NSString *reminderOtherIdentifier = @"reminderOtherCellIden";
    
    NSUInteger row = [indexPath row];
    if (row == reminderTableViewCellTypePicture)
    {
        MyPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reminderPictureCellIdentifier];
        if (cell == nil) 
        {
            NSArray *topLevelObjects = [[NSBundle mainBundle]
                                        loadNibNamed:@"MyPictureTableViewCell"
                                        owner:self
                                        options:nil];
            for (id currentObj in topLevelObjects)
            {
                if ([currentObj isKindOfClass:[MyPictureTableViewCell class]])
                {
                    cell = currentObj;
                    break;
                }
            }
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellBackground]];
            cell.backgroundView = imageView;
            [imageView release];
        }
        [cell setButtonImage];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.reminderImageView setImage:[UIImage imageWithContentsOfFile:currentReminderItem.imageFilePath]];
        return cell;
    }
    else if (row == reminderTableViewCellTypeButton)
    {
        MyCustomButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reminderButtonCellIdentifier];
        if (cell == nil) 
        {
            NSArray *topLevelObjects = [[NSBundle mainBundle]
                                        loadNibNamed:@"MyCustomButtonTableViewCell"
                                        owner:self
                                        options:nil];
            for (id currentObj in topLevelObjects)
            {
                if ([currentObj isKindOfClass:[MyCustomButtonTableViewCell class]])
                {
                    cell = currentObj;
                    break;
                }
            }
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellBackground]];
            cell.backgroundView = imageView;
            [imageView release];
        }
        if ([[GlobalFunctions shareInstance] currentLanguageInd] == 0)
            [cell.titleLabel setText:[[GlobalFunctions shareInstance] getStringInAppInfoForKey:@"cell_savetocaneldar_tw"]];
        else
            [cell.titleLabel setText:[[GlobalFunctions shareInstance] getStringInAppInfoForKey:@"cell_savetocaneldar_en"]];
        [cell.detailTextLabel setText:[[GlobalFunctions shareInstance] repeatIntervalDisplayString:currentReminderItem.repeatInterval andDelayUunit:currentReminderItem.reminderDelayUnit]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
    else if (row == reminderTableViewCellTypeReminderMemo)
    {
        MyMemoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reminderMemoCellIdentifier];
        if (cell == nil)
        {
            NSArray *topLevelObjects = [[NSBundle mainBundle]
                                        loadNibNamed:@"MyMemoTableViewCell"
                                        owner:self
                                        options:nil];
            for (id currentObj in topLevelObjects)
            {
                if ([currentObj isKindOfClass:[MyMemoTableViewCell class]])
                {
                    cell = currentObj;
                    break;
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.memoTextField setDelegate:self];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellBackground]];
            cell.backgroundView = imageView;
            [imageView release];
        }
        [cell.memoTextField setText:currentReminderItem.memoContent];
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reminderOtherIdentifier];
        if (cell == nil) 
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reminderOtherIdentifier] autorelease];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellBackground]];
            cell.backgroundView = imageView;
            [imageView release];
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (row)
        {
            case reminderTableViewCellTypeReminderTime:
                if ([[GlobalFunctions shareInstance] currentLanguageInd] == 0)
                    [cell.textLabel setText:[[GlobalFunctions shareInstance] getStringInAppInfoForKey:@"cell_startdate_tw"]];
                else
                    [cell.textLabel setText:[[GlobalFunctions shareInstance] getStringInAppInfoForKey:@"cell_startdate_en"]];
                [cell.detailTextLabel setText:[[ProcessDate shareInstance] DateToString:currentReminderItem.reminderTime]];
                break;
            case reminderTableViewCellTypeEndReminderTime:
                if ([[GlobalFunctions shareInstance] currentLanguageInd] == 0)
                    [cell.textLabel setText:[[GlobalFunctions shareInstance] getStringInAppInfoForKey:@"cell_enddate_tw"]];
                else
                    [cell.textLabel setText:[[GlobalFunctions shareInstance] getStringInAppInfoForKey:@"cell_enddate_en"]];
                [cell.detailTextLabel setText:[[ProcessDate shareInstance] DateToString:currentReminderItem.endReminderTime]];
                break;
            case reminderTableViewCellTypeRepeatInterval:
                if ([[GlobalFunctions shareInstance] currentLanguageInd] == 0)
                    [cell.textLabel setText:[[GlobalFunctions shareInstance] getStringInAppInfoForKey:@"cell_reminderInterval_tw"]];
                else
                    [cell.textLabel setText:[[GlobalFunctions shareInstance] getStringInAppInfoForKey:@"cell_reminderInterval_en"]];
                [cell.detailTextLabel setText:[[GlobalFunctions shareInstance] repeatIntervalDisplayString:currentReminderItem.repeatInterval andDelayUunit:currentReminderItem.reminderDelayUnit]];
                break;
        }
        return cell;
    }
    return nil;
    // Configure the cell...
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    if (row == reminderTableViewCellTypePicture)
        return 230;
    else
        return 50;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    if (row == reminderTableViewCellTypeReminderTime | row == reminderTableViewCellTypeEndReminderTime)
    {
        MyDateTimePickerViewController *dateTimePickerView = [[[MyDateTimePickerViewController alloc] 
                                                              initWithNibName:@"MyDateTimePickerViewController" bundle:nil] autorelease];
        [dateTimePickerView setModalTransitionStyle:UIModalTransitionStylePartialCurl];
        [dateTimePickerView setDelegate:self];
        [dateTimePickerView setCurrentReminderDate:currentReminderItem.reminderTime];
        [dateTimePickerView setCellRow:row];
        [self presentModalViewController:dateTimePickerView animated:YES];
    }
    else if (row == reminderTableViewCellTypeRepeatInterval)
    {
        MyRepeatIntervalViewController *repeatIntervalView = [[[MyRepeatIntervalViewController alloc] initWithNibName:@"MyRepeatIntervalViewController" bundle:nil] autorelease];
        [repeatIntervalView setDelegate:self];
        repeatIntervalView.currentRepeatInterval = currentReminderItem.repeatInterval;
        repeatIntervalView.currentDelayUnit = currentReminderItem.reminderDelayUnit;
        [repeatIntervalView setModalTransitionStyle:UIModalTransitionStylePartialCurl];
        [self presentModalViewController:repeatIntervalView animated:YES];
    }
}
#pragma mark - navigationController delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController setTitle:@""];
}
#pragma mark - MyCustomButtonTableViewCell delegate
- (void)MyCustomButtonTableViewCell:(MyCustomButtonTableViewCell *)myCustomCell didPressButton:(MyCustomButtonTableViewCellType)pressButtonIndex
{
    switch (pressButtonIndex)
    {
        case MyCustomButtonTableViewCellTypeSave:
            [self saveLocalNotification];
            break;
        default:
            break;
    }
}
- (void)MyCustomButtonTableViewCell:(MyCustomButtonTableViewCell *)cell saveToEvent:(BOOL)saveInd
{
    isSaveToEKevent = saveInd;
}
#pragma mark - MyPictureTableViewCell delegate
- (void)MyPictureTableViewCell:(MyPictureTableViewCell *)cell didPressButton:(MyPictureTableViewCellButtonType)pressButtonIndex
{
    switch (pressButtonIndex)
    {
        case MyPictureTableviewCellButtonTypeViewOriginalPciture:
            [self viewOriginalPicture];
            break;
        case MyPictureTableViewCellButtonTypeTakeNewPicture:
            [self askPicutreSource];
            break;
    }
}
#pragma mark - MyDateTimePickerView delegate
- (void)MyDateTimePickerViewController:(MyDateTimePickerViewController *)dateTimePicker didPressButtonIndex:(MyDateTimePickerPressButtonType)pressButtonIndex selectedDate:(NSDate *)aDate andCellRow:(NSInteger)row
{
    NSIndexPath *newIndexPath = nil;
    NSArray *indexPathes = nil;
    if (pressButtonIndex == MyDateTimePickerPressButtonTypeSelect | pressButtonIndex == MyDateTimePickerPressButtonTypeClear)
    {
        if (row == reminderTableViewCellTypeReminderTime)
        {
            currentReminderItem.reminderTime = aDate;
            newIndexPath = [NSIndexPath indexPathForRow:reminderTableViewCellTypeReminderTime inSection:0];
            indexPathes = [NSArray arrayWithObject:newIndexPath];
        }
        else if (row == reminderTableViewCellTypeEndReminderTime)
        {
            currentReminderItem.endReminderTime = aDate;
            newIndexPath = [NSIndexPath indexPathForRow:reminderTableViewCellTypeEndReminderTime inSection:0];
            indexPathes = [NSArray arrayWithObject:newIndexPath];
        }
        
        [self.tableView reloadRowsAtIndexPaths:indexPathes withRowAnimation:UITableViewRowAnimationNone];
    }
}
#pragma mark - MyRepeatIntervalView delegate
- (void)MyRepeatIntervalViewController:(MyRepeatIntervalViewController *)repeatIntervalView didPressButtonIndex:(MyRepeatIntervalPressButtonType)pressButtonIndex selectedRepeatInterval:(MyRepeatIntervalUnit)repeatUnit delayUnit:(NSInteger)unit
{
    currentReminderItem.repeatInterval = repeatUnit;
    currentReminderItem.reminderDelayUnit = unit;
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:reminderTableViewCellTypeRepeatInterval inSection:0];
    NSArray *indexPathes = [NSArray arrayWithObject:newIndexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathes withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *memo = [[NSString alloc] initWithFormat:@"%@",textField.text];
    [currentReminderItem setMemoContent:memo];
    [textField resignFirstResponder];
    [memo release];
    return YES;
}
#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self takePictureWithButtonIndex:buttonIndex];
}
#pragma mark - UIImagePickerControllerDelegate
//新的方法

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    [picker dismissModalViewControllerAnimated:YES];
    if ([mediaType isEqualToString:@"public.image"])
    {
        UIImage *resultImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        resultImage = [resultImage fixOrientation];
        //將照片儲存至圖庫
        //UIImageWriteToSavedPhotosAlbum(resultImage,self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
         
        [self performSelectorOnMainThread:@selector(image:didFinishSavingWithError:contextInfo:) withObject:resultImage waitUntilDone:YES];
    }
    else if ([mediaType isEqualToString:@"public.movie"])
    {
        NSString *movieFilePath = [[info objectForKey:UIImagePickerControllerOriginalImage]
                                   path];
        [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeError title:@"Warning!" subtitle:movieFilePath hideAfter:2];
    }
}

/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"])
    {
        //將照片儲存至圖庫
        imageInfo = info;
        [imageInfo retain];
        NSURL *url = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            // Get the location property from the asset  
            CLLocation *location = [myasset valueForProperty:ALAssetPropertyLocation];
            // I found that the easiest way is to send the location to another method
            [self handleImageLocation:location];
        };
        ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
        {
            NSLog(@"Can not get asset - %@",[myerror localizedDescription]);
            // Do something to handle the error
        };
        ALAssetsLibrary* assetslibrary = [[[ALAssetsLibrary alloc] init] autorelease];
        [assetslibrary assetForURL:url 
                       resultBlock:resultblock
                      failureBlock:failureblock];
    }
    else if ([mediaType isEqualToString:@"public.movie"])
    {
        NSString *movieFilePath = [[info objectForKey:UIImagePickerControllerMediaURL]
                                   path];
        NSLog(@"moviePath:%@",movieFilePath);
        [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeError title:@"Warning!" subtitle:@"Please select a picture" hideAfter:2];
    }
    [picker dismissModalViewControllerAnimated:YES];
}
*/
#pragma mark - user define functions
- (BOOL)checkIsCanAdd
{
    //必須設定開啟曰期
    BOOL isRight = YES;
    NSMutableString *errorString = [[NSMutableString alloc] init];
    if (currentReminderItem.reminderTime == nil)
    {
        if ([[GlobalFunctions shareInstance] currentLanguageInd] == 0)
            [errorString appendFormat:[[GlobalFunctions shareInstance] getStringInAppInfoForKey:@"error002_tw"]];
        else
            [errorString appendFormat:[[GlobalFunctions shareInstance] getStringInAppInfoForKey:@"error002_en"]];
        isRight = NO;
    }
    else
    {
        if (currentReminderItem.endReminderTime != nil)
        {
            //結束曰期不可大於終止曰期
            NSTimeInterval interval = [currentReminderItem.reminderTime timeIntervalSinceDate:currentReminderItem.endReminderTime];
            if (interval > 0)
            {
                if ([[GlobalFunctions shareInstance] currentLanguageInd] == 0)
                    [errorString appendFormat:[[GlobalFunctions shareInstance] getStringInAppInfoForKey:@"error001_tw"]];
                else
                    [errorString appendFormat:[[GlobalFunctions shareInstance] getStringInAppInfoForKey:@"error001_en"]];
                isRight = NO;
            }
        }
    }
    if (!isRight)
    {
        [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeError title:@"Warning!" subtitle:errorString hideAfter:2];
    }
    return isRight;
}
- (void)showAlertMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}
//儲存本機通知
- (void)saveLocalNotification
{   if ([self checkIsCanAdd])
    {
        [delegate reminderDetailController:self didPressSaveWithReminderItem:currentReminderItem isSaveToEvent:isSaveToEKevent];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewOriginalPicture
{
    OriginalPictureController *originalView = [[[OriginalPictureController alloc] initWithNibName:@"OriginalPictureController" bundle:nil] autorelease];
    [originalView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    originalView.imageFilePath = currentReminderItem.imageFilePath;
    originalView.memoContent = currentReminderItem.memoContent;
    [self presentModalViewController:originalView animated:YES];
    
}
- (void)askPicutreSource
{
    //takepicture_tw
    //photoalbum_tw
    //cancel_tw
    //phototitle_tw
    NSString *titleString = nil;
    NSString *takePictureString = nil;
    NSString *photoAlbumString = nil;
    NSString *cancelString = nil;
    if ([[GlobalFunctions shareInstance] currentLanguageInd] == 0)
    {
        titleString = [[NSString alloc] initWithFormat:@"%@",[[GlobalFunctions shareInstance] getStringInAppInfoForKey:@"phototitle_tw"]];
        takePictureString = [[NSString alloc] initWithFormat:@"%@",[[GlobalFunctions shareInstance] getStringInAppInfoForKey:@"takepicture_tw"]];
        photoAlbumString = [[NSString alloc] initWithFormat:@"%@",[[GlobalFunctions shareInstance] getStringInAppInfoForKey:@"photoalbum_tw"]];
        cancelString = [[NSString alloc] initWithFormat:@"%@",[[GlobalFunctions shareInstance] getStringInAppInfoForKey:@"cancel_tw"]];
    }
    else
    {
        titleString = [[NSString alloc] initWithFormat:@"%@",[[GlobalFunctions shareInstance] getStringInAppInfoForKey:@"phototitle_en"]];
        takePictureString = [[NSString alloc] initWithFormat:@"%@",[[GlobalFunctions shareInstance] getStringInAppInfoForKey:@"takepicture_en"]];
        photoAlbumString = [[NSString alloc] initWithFormat:@"%@",[[GlobalFunctions shareInstance] getStringInAppInfoForKey:@"photoalbum_en"]];
        cancelString = [[NSString alloc] initWithFormat:@"%@",[[GlobalFunctions shareInstance] getStringInAppInfoForKey:@"cancel_en"]];

    }
    UIActionSheet *actionsheet = [[[UIActionSheet alloc] 
                                  initWithTitle:titleString
                                  delegate:self                  
                                  cancelButtonTitle:cancelString
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:takePictureString,photoAlbumString, nil] autorelease];
    [actionsheet showFromTabBar:self.tabBarController.tabBar];
    //[actionsheet showInView:self.view];
}
- (NSString*)makeNewkey
{
    NSString *rKey = [[GlobalFunctions shareInstance] getStringInAppInfoForKey:reminderKeyCurrentNumber];
    return rKey;
}
- (void)takePictureWithButtonIndex:(MyPictureSourceType)buttonIndex
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.navigationItem.title = @"";
	picker.delegate = self;
    picker.mediaTypes = [NSArray arrayWithObjects:@"public.image",nil];
	if(buttonIndex == MyPictureSourceTypePhotoLibrary)
    {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentModalViewController:picker animated:YES];
    }
    else if (buttonIndex == MyPictureSourceTypeCamera)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
        {
            [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeError title:@"Warning!" subtitle:@"Device doesn't support camera" hideAfter:2];
        }
        else
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentModalViewController:picker animated:YES];
        }	
	}	
    /*
    UIImagePickerController *aImagePicker;
    customCameraView *cameraView = [[customCameraView alloc] init];
    if (buttonIndex == MyPictureSourceTypeCamera)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
        {
            [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeError title:@"Warning!" subtitle:@"Device doesn't support camera" hideAfter:2];
        }
        else
        {
            aImagePicker = [[UIImagePickerController alloc] init];
            
            aImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            aImagePicker.mediaTypes = [NSArray arrayWithObjects:@"public.image",nil];
            //aImagePicker.allowsEditing = YES;
            aImagePicker.delegate = self;
            aImagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            [self presentModalViewController:aImagePicker animated:YES];
            
            [aImagePicker release];
        }
    }
    else if (buttonIndex == MyPictureSourceTypePhotoLibrary)
    {
        aImagePicker = [[UIImagePickerController alloc] init];
        
        aImagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        aImagePicker.mediaTypes = [NSArray arrayWithObjects:@"public.image",nil];
        aImagePicker.view.bounds = CGRectMake(0, 0, 320, 460);
        //aImagePicker.allowsEditing = YES;
        aImagePicker.delegate = self;
        [self presentModalViewController:aImagePicker animated:YES];
        
        [aImagePicker release];
    }
     */
}
//saving picture to photoLibrary
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(NSDictionary*)info
{
    //同時將照片儲存至document資料夾中，同時更新pictureCell
    NSString *imageFilePath = [[GlobalFunctions shareInstance] getDocumentFullPath:[NSString stringWithFormat:@"%@.png",currentReminderItem.rKey]];
    [[ProcessImage shareInstance] saveImage:image imageName:imageFilePath];
    currentReminderItem.imageFilePath = imageFilePath;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationNone];

    [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeInfo title:@"Information!" subtitle:@"Photo saved!" hideAfter:2];
    
}
- (void)handleImageLocation:(CLLocation *)location 
{
    UIImage *image = [imageInfo objectForKey:UIImagePickerControllerOriginalImage];
    //同時將照片儲存至document資料夾中，同時更新pictureCell
    NSString *imageFilePath = [[GlobalFunctions shareInstance] getDocumentFullPath:[NSString stringWithFormat:@"%@.png",currentReminderItem.rKey]];
    [[ProcessImage shareInstance] saveImage:image imageName:imageFilePath];
    currentReminderItem.imageFilePath = imageFilePath;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationNone];
    
    [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeInfo title:@"Information!" subtitle:@"Photo saved!" hideAfter:2];
    // Do something with the image and location data...
}
@end
