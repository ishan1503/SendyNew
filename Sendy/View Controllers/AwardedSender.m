//
//  AwardedSender.m
//  Sendy
//
//  Created by Ishan Shikha on 25/10/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "AwardedSender.h"
#import "UILabel+Extra.h"
#import "ODRefreshControl.h"
#import "AwardedSenderDetail.h"
@interface AwardedSender()

{
    NSArray *awardedDeliveries;
    IBOutlet UITableView *tableview;
    IBOutlet UILabel *headerLabel;
    IBOutlet UILabel *messageLabel;
}
@end
@implementation AwardedSender
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:tableview];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];

    messageLabel.hidden=YES;
    
    if(self.isOpenForCompletedDeliveriesSender)
    {
        [self getCompletedDeliveriesSender];
        headerLabel.text=@"Completed Deliveries";
    }
    else if (self.isOpenForCompletedDeliveriesDeliverer)
    {
        [self getCompletedDeliveriesDeliverer];
        headerLabel.text=@"Completed Deliveries";
    }
    else
    {
        [self getAwardedDeliveries];
    }

    
}
- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       if(self.isOpenForCompletedDeliveriesSender)
                           [self getCompletedDeliveriesSender];
                       else if (self.isOpenForCompletedDeliveriesDeliverer)
                           [self getCompletedDeliveriesDeliverer];
                       else
                           [self getAwardedDeliveries];
                       [refreshControl endRefreshing];
                       
                   });
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
-(void)getAwardedDeliveries
{
    if([AppDelegate getAppDelegate].isNetworkReachable)
    {
        [[AppDelegate getAppDelegate] showLoadingView:@"Please wait..."];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAwardedDeliveriesResponse:) name:Awarded_Deliveries_As_Sender_Notification object:nil];
        [[ServiceClass sharedServiceClass] awardeAsSenderWithDictionary:[NSMutableDictionary dictionaryWithObject:UserID forKey:@"userId"]];
    }
    else
    {
        [AppHelper showAlertViewWithTag:10101 title:App_Name message:@"Please check your internert connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
    }
}
-(void)getCompletedDeliveriesSender
{
    if([AppDelegate getAppDelegate].isNetworkReachable)
    {
        [[AppDelegate getAppDelegate] showLoadingView:@"Please wait..."];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCompletedAsSenderResponse:) name:Completed_Deliveries_As_Sender_Notification object:nil];
        [[ServiceClass sharedServiceClass] completedAsSenderWithDictionary:[NSMutableDictionary dictionaryWithObject:UserID forKey:@"userId"]];
    }
    else
    {
        [AppHelper showAlertViewWithTag:10101 title:App_Name message:@"Please check your internert connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
    }
}
-(void)getCompletedDeliveriesDeliverer
{
    if([AppDelegate getAppDelegate].isNetworkReachable)
    {
        [[AppDelegate getAppDelegate] showLoadingView:@"Please wait..."];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCompletedAsDelivererResponse:) name:Completed_Deliveries_As_Deliverer_Notification object:nil];
        [[ServiceClass sharedServiceClass] completedAsDelivererWithDictionary:[NSMutableDictionary dictionaryWithObject:UserID forKey:@"userId"]];
    }
    else
    {
        [AppHelper showAlertViewWithTag:10101 title:App_Name message:@"Please check your internert connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
    }
}
-(void)handleAwardedDeliveriesResponse:(NSNotification *)not
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Awarded_Deliveries_As_Sender_Notification object:nil];
    if([not.object count]>0)
    {
        awardedDeliveries=[NSArray array];
        awardedDeliveries=not.object;
        messageLabel.hidden=YES;
    }
    else
    {
        messageLabel.hidden=NO;
        messageLabel.text=@"No Awarded Deliveries Found.";
    }
    [tableview reloadData];
}
-(void)handleCompletedAsSenderResponse:(NSNotification *)not
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Completed_Deliveries_As_Sender_Notification object:nil];
    if([not.object count]>0)
    {
        awardedDeliveries=[NSArray array];
        awardedDeliveries=not.object;
        messageLabel.hidden=YES;
    }
    else
    {
        messageLabel.hidden=NO;
        messageLabel.text=@"No Completed Deliveries Found.";
    }
    [tableview reloadData];
}
-(void)handleCompletedAsDelivererResponse:(NSNotification *)not
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Completed_Deliveries_As_Deliverer_Notification object:nil];
    if([not.object count]>0)
    {
        awardedDeliveries=[NSArray array];
        awardedDeliveries=not.object;
        messageLabel.hidden=YES;
    }
    else
    {
        messageLabel.hidden=NO;
        messageLabel.text=@"No Completed Deliveries Found.";
    }
    [tableview reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return awardedDeliveries.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AwardedSenderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dataDict=[awardedDeliveries objectAtIndex:indexPath.row];
    
    UILabel *documentType=(UILabel *)[cell.contentView viewWithTag:1021];
    UILabel *awardedDate=(UILabel *)[cell.contentView viewWithTag:1022];
    UILabel *delivereName=(UILabel *)[cell.contentView viewWithTag:1023];
    UILabel *itemSize=(UILabel *)[cell.contentView viewWithTag:1024];
    UILabel *itemWeight=(UILabel *)[cell.contentView viewWithTag:1025];
    UILabel *deliveryAdress=(UILabel *)[cell.contentView viewWithTag:1026];
    UILabel *bidAmount=(UILabel *)[cell.contentView viewWithTag:1027];
    UILabel *completedOn=(UILabel *)[cell.contentView viewWithTag:9807];
    UIImageView *arrowImage=(UIImageView *)[cell.contentView viewWithTag:9808];

    
    if(![dataDict[@"parcelType"] isKindOfClass:[NSNull class]])
        documentType.text=dataDict[@"parcelType"];
    else
        documentType.text=@"";

    if(self.isOpenForCompletedDeliveriesSender)
    {
        completedOn.text=@"Completed On";
        arrowImage.hidden=YES;
    }
    if(self.isOpenForCompletedDeliveriesDeliverer)
        arrowImage.hidden=YES;

    
    if(!self.isOpenForCompletedDeliveriesSender&&!self.isOpenForCompletedDeliveriesDeliverer&&![dataDict[@"awardDate"] isKindOfClass:[NSNull class]])
        awardedDate.text=[self terminateTime:dataDict[@"awardDate"]];
    else if((self.isOpenForCompletedDeliveriesSender||self.isOpenForCompletedDeliveriesDeliverer)&&![dataDict[@"completedDate"] isKindOfClass:[NSNull class]])
    {
        awardedDate.text=[self terminateTime:dataDict[@"completedDate"]];
    }
    else
        awardedDate.text=@"";

    if(self.isOpenForCompletedDeliveriesDeliverer&&![dataDict[@"senderName"] isKindOfClass:[NSNull class]])
        delivereName.text=[@"Deliverer: " stringByAppendingString:dataDict[@"senderName"]];
    else if(self.isOpenForCompletedDeliveriesSender&&![dataDict[@"delivererName"] isKindOfClass:[NSNull class]])
        delivereName.text=[@"Deliverer: " stringByAppendingString:dataDict[@"delivererName"]];
    else if(!self.isOpenForCompletedDeliveriesDeliverer&&!self.isOpenForCompletedDeliveriesSender&&![dataDict[@"delivererName"] isKindOfClass:[NSNull class]])
        delivereName.text=[@"Deliverer: " stringByAppendingString:dataDict[@"delivererName"]];
    else
        delivereName.text=@"Deliverer: ";
    [delivereName setAttributeText:NSMakeRange(0, 9)];
    
    if(![dataDict[@"weightType"] isKindOfClass:[NSNull class]]&&![dataDict[@"spaceType"] isKindOfClass:[NSNull class]])
    {
        NSString *weightType=@"";
        NSString *spaceType=@"";
        
        if([[dataDict objectForKey:@"weightType"] isEqualToString:@"k"]||[[dataDict objectForKey:@"weightType"] isEqualToString:@"K"])
            weightType=@" Kgs";
        else if([[dataDict objectForKey:@"weightType"] isEqualToString:@"g"]||[[dataDict objectForKey:@"weightType"] isEqualToString:@"G"])
            weightType=@" Gms";
        else
            weightType=@" Lbs";
        
        if([[dataDict objectForKey:@"spaceType"] isEqualToString:@"i"]||[[dataDict objectForKey:@"spaceType"] isEqualToString:@"I"])
            spaceType=@" In";
        else
            spaceType=@" Cm";
        
        itemSize.text=[@"Item Size: " stringByAppendingString:[[[[[[@"H " stringByAppendingString:[dataDict objectForKey:@"height"]] stringByAppendingString:@",L "] stringByAppendingString:[dataDict objectForKey:@"length"]] stringByAppendingString:@",W "] stringByAppendingString:[dataDict objectForKey:@"width"]] stringByAppendingString:spaceType]];
        [itemSize setAttributeText:NSMakeRange(0, 10)];
        
        itemWeight.text=[[@"Item Weight: " stringByAppendingString:[dataDict objectForKey:@"weightValue"]] stringByAppendingString:weightType];
        [itemWeight setAttributeText:NSMakeRange(0, 12)];
        
    }
    if(![dataDict[@"deliveryAddress"] isKindOfClass:[NSNull class]])
        deliveryAdress.text=[@"Delivery Add: " stringByAppendingString:dataDict[@"deliveryAddress"]];
    else
        deliveryAdress.text=@"Delivery Add: ";
    [deliveryAdress setAttributeText:NSMakeRange(0, 13)];

    if(!self.isOpenForCompletedDeliveriesSender&&!self.isOpenForCompletedDeliveriesDeliverer&&![dataDict[@"bidAmount"] isKindOfClass:[NSNull class]])
    {
        NSString *currencyType=@"";
        if([dataDict[@"winningCurrencyType"] isEqualToString:@"EUR"])
            currencyType=@"€";
        else if ([dataDict[@"winningCurrencyType"] isEqualToString:@"USD"])
            currencyType=@"$";
        else
            currencyType=@"£";
        
        bidAmount.text=[NSString stringWithFormat:@"Winning Amount: %@",[NSString stringWithFormat:@"%@ %@",currencyType,   dataDict[@"winningAmount"] ]];
    }
    else if ((self.isOpenForCompletedDeliveriesSender||self.isOpenForCompletedDeliveriesDeliverer)&&![dataDict[@"paidAmount"] isKindOfClass:[NSNull class]])
    {
        NSString *currencyType=@"";
        if([dataDict[@"paidCurrencyType"] isEqualToString:@"EUR"])
            currencyType=@"€";
        else if ([dataDict[@"paidCurrencyType"] isEqualToString:@"USD"])
            currencyType=@"$";
        else
            currencyType=@"£";
        
        bidAmount.text=[NSString stringWithFormat:@"Paid Amount: %@",[NSString stringWithFormat:@"%@ %@",currencyType,   dataDict[@"paidAmount"] ]];

    }
    else
        bidAmount.text=@"Paid Amount:";
    [bidAmount setAttributeText:NSMakeRange(0, 12)];
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.isOpenForCompletedDeliveriesSender&&!self.isOpenForCompletedDeliveriesDeliverer)
        [self performSegueWithIdentifier:@"AwardedSenderDetail" sender:indexPath];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"AwardedSenderDetail"])
    {
        [(AwardedSenderDetail *)segue.destinationViewController setDict:[[awardedDeliveries objectAtIndex:[(NSIndexPath *)sender row]] mutableCopy]];
    }
}
-(NSString *)terminateDate:(NSString *)date
{
    NSString *dateAndTime = date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] ];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //[dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate   *aDate = [dateFormatter dateFromString:dateAndTime];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    NSString *dateString = [dateFormatter2 stringFromDate:aDate];
    return dateString;
    
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
-(IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
