//
//  MyDateTimePickerViewController.m
//  ClockReminder
//
//  Created by 張星星 on 11/12/16.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import "MyDateTimePickerViewController.h"

@implementation MyDateTimePickerViewController

@synthesize delegate;
@synthesize currentReminderDate;
@synthesize cellRow;

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
- (void)dealloc
{
    [datePicker release], datePicker = nil;
    [currentReminderDate release], currentReminderDate = nil;
    [super dealloc];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (currentReminderDate != nil)
        [datePicker setDate:currentReminderDate];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    datePicker = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - user define functions
- (IBAction)pressSelectButton:(id)sender
{
    [delegate MyDateTimePickerViewController:self didPressButtonIndex:MyDateTimePickerPressButtonTypeSelect selectedDate:datePicker.date andCellRow:cellRow];
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)pressCancelButton:(id)sender
{
    [delegate MyDateTimePickerViewController:self didPressButtonIndex:MyDateTimePickerPressButtonTypeCancel selectedDate:datePicker.date andCellRow:cellRow];
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)pressClearButton:(id)sender
{
    [delegate MyDateTimePickerViewController:self didPressButtonIndex:MyDateTimePickerPressButtonTypeClear selectedDate:nil andCellRow:cellRow];
    [self dismissModalViewControllerAnimated:YES];
}
@end
