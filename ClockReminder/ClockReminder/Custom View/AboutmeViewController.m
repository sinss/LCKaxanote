//
//  AboutmeViewController.m
//  ClockReminder
//
//  Created by 張星星 on 11/12/25.
//  Copyright (c) 2011年 星星. All rights reserved.
//

#import "AboutmeViewController.h"
#import "MKInfoPanel.h"

@implementation AboutmeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        if ([[GlobalFunctions shareInstance] currentLanguageInd] == 0)
        {
            self.tabBarItem.title = @"關於我";
        }
        else            
        {

            self.tabBarItem.title = @"About Me";
        }
        self.tabBarItem.image = [UIImage imageNamed:tabbarAboutmeImage];
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
    [super dealloc];
    [titleItems release], titleItems = nil;
    appInfoDict = nil;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:tableviewBackground]]];
    self.navigationController.view.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1];
    if (appInfoDict == nil)
    {
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"appInfo" ofType:@"plist"];
        appInfoDict = [[NSDictionary alloc] initWithContentsOfFile:fileName];
    }
    if (titleItems == nil)
    {
        if ([[GlobalFunctions shareInstance] currentLanguageInd] == 0)
            titleItems = [appInfoDict valueForKey:@"aboutmeTitle_tw"];
        else
            titleItems = [appInfoDict valueForKey:@"aboutmeTitle_en"];
    }
    NSLog(@"count:%i",[titleItems count]);
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
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
    // Return the number of sections.
    return [titleItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellIdentifier";
    static NSString *introductionCellIdentifier = @"introductionCellIdentifier";
    //NSInteger row = [indexPath row];
    NSInteger sec = [indexPath section];
    if (sec == 1)
    {
        MyAbourMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:introductionCellIdentifier];
        if (cell == nil)
        {
            NSArray *topLevelObjects = [[NSBundle mainBundle]
                                        loadNibNamed:@"MyAbourMeTableViewCell"
                                        owner:self
                                        options:nil];
            for (id currentObj in topLevelObjects)
            {
                if ([currentObj isKindOfClass:[MyAbourMeTableViewCell class]])
                {
                    cell = currentObj;
                    break;
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellBackground]];
            cell.backgroundView = imageView;
            [imageView release];
        }
        NSString *introductionString;
        float introHeight = 0.0;
        if ([[GlobalFunctions shareInstance] currentLanguageInd] == 0)
        {
            introductionString = [[NSString alloc] initWithFormat:@"%@",[[GlobalFunctions shareInstance] getStringInAppInfoForKey:@"aboutme_tw"]];
            introHeight = [[[NSString alloc] initWithFormat:[[GlobalFunctions shareInstance] getStringInAppInfoForKey:@"aboutmeheight_tw"]] floatValue];
        }
        else
        {
            introductionString = [[NSString alloc] initWithFormat:@"%@",[[GlobalFunctions shareInstance] getStringInAppInfoForKey:@"aboutme_en"]];
            introHeight = [[[NSString alloc] initWithFormat:[[GlobalFunctions shareInstance] getStringInAppInfoForKey:@"aboutmeheight_en"]] floatValue];
        }
        [cell.introTextView setFrame:CGRectMake(10, 10, cell.frame.size.width - 40, introHeight)];
        [cell.introTextView setText:introductionString];
        [cell.introTextView setBackgroundColor:[UIColor clearColor]];
        [introductionString release];
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) 
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:tableViewCellBackground]];
            cell.backgroundView = imageView;
            [imageView release];
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
        }
        if (sec == 0)
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            //版本資訊
            NSString *verString = [NSString stringWithFormat:@"%@ %@",[titleItems objectAtIndex:sec],[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
            [cell.textLabel setText:verString];
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.textLabel setText:[titleItems objectAtIndex:sec]];
            //聯絡我們
        }
        return cell;
    }
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"";
    else if (section == 1)
        return [titleItems objectAtIndex:section];
    else
        return @"";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sec = [indexPath section];
    if (sec == 1)
    {
        if ([[GlobalFunctions shareInstance] currentLanguageInd] == 0)
            return 135;
        else
            return 250;
    }
    else
        return 44;
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
    NSInteger sec = [indexPath section];
    if (sec == 2)
    {
        if ([MFMailComposeViewController canSendMail])
        {
            NSLog(@"can send mail");
            [self showMail];
        }
        else
        {
            [MKInfoPanel showPanelInView:self.view type:MKInfoPanelTypeError title:@"Warning!" subtitle:@"sorry, can't send mail!" hideAfter:2];
            
        }
    }
}
#pragma mark - send mail delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *message;
    switch (result) 
    {
        case MFMailComposeResultCancelled:
            message = @"Result: cancel send";
            break;
        case MFMailComposeResultSaved:
            message = @"Result: Mail Saved";
            break;
        case MFMailComposeResultFailed:
            message = @"Result: Mail Send Faild";
            break;
        case MFMailComposeResultSent:
            message = @"Result: Mail send";
            break;
        default:
            message = @"Result : Mail no Send";
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark - user define function
- (void)showMail
{
    //iOS 3.0就支援了
    MFMailComposeViewController *compose = [[MFMailComposeViewController alloc] init];
    compose.mailComposeDelegate = self;
    [compose setSubject:@"KaxaNote Iphone App"];
    
    NSArray *toRecipients = [NSArray arrayWithObjects:@"kaxanote@gmail.com",nil];
    [compose setToRecipients:toRecipients];
    //附加檔案
    
    NSString *emailBody = @"Dear KaxaNote";
    
    [compose setMessageBody:emailBody isHTML:NO];
    [self presentModalViewController:compose animated:YES];
    UIImage *image = [UIImage imageNamed:@""];
    [[[[compose navigationBar] items] objectAtIndex:0] setTitleView:[[UIImageView alloc] initWithImage:image]];    
}
- (void)showMessageAlert:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warnning"
                                                    message:message
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}
@end
