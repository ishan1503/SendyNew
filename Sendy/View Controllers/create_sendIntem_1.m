//
//  create_sendIntem_1.m
//  Sendy
//
//  Created by Prankur on 16/03/16.
//  Copyright (c) 2016 Ishan Gupta. All rights reserved.
//

#import "create_sendIntem_1.h"
#import "ProfileSetupVC.h"

@interface create_sendIntem_1 ()

@end

@implementation create_sendIntem_1

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)openProfile:(id)sender
{
    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileSetupVC *profileSetupVC=[mainStoryBoard instantiateViewControllerWithIdentifier:@"ProfileSetupVC"];
    profileSetupVC.isComingtoEdit=YES;
    [self.navigationController showViewController:profileSetupVC sender:nil];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:true];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.createitemdict = [[NSMutableDictionary alloc]init];
    [AppDelegate getAppDelegate].senderDeliverydata = [[NSMutableDictionary alloc]init];
    if([segue.identifier isEqualToString:@"localtosend2"])
    {
        [[AppDelegate getAppDelegate].senderDeliverydata setObject:@"local" forKey:@"jobType"];
    }
    else if ([segue.identifier isEqualToString:@"longtosend2"])
    {
        [[AppDelegate getAppDelegate].senderDeliverydata setObject:@"long" forKey:@"jobType"];
    }
}

@end
