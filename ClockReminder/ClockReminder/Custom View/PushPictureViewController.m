//
//  PushPictureViewController.m
//  ClockReminder
//
//  Created by 張星星 on 11/12/22.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import "PushPictureViewController.h"

@implementation PushPictureViewController
@synthesize imageFilePath;
@synthesize memoContent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, navigationBarTitleView_width, navigationBarTitleView_height)] autorelease];
        [imageView setImage:[UIImage imageNamed:@""]];
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

- (void)dealloc
{
    [imageFilePath release], imageFilePath = nil;
    [memoContent release], memoContent = nil;
    [originalImageView release], originalImageView = nil;
    [originalScrollView release], originalScrollView = nil;
    [memoLabel release], memoLabel = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [memoLabel setText:memoContent];
    UIImage *image = [UIImage imageWithContentsOfFile:imageFilePath];
    [originalImageView setImage:image];
    [originalScrollView setContentSize:image.size];
    [originalScrollView setScrollEnabled:YES];
    
    originalScrollView.maximumZoomScale = 2;
    originalScrollView.minimumZoomScale = 1;
    originalScrollView.delegate = self;
    originalScrollView.zoomScale = 1.0;
}

- (void)viewDidUnload
{
    originalImageView = nil;
    originalScrollView = nil;
    memoLabel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
    
}

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)inScroll 
{
    return originalImageView;
}


@end
