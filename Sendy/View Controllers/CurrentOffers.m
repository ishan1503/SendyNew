//
//  CurrentOffers.m
//  Sendy
//
//  Created by Ishan Shikha on 20/10/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "CurrentOffers.h"
#import "UILabel+Extra.h"
#import "ODRefreshControl.h"
#import "BidListVC.h"
#import "CreateItemVC.h"
@interface CurrentOffers()
{
    NSMutableArray *offersArray;
    IBOutlet UITableView *tableview;
    NSIndexPath *selectedIndexPath;

}
@end
@implementation CurrentOffers

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self getCurrentOffers];
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:tableview];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];

}
- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [AppHelper saveToUserDefaults:@"0" withKey:@"currentPage"];
                       [self getCurrentOffers];
                       [refreshControl endRefreshing];
                       
                   });
}

-(void)getCurrentOffers
{
    if([AppDelegate getAppDelegate].isNetworkReachable)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCurrentOffers:) name:Current_Offers_RCVD_Notification object:nil];
        [[ServiceClass sharedServiceClass] getCurrentOffersWithDictionary:[NSMutableDictionary dictionaryWithObject:UserID forKey:@"userId"]];
    }
    else
    {
        [AppHelper showAlertViewWithTag:1211 title:App_Name message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

    }
}
-(void)handleCurrentOffers:(NSNotification *)not
{
    if([not.object count]>0)
    {
        offersArray=[NSMutableArray array];
        offersArray=[not.object mutableCopy];
        [tableview reloadData];
    }
    else
    {
        [AppHelper showAlertViewWithTag:121111 title:App_Name message:@"No offers found." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];

    }
}
-(IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-Table View Delegate & Datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 240.0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return offersArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CurrentOfferCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict=[offersArray objectAtIndex:indexPath.row];
    
    UILabel *parcelType=(UILabel *)[cell.contentView viewWithTag:1021];
    parcelType.text=[dict objectForKey:@"parcelType"];
    
    UILabel *deliveryDate=(UILabel *)[cell.contentView viewWithTag:1022];
    deliveryDate.text=[self terminateTime:[dict objectForKey:@"delieveryDate"]];

    UILabel *itemSize=(UILabel *)[cell.contentView viewWithTag:1023];
    
    NSString *weightType=@"";
    NSString *spaceType=@"";
    
    if(![dict[@"weightType"] isKindOfClass:[NSNull class]]&&![dict[@"spaceType"] isKindOfClass:[NSNull class]])
    {
        
        if([[dict objectForKey:@"weightType"] isEqualToString:@"k"]||[[dict objectForKey:@"weightType"] isEqualToString:@"K"])
            weightType=@" Kgs";
        else if([[dict objectForKey:@"weightType"] isEqualToString:@"g"]||[[dict objectForKey:@"weightType"] isEqualToString:@"G"])
            weightType=@" Gms";
        else
            weightType=@" Lbs";
        
        if([[dict objectForKey:@"spaceType"] isEqualToString:@"i"]||[[dict objectForKey:@"spaceType"] isEqualToString:@"I"])
            spaceType=@" In";
        else
            spaceType=@" Cm";
        
        itemSize.text=[@"Item Size: " stringByAppendingString:[[[[[[@"H " stringByAppendingString:[dict objectForKey:@"height"]] stringByAppendingString:@",L "] stringByAppendingString:[dict objectForKey:@"length"]] stringByAppendingString:@",W "] stringByAppendingString:[dict objectForKey:@"width"]] stringByAppendingString:spaceType]];
        [itemSize setAttributeText:NSMakeRange(0, 10)];
        
        UILabel *itemWeight=(UILabel *)[cell.contentView viewWithTag:1024];
        itemWeight.text=[[@"Item Weight: " stringByAppendingString:[dict objectForKey:@"weightValue"]] stringByAppendingString:weightType];
        [itemWeight setAttributeText:NSMakeRange(0, 12)];

    }
    

    UILabel *deliveryAdd=(UILabel *)[cell.contentView viewWithTag:1025];
    deliveryAdd.text=[@"Delivery Add: " stringByAppendingString:[dict objectForKey:@"deliveryAddress"]];
    [deliveryAdd setAttributeText:NSMakeRange(0, 13)];

    
    UILabel *notes=(UILabel *)[cell.contentView viewWithTag:1026];
    notes.text=@"Notes: ";
    [notes setAttributeText:NSMakeRange(0, 6)];

    
    NSArray *bidArray=(NSArray *)[dict objectForKey:@"bid"];
    
    UILabel *numberOfBids=(UILabel *)[cell.contentView viewWithTag:1027];
    numberOfBids.text=[NSString stringWithFormat:@"%lu",(unsigned long)bidArray.count];

    UILabel *createdOn=(UILabel *)[cell.contentView viewWithTag:1028];
    createdOn.text=[self terminateTime:[dict objectForKey:@"createdOn"]];

    UIButton *button=(UIButton *)[cell.contentView viewWithTag:1035];
    [button addTarget:self action:@selector(pushBidList:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *editOffers=(UIButton *)[cell.contentView viewWithTag:1029];
    [editOffers addTarget:self action:@selector(editOffers:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *cancelOffers=(UIButton *)[cell.contentView viewWithTag:1030];
    [cancelOffers addTarget:self action:@selector(cancelOffers:) forControlEvents:UIControlEventTouchUpInside];

    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)editOffers:(id)sender
{
    UIButton *cancelButton=(UIButton *)sender;
    UITableViewCell *cell=(UITableViewCell *)[[[cancelButton superview] superview] superview];
    selectedIndexPath=[tableview indexPathForCell:cell];
    [self performSegueWithIdentifier:@"openItemEdit" sender:selectedIndexPath];
}
-(void)cancelOffers:(id)sender
{
    UIButton *cancelButton=(UIButton *)sender;
    UITableViewCell *cell=(UITableViewCell *)[[[cancelButton superview] superview] superview];
    selectedIndexPath=[tableview indexPathForCell:cell];
    [AppHelper showAlertViewWithTag:110001 title:App_Name message:@"Are you sure,you want to cancel the Item ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes"];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==110001 && buttonIndex!=alertView.cancelButtonIndex)
    {
        if([AppDelegate getAppDelegate].isNetworkReachable)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCancelItem:) name:CancelItem_Notification object:nil];
            [[ServiceClass sharedServiceClass] cancelItemWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[[offersArray objectAtIndex:selectedIndexPath.row] objectForKey:@"id"],@"itemId",UserID,@"userId", nil]];
        }
        else
        {
            [AppHelper showAlertViewWithTag:1211 title:App_Name message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
        }
    }
    else if(alertView.tag==121111 && buttonIndex==alertView.cancelButtonIndex)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)handleCancelItem:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CancelItem_Notification object:nil];
    [AppHelper showAlertViewWithTag:1211 title:App_Name message:@"Item successfully deleted." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [offersArray removeObjectAtIndex:selectedIndexPath.row];
    [tableview reloadData];
}

-(IBAction)pushBidList:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    UITableViewCell *cell=(UITableViewCell *)[[[btn superview] superview] superview];
    NSIndexPath *indexPath=[tableview indexPathForCell:cell];
    
    NSDictionary *dict=[offersArray objectAtIndex:indexPath.row];
    NSArray *bidArray=(NSArray *)[dict objectForKey:@"bid"];
    if(bidArray.count==0)
    {
        [AppHelper showAlertViewWithTag:1001 title:App_Name message:@"No bid to show." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
    else
    {
        [self performSegueWithIdentifier:@"PushBidList" sender:dict];
    }
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
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"PushBidList"])
    {
        [(BidListVC *)segue.destinationViewController setDict:sender];
    }
    else
    {
        [(CreateItemVC *)segue.destinationViewController setItemInfo:[offersArray objectAtIndex:selectedIndexPath.row]];

    }
}
@end
