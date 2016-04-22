//
//  ActivityVC.m
//  Sendy
//
//  Created by harish lakhwani on 7/11/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "ActivityVC.h"
#import "CreateItemVC.h"
#import "UILabel+Extra.h"
#import "AwardedSender.h"
@interface ActivityVC ()
{
    __weak IBOutlet UISegmentedControl *activitySegmentControl;
    __weak IBOutlet UITableView *tableview;
}

@end
@implementation ActivityVC
- (void)viewDidLoad
{
    [super viewDidLoad];
   // activitySegmentControl.selectedSegmentIndex=0;
    //[self performSelector:@selector(getMytrip) withObject:nil afterDelay:2.0];
}
-(void)viewWillAppear:(BOOL)animated
{
}

- (IBAction)segmentChanged:(UISegmentedControl *)sender
{
    [tableview reloadData];
}

#pragma mark-Tablview Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(activitySegmentControl.selectedSegmentIndex==0)
        return 4;
    else
        return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyActivityCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UILabel *label=(UILabel *)[cell.contentView viewWithTag:3456];
    UIImageView *line=(UIImageView *)[cell.contentView viewWithTag:6543];
    if(activitySegmentControl.selectedSegmentIndex==0)
    {
        line.hidden=NO;
        if(indexPath.row==0)
            label.text=@"Awarded Deliveries";
        else if(indexPath.row==1)
            label.text=@"Completed Deliveries";
        else if(indexPath.row==2)
            label.text=@"My Current Bids";
        else
        {
            label.text=@"My Trips";
            line.hidden=YES;
        }
    }
    else
    {
        line.hidden=NO;
        if(indexPath.row==0)
            label.text=@"Awarded Deliveries";
        else if(indexPath.row==1)
            label.text=@"Current Offers";
        else
        {
            label.text=@"Completed Deliveries";
            line.hidden=YES;
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
   

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if(activitySegmentControl.selectedSegmentIndex==0)
   {
       if(indexPath.row==0)
           [self performSegueWithIdentifier:@"openAwardedDeliverer" sender:nil];
       if(indexPath.row==3)
           [self performSegueWithIdentifier:@"openTripList" sender:nil];
       if(indexPath.row==1)
           [self performSegueWithIdentifier:@"AwardedSender" sender:indexPath];
       if(indexPath.row==2)
           [self performSegueWithIdentifier:@"ShowMyBids" sender:indexPath];
   }
   else
   {
       if(indexPath.row==1)
           [self performSegueWithIdentifier:@"openCurrentOffers" sender:nil];
       if(indexPath.row==0||indexPath.row==2)
           [self performSegueWithIdentifier:@"AwardedSender" sender:indexPath];
   }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"AwardedSender"]&&[(NSIndexPath *)sender row]==2)
    {
        [(AwardedSender *)segue.destinationViewController setIsOpenForCompletedDeliveriesSender:YES];
    }
    else if ([segue.identifier isEqualToString:@"AwardedSender"]&&[(NSIndexPath *)sender row]==1&&activitySegmentControl.selectedSegmentIndex==0)
    {
        [(AwardedSender *)segue.destinationViewController setIsOpenForCompletedDeliveriesDeliverer:YES];

    }
}
@end
