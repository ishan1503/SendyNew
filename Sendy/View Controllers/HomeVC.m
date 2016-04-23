//
//  HomeVC.m
//  Sendy
//
//  Created by Ishan Shikha on 21/06/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "HomeVC.h"
#import "ProfileSetupVC.h"
#import "CourierOptionVC.h"
@interface HomeVC ()
{
    IBOutlet UITableView *tableview;
    IBOutlet UILabel *messageLabel;
}

@end

@implementation HomeVC
-(void)viewWillDisappear:(BOOL)animated
{

}
-(void)viewWillAppear:(BOOL)animated
{

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [AppDelegate getAppDelegate].ismodifyjob = @"createnewitem";
}

-(IBAction)addButtonPress:(id)sender
{
    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileSetupVC *profileSetupVC=[mainStoryBoard instantiateViewControllerWithIdentifier:@"ProfileSetupVC"];
    profileSetupVC.isComingtoEdit=YES;
    [self.navigationController showViewController:profileSetupVC sender:nil];
}
-(IBAction)deliverButtonPress:(id)sender
{
    UIStoryboard *deliveryStoryBoard=[UIStoryboard storyboardWithName:@"Delivery" bundle:nil];
    CourierOptionVC *obj=[deliveryStoryBoard instantiateViewControllerWithIdentifier:@"CourierOptionVC"];
    [self.navigationController pushViewController:obj animated:YES];
}
@end
