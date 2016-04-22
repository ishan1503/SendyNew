//
//  TripListVC.m
//  Sendy
//
//  Created by Ishan Shikha on 13/10/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "TripListVC.h"
#import "CreateTripVC.h"
#import "ODRefreshControl.h"
@interface TripListVC()
{
    IBOutlet UITableView *tableview;
    NSMutableArray *tripArray;
    IBOutlet UILabel *messagelabel;
    NSIndexPath *selectedIndexPath;
}
@end
@implementation TripListVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    messagelabel.hidden=YES;
    selectedIndexPath=[NSIndexPath indexPathForItem:0 inSection:0];
    if([AppDelegate getAppDelegate].isNetworkReachable)
    {
        [self getTrips];
    }
    else
    {
        [AppHelper showAlertViewWithTag:1211 title:App_Name message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:tableview];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
       // Do any additional setup after loading the view.
}
- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [AppHelper saveToUserDefaults:@"0" withKey:@"currentPage"];
                       [self getTrips];
                       [refreshControl endRefreshing];
                       
                   });
}


-(void)getTrips
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tripRcvd:) name:Delivere_Trip_RCVD_Notification object:nil];
    [[ServiceClass sharedServiceClass] fetchDelivererTripWithDictionary:[NSMutableDictionary dictionaryWithObject:UserID forKey:@"userId"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tripRcvd:(NSNotification *)not
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Delivere_Trip_RCVD_Notification object:nil];
    if([not.object count]>0)
    {
        tripArray=[not.object mutableCopy];
        [tableview reloadData];
        messagelabel.hidden=YES;
    }
    else
    {
        messagelabel.hidden=NO;
    }
}
#pragma mark-Table View Delegate & Datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108.0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tripArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyTripCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeCell"];
    }
    UILabel *fromCountry=(UILabel *)[cell.contentView viewWithTag:1021];
    UILabel *toCountry=(UILabel *)[cell.contentView viewWithTag:1022];
    UILabel *tripDate=(UILabel *)[cell.contentView viewWithTag:1023];
    UIButton *cancelButton=(UIButton *)[cell.contentView viewWithTag:1025];
    UIButton *editButton=(UIButton *)[cell.contentView viewWithTag:1024];

    NSDictionary *dataDict=nil;
    [cancelButton addTarget:self action:@selector(cancelTrip:) forControlEvents:UIControlEventTouchUpInside];
    [editButton addTarget:self action:@selector(editTripAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if(indexPath.row<tripArray.count)
        dataDict=[tripArray objectAtIndex:indexPath.row];

    
    if(![dataDict[@"fromCountry"] isKindOfClass:[NSNull class]])
        fromCountry.text=dataDict[@"fromCountry"];
    else
        fromCountry.text=@"";
    
    if(![dataDict[@"toCountry"] isKindOfClass:[NSNull class]])
        toCountry.text=dataDict[@"toCountry"];
    else
        toCountry.text=@"";
    
    if(![dataDict[@"departureDate"] isKindOfClass:[NSNull class]])
        tripDate.text=[self terminateTime:dataDict[@"departureDate"]];
    else
        tripDate.text=@"";
        
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(NSString *)terminateTime:(NSString *)date
{
    NSString *dateAndTime = date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] ];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //[dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate   *aDate = [dateFormatter dateFromString:dateAndTime];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString = [dateFormatter2 stringFromDate:aDate];
    return dateString;
    
}
-(void)cancelTrip:(id)sender
{
    UIButton *cancelButton=(UIButton *)sender;
    UITableViewCell *cell=(UITableViewCell *)[[[cancelButton superview] superview] superview];
    selectedIndexPath=[tableview indexPathForCell:cell];
    [AppHelper showAlertViewWithTag:110001 title:App_Name message:@"Are you sure,you want to cancel the Trip ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes"];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==110001 && buttonIndex!=alertView.cancelButtonIndex)
    {
        if([AppDelegate getAppDelegate].isNetworkReachable)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCancelTrip:) name:CancelTrip_Notification object:nil];
            [[ServiceClass sharedServiceClass] cancelTripWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[[tripArray objectAtIndex:selectedIndexPath.row] objectForKey:@"tripId"],@"tripId",UserID,@"userId", nil]];
        }
        else
        {
            [AppHelper showAlertViewWithTag:1211 title:App_Name message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

        }
    }
}
-(void)handleCancelTrip:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CancelTrip_Notification object:nil];
        [AppHelper showAlertViewWithTag:1211 title:App_Name message:@"Trip successfully deleted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [tripArray removeObjectAtIndex:selectedIndexPath.row];
    [tableview reloadData];
}
-(void)editTripAction:(id)sender
{
    UIButton *cancelButton=(UIButton *)sender;
    UITableViewCell *cell=(UITableViewCell *)[[[cancelButton superview] superview] superview];
    selectedIndexPath=[tableview indexPathForCell:cell];
    [self performSegueWithIdentifier:@"openTripEdit" sender:selectedIndexPath];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"openTripEdit"])
    {
        [(CreateTripVC *)segue.destinationViewController setTripInfo:[tripArray objectAtIndex:selectedIndexPath.row]];
    }
}
@end
