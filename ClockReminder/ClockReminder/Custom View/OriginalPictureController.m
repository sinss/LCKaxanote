//
//  OriginalPictureController.m
//  ClockReminder
//
//  Created by 張星星 on 11/12/15.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import "OriginalPictureController.h"

@implementation OriginalPictureController
@synthesize imageFilePath;
@synthesize memoContent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
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
- (void)dealloc
{
    [imageFilePath release], imageFilePath = nil;
    [memoContent release], memoContent = nil;
    [originalImageView release], originalImageView = nil;
    [originalScrollView release], originalScrollView = nil;
    [memoLabel release], memoLabel = nil;
    [super dealloc];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [memoLabel setText:memoContent];
    UIImage *image = [UIImage imageWithContentsOfFile:imageFilePath];
    [originalImageView setImage:image];
    [originalScrollView setContentSize:image.size];
    [originalScrollView setScrollEnabled:YES];
    
    originalScrollView.maximumZoomScale = 2.0;
    originalScrollView.minimumZoomScale = 1.0;
    originalScrollView.delegate = self;
    originalScrollView.zoomScale = 0.5;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

#pragma mark - user define function
- (IBAction)closeViewPress:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
