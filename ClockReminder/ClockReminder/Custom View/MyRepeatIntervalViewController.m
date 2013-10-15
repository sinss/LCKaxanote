//
//  MyRepeatIntervalViewController.m
//  ClockReminder
//
//  Created by 張星星 on 11/12/16.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import "MyRepeatIntervalViewController.h"
#import "GlobalFunctions.h"

@interface MyRepeatIntervalViewController()

- (void)createDelayUnitWithInt:(NSInteger)number;
- (void) createHourUnit;

@end

@implementation MyRepeatIntervalViewController
@synthesize delegate;
@synthesize currentRepeatInterval;
@synthesize currentDelayUnit;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
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
    [repeatIntervalPicker release], repeatIntervalPicker = nil;
    [repeatIntervalItems release], repeatIntervalItems = nil;
    [delayUnit release], delayUnit = nil;
    appInfoDict = nil;
    [super dealloc];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (appInfoDict == nil)
    {
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"appInfo" ofType:@"plist"];
        appInfoDict = [[NSDictionary alloc] initWithContentsOfFile:fileName];
    }
    if (repeatIntervalItems == nil)
    {
        if ([[GlobalFunctions shareInstance] currentLanguageInd] == 0)
            repeatIntervalItems = [appInfoDict valueForKey:@"repeatIntervalName_tw"];
        else
            repeatIntervalItems = [appInfoDict valueForKey:@"repeatIntervalName_en"];
    }
    //給初始值
    if (currentRepeatInterval == MyRepeatIntervalUnitDelaySeconds)
        [self createDelayUnitWithInt:100];
    else if (currentRepeatInterval == MyRepeatIntervalUnitYear)
        [self createDelayUnitWithInt:12];
    else if (currentRepeatInterval == MyRepeatIntervalUnitMonth)
        [self createDelayUnitWithInt:31];
    else if (currentRepeatInterval == MyRepeatIntervalUnitWeek)
        [self createDelayUnitWithInt:7];
    else if (currentRepeatInterval == MyRepeatIntervalUnitDay)
        [self createHourUnit];
    else if (currentRepeatInterval == MyRepeatIntervalUnitHour)
        [self createDelayUnitWithInt:60];
    else
        [self createDelayUnitWithInt:0];
    repeatIntervalPicker.delegate = self;
    repeatIntervalPicker.dataSource = self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [repeatIntervalPicker selectRow:currentRepeatInterval inComponent:0 animated:YES];
    [repeatIntervalPicker selectRow:currentDelayUnit inComponent:1 animated:YES];
    
}
- (void)viewDidUnload
{
    repeatIntervalPicker = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIPickerView data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == MyRepeatIntervalComponentTypeRepeatInterval)
    {
        return 180;
    }
    else if (component == MyRepeatIntervalComponentTypeDelayUnit)
    {
        return 140;
    }
    else
        return 0;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == MyRepeatIntervalComponentTypeRepeatInterval)
    {
        return [repeatIntervalItems count];
    }
    else if (component == MyRepeatIntervalComponentTypeDelayUnit)
    {
        return [delayUnit count];
    }
    else
        return 0;
}
#pragma mark - UIPickerView delegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view 
{
    UILabel *label = nil;
    if (component == MyRepeatIntervalComponentTypeRepeatInterval)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
        [label setText:[NSString stringWithFormat:@"%@", [repeatIntervalItems objectAtIndex:row]]];
        [label setTextAlignment:UITextAlignmentCenter];
        [label setTextColor:[UIColor darkGrayColor]];
    }
    else if (component == MyRepeatIntervalComponentTypeDelayUnit)
    {
        NSInteger repeatIntervalRow = [pickerView selectedRowInComponent:0];
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,140, 44)];
        [label setTextAlignment:UITextAlignmentCenter];
        [label setTextColor:[UIColor darkGrayColor]];
        if (repeatIntervalRow == MyRepeatIntervalUnitYear)
        {
            NSDictionary *dict = nil;
            if ([[GlobalFunctions shareInstance] currentLanguageInd] == 0)
                dict = [appInfoDict valueForKey:@"month_tw"];
            else
                dict = [appInfoDict valueForKey:@"month_en"];
            [label setText:[dict valueForKey:[NSString stringWithFormat:@"%i",row]]];
        }
        else if (repeatIntervalRow == MyRepeatIntervalUnitMonth)
        {
            //每月幾號
            if ([[GlobalFunctions shareInstance] currentLanguageInd] == 0)
            {
                if (row == 0)
                    [label setText:[NSString stringWithFormat:@"%@", [delayUnit objectAtIndex:row]]];
                else
                    [label setText:[NSString stringWithFormat:@"%@曰", [delayUnit objectAtIndex:row]]];
            }
            else
            {
                [label setText:[NSString stringWithFormat:@"%@", [delayUnit objectAtIndex:row]]];
            }
        }
        else if (repeatIntervalRow == MyRepeatIntervalUnitWeek)
        {
            NSDictionary *dict = nil;
            if ([[GlobalFunctions shareInstance] currentLanguageInd] == 0)
                dict = [appInfoDict valueForKey:@"week_tw"];
            else
                dict = [appInfoDict valueForKey:@"week_en"];
            [label setText:[dict valueForKey:[NSString stringWithFormat:@"%i",row]]];
        }
        else if (repeatIntervalRow == MyRepeatIntervalUnitDay)
        {
            if ([[GlobalFunctions shareInstance] currentLanguageInd] == 0)
            {
                if (row == 0)
                    [label setText:[NSString stringWithFormat:@"%@", [delayUnit objectAtIndex:row]]];
                else
                    [label setText:[NSString stringWithFormat:@"%@時", [delayUnit objectAtIndex:row]]];
            }
            else
            {
                if (row == 0)
                    [label setText:[NSString stringWithFormat:@"%@", [delayUnit objectAtIndex:row]]];
                else
                    [label setText:[NSString stringWithFormat:@"%@", [delayUnit objectAtIndex:row]]];
            }

        }
        else if (repeatIntervalRow == MyRepeatIntervalUnitHour)
        {
            if ([[GlobalFunctions shareInstance] currentLanguageInd] == 0)
            {
                if (row == 0)
                    [label setText:[NSString stringWithFormat:@"%@", [delayUnit objectAtIndex:row]]];
                else
                    [label setText:[NSString stringWithFormat:@"%@分", [delayUnit objectAtIndex:row]]];
            }
            else
            {
                if (row == 0)
                    [label setText:[NSString stringWithFormat:@"%@", [delayUnit objectAtIndex:row]]];
                else
                    [label setText:[NSString stringWithFormat:@"%@min", [delayUnit objectAtIndex:row]]];
            }
        }
        else
        {
            
            [label setText:[NSString stringWithFormat:@"%@", [delayUnit objectAtIndex:row]]];
        }
    }
    return label;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == MyRepeatIntervalComponentTypeRepeatInterval)
    {
        if (row == MyRepeatIntervalUnitDelaySeconds)
            [self createDelayUnitWithInt:100];
        else if (row == MyRepeatIntervalUnitYear)
            [self createDelayUnitWithInt:12];
        else if (row == MyRepeatIntervalUnitMonth)
            [self createDelayUnitWithInt:31];
        else if (row == MyRepeatIntervalUnitWeek)
            [self createDelayUnitWithInt:7];
        else if (row == MyRepeatIntervalUnitDay)
            [self createHourUnit];
        else if (row == MyRepeatIntervalUnitHour)
            [self createDelayUnitWithInt:60];
        else
            [self createDelayUnitWithInt:0];
        [pickerView reloadComponent:MyRepeatIntervalComponentTypeDelayUnit];
    }
}
#pragma mark user define function

- (IBAction)pressSelectButton:(id)sender
{
    NSInteger row = [repeatIntervalPicker selectedRowInComponent:0];
    [delegate MyRepeatIntervalViewController:self didPressButtonIndex:MyRepeatIntervalPressButtonTypeSelect selectedRepeatInterval:[[GlobalFunctions shareInstance] repeatIntervalValue:row] delayUnit:[repeatIntervalPicker selectedRowInComponent:MyRepeatIntervalComponentTypeDelayUnit]];
    [self dismissModalViewControllerAnimated:YES];
}
- (IBAction)pressCancelButton:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)createDelayUnitWithInt:(NSInteger)number
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:number];
    if ([[GlobalFunctions shareInstance] currentLanguageInd] == 0)
        [array addObject:[appInfoDict valueForKey:@"default_tw"]];
    else
        [array addObject:[appInfoDict valueForKey:@"default_en"]];
    for (int i = 1 ; i <= number ; i ++)
    {
        NSString *tmp = [[NSString alloc] initWithFormat:@"%i",i];
        [array addObject:tmp];
        [tmp release];
    }
    delayUnit = array;
    //[array release];
}
- (void) createHourUnit
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:24];
    if ([[GlobalFunctions shareInstance] currentLanguageInd] == 0)
        [array addObject:[appInfoDict valueForKey:@"default_tw"]];
    else
        [array addObject:[appInfoDict valueForKey:@"default_en"]];
    for (int i = 0 ; i <= 23 ; i ++)
    {
        NSString *tmp = [[NSString alloc] initWithFormat:@"%02i",i];
        [array addObject:tmp];
        [tmp release];
    }
    delayUnit = array;
}
@end
