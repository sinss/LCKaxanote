//
//  customCameraViewController.m
//  ClockReminder
//
//  Created by 張星星 on 12/2/9.
//  Copyright (c) 2012年 星星. All rights reserved.
//

#import "customCameraViewController.h"

@implementation customCameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - user define function
- (void)takePictureWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *aImagePicker;
    if (buttonIndex == customCameraButtonOptionTakePicture)
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
    else if (buttonIndex == customCameraButtonOptionTakePicture)
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
}

@end
