//
//  InitialSetupVC.m
//  Sendy
//
//  Created by Ishan Shikha on 02/10/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "InitialSetupVC.h"
#import "LocationVC.h"
#import "HomeVC.h"
@interface InitialSetupVC ()
{
    UISegmentedControl *pickupSegment;
    UISegmentedControl *deliverySegment;
    
    float pickupDistance;
    float deliveryDistance;
    IBOutlet UITableView *tableview;
    NSDictionary *localDeliveryParam;
}
@end

@implementation InitialSetupVC
-(void)viewDidLoad
{
    [super viewDidLoad];
    localDeliveryParam=(NSDictionary *)[AppHelper unarchiveForKey:@"ParamForLocalDelivery"];
    if(localDeliveryParam.count>0)
    {
        self.address=[localDeliveryParam objectForKey:@"address"];
        pickupDistance=[[localDeliveryParam objectForKey:@"pickupDistance"] floatValue];
        deliveryDistance=[[localDeliveryParam objectForKey:@"deliveryDistance"] floatValue];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [tableview reloadData];
}
#pragma mark-Cancel Button Action
-(IBAction)cancelButtonAction:(id)sender
{
    if(localDeliveryParam.count==0)
        [AppHelper showAlertViewWithTag:1010 title:App_Name message:@"Are you sure you want cancel the process." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes"];
    else
        [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark-UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1010)
    {
        if(buttonIndex!=alertView.cancelButtonIndex)
        {
            Remove_User_Defaults;
            [self.navigationController  popViewControllerAnimated:YES];
        }
    }
    else if(alertView.tag==23232)
    {
        if(buttonIndex==alertView.cancelButtonIndex)
        {
            [self.navigationController  popViewControllerAnimated:YES];
        }
    }
}

#pragma mark-TableView Datasource & Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(indexPath.row==0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        
        UITextView *textView=(UITextView *)[cell.contentView viewWithTag:8976];
        textView.layer.cornerRadius = 5.0;
        textView.clipsToBounds = YES;
        textView.layer.borderWidth = 1.0f;
        textView.layer.borderColor=greenColor.CGColor;
        if(self.address)
            textView.text=self.address;
        else
            textView.text=@"Enter Address";
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        
        UILabel *headerLabel=(UILabel *)[cell.contentView viewWithTag:123467];
        if(indexPath.row==1)
        {
            headerLabel.text=@"Max Pick-Up Location from Home Location";
            pickupSegment =(UISegmentedControl *)[cell.contentView viewWithTag:12345];
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touched:)];
            [pickupSegment addGestureRecognizer:tap];
            UILabel *weightLabel=(UILabel *)[cell.contentView viewWithTag:1022];
            weightLabel.text=[NSString stringWithFormat:@"%0.1f",pickupDistance];
        }
        else
        {
            headerLabel.text=@"Max Delivery Location from Home Location";
            deliverySegment =(UISegmentedControl *)[cell.contentView viewWithTag:12345];
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touched:)];
            [deliverySegment addGestureRecognizer:tap];
            UILabel *weightLabel=(UILabel *)[cell.contentView viewWithTag:1022];
            weightLabel.text=[NSString stringWithFormat:@"%0.1f",deliveryDistance];

        }
        

    }
    
    cell.contentView.backgroundColor=[UIColor clearColor];
    
    UIView *backgroundView=(UIView *)[cell.contentView viewWithTag:1021];
    backgroundView.layer.cornerRadius = 5.0;
    backgroundView.clipsToBounds = YES;
    backgroundView.layer.borderWidth = 0.0f;
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 116.0;
}
- (void)touched:(UITapGestureRecognizer *) tapGesture {
    
    UISegmentedControl *segmentCOntrol=(UISegmentedControl *)tapGesture.view;
    CGPoint point = [tapGesture locationInView:segmentCOntrol];
    NSUInteger segmentSize = segmentCOntrol.bounds.size.width /segmentCOntrol.numberOfSegments;
    NSUInteger touchedSegment = point.x / segmentSize;
    segmentCOntrol.selectedSegmentIndex = touchedSegment;
    if(segmentCOntrol==pickupSegment)
        [self pickupSegmentPressed:segmentCOntrol];
    else
        [self distanceSegmentPressed:segmentCOntrol];
    
}
-(IBAction)pickupSegmentPressed:(id)sender
{
    UISegmentedControl *segmentControl=(UISegmentedControl *)sender;
    if(segmentControl.selectedSegmentIndex==0)
        pickupDistance=pickupDistance+0.5;
    else
    {
        if(pickupDistance>0)
            pickupDistance=pickupDistance-0.5;
    }
    UITableViewCell *cell=(UITableViewCell *)[[[segmentControl superview] superview] superview];
    UILabel *weightLabel=(UILabel *)[cell.contentView viewWithTag:1022];
    weightLabel.text=[NSString stringWithFormat:@"%0.1f",pickupDistance];
}
-(IBAction)distanceSegmentPressed:(id)sender
{
    UISegmentedControl *segmentControl=(UISegmentedControl *)sender;
    if(segmentControl.selectedSegmentIndex==0)
        deliveryDistance=deliveryDistance+0.5;
    else
    {
        if(deliveryDistance>0)
            deliveryDistance=deliveryDistance-0.5;
    }
    UITableViewCell *cell=(UITableViewCell *)[[[segmentControl superview] superview] superview];
    UILabel *weightLabel=(UILabel *)[cell.contentView viewWithTag:1022];
    weightLabel.text=[NSString stringWithFormat:@"%0.1f",deliveryDistance];
}
-(IBAction)mapButtonPress:(id)sender
{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LocationVC *obj=[storyBoard instantiateViewControllerWithIdentifier:@"LocationVC"];
    obj.intialSetupVC=self;
    obj.address=self.address;
    obj.isOPenForTo=YES;
    [self.navigationController presentViewController:obj animated:YES completion:nil];
    
}
-(IBAction)submitButtonPressed:(id)sender
{
    if(self.address.length==0)
        [AppHelper showAlertViewWithTag:11212 title:App_Name message:@"Address should not be blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    else if(pickupDistance==0.0)
        [AppHelper showAlertViewWithTag:11212 title:App_Name message:@"Pickup distance should not be 0." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    else if(deliveryDistance==0.0)
        [AppHelper showAlertViewWithTag:11212 title:App_Name message:@"Delivery distance should not be 0." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    else
    {
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:self.address forKey:@"address"];
        [dict setObject:UserID forKey:@"userId"];
        [dict setObject:[NSString stringWithFormat:@"%f",deliveryDistance] forKey:@"deliveryDistance"];
        [dict setObject:[NSString stringWithFormat:@"%f",pickupDistance] forKey:@"pickupDistance"];
        [dict setObject:[NSString stringWithFormat:@"%f",self.addressLocation.latitude] forKey:@"latitude"];
        [dict setObject:[NSString stringWithFormat:@"%f",self.addressLocation.longitude] forKey:@"longitude"];
        [[AppDelegate getAppDelegate] showLoadingView:@"Please Wait..."];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getResponseOfInitialSetup:) name:InitialSetup_Done_Notification object:nil];
        [[ServiceClass sharedServiceClass] initialSetupWithDictionary:dict];
        
    }
}
-(void)getResponseOfInitialSetup:(NSNotification *)notification
{
    if([notification.object count]>0)
    {
        [[AppDelegate getAppDelegate] hideLoadingView];
        if([[AppHelper unarchiveForKey:@"ParamForLocalDelivery"] count]==0)
        {
            [AppHelper archive:notification.object withKey:@"ParamForLocalDelivery"];
            [[AppDelegate getAppDelegate] addTabbar];
        }
        else
        {
            [AppHelper archive:notification.object withKey:@"ParamForLocalDelivery"];
            [AppHelper showAlertViewWithTag:23232 title:App_Name message:@"Data updated sucessfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            HomeVC *obj=(HomeVC *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
            //[obj getListOfSender];
        }
    }
}
@end
