//
//  create_send_item_2.m
//  Sendy
//
//  Created by Prankur on 16/03/16.
//  Copyright (c) 2016 Ishan Gupta. All rights reserved.
//

#import "create_send_item_2.h"
#import "ProfileSetupVC.h"
#import "LocationVC.h"
#import "create_senditem_3.h"
#import <MapKit/MapKit.h>


@interface create_send_item_2 ()

@end

@implementation create_send_item_2
{
    CLLocationManager   *   locationManager;
    IBOutlet MKMapView  *  mapview_selectloc;
    IBOutlet UITextField* itemtxt;
    IBOutlet UITextField* fromtxt;
    IBOutlet UITextField* totxt;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    mapview_selectloc.showsUserLocation = YES;
    [mapview_selectloc setMapType:MKMapTypeStandard];
    [mapview_selectloc setZoomEnabled:YES];
    [mapview_selectloc setScrollEnabled:YES];
    if([[AppDelegate getAppDelegate].ismodifyjob  isEqual: @"modifydata"])
    {
        itemtxt.text = [[AppDelegate getAppDelegate].senderDeliverydata objectForKey:@"itemName"];
        self.fromAddress =  [[AppDelegate getAppDelegate].senderDeliverydata objectForKey:@"fromAddress"];
        self.toAddress = [[AppDelegate getAppDelegate].senderDeliverydata objectForKey:@"toAddress"];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    totxt.text = self.toAddress;
    fromtxt.text = self.fromAddress;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)openProfile:(id)sender
{
    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileSetupVC *profileSetupVC=[mainStoryBoard instantiateViewControllerWithIdentifier:@"ProfileSetupVC"];
    profileSetupVC.isComingtoEdit=YES;
    [self.navigationController showViewController:profileSetupVC sender:nil];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == totxt)
    {
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LocationVC *obj=[storyBoard instantiateViewControllerWithIdentifier:@"LocationVC"];
        obj.creatsenditem2obj=self;
        obj.address=self.toAddress;
        obj.isOPenForTo=NO;
        [self.navigationController presentViewController:obj animated:YES completion:nil];
    }
    else if(textField == fromtxt)
    {
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LocationVC *obj=[storyBoard instantiateViewControllerWithIdentifier:@"LocationVC"];
        obj.creatsenditem2obj=self;
        obj.address=self.fromAddress;
        obj.isOPenForTo=YES;
        [self.navigationController presentViewController:obj animated:YES completion:nil];
    }
    
    
//    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    LocationVC *obj=[storyBoard instantiateViewControllerWithIdentifier:@"LocationVC"];
//    obj.creatsenditem2obj=self;
////    obj.address=self.toAddress;
////    obj.isOPenForTo=YES;
//    [self.navigationController presentViewController:obj animated:YES completion:nil];
    return false;
}
- (IBAction)nextAction:(id)sender
{
    if([itemtxt.text length] == 0)
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Please Enter item name." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        return;
    }
    else if([fromtxt.text length] == 0)
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Please enter From address" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        return;
    }
    else if([totxt.text length] == 0)
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Please Enter To address" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        return;
    }
    
    [[AppDelegate getAppDelegate].senderDeliverydata setObject:self.fromAddress forKey:@"fromAddress"];
    [[AppDelegate getAppDelegate].senderDeliverydata setObject:[NSString stringWithFormat:@"%f",self.fromAddressLocation.latitude] forKey:@"fromLat"];
    [[AppDelegate getAppDelegate].senderDeliverydata setObject:[NSString stringWithFormat:@"%f",self.fromAddressLocation.latitude] forKey:@"fromLong"];
    [[AppDelegate getAppDelegate].senderDeliverydata setObject:itemtxt.text forKey:@"itemName"];
    [[AppDelegate getAppDelegate].senderDeliverydata setObject:self.toAddress forKey:@"toAddress"];
    [[AppDelegate getAppDelegate].senderDeliverydata setObject:[NSString stringWithFormat:@"%f",self.toAddressLocation.latitude] forKey:@"toLat"];
    [[AppDelegate getAppDelegate].senderDeliverydata setObject:[NSString stringWithFormat:@"%f",self.toAddressLocation.longitude] forKey:@"toLong"];
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    create_senditem_3 *obj=[storyBoard instantiateViewControllerWithIdentifier:@"create_senditem_3"];
    [self.navigationController pushViewController:obj animated:true];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
}

@end
