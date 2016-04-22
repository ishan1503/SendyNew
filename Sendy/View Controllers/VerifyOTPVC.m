//
//  VerifyOTPVC.m
//  Sendy
//
//  Created by Ishan Shikha on 25/05/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "VerifyOTPVC.h"
#import <QuartzCore/QuartzCore.h>
#import "HomeVC.h"

@interface VerifyOTPVC ()
{
 
}
@end

@implementation VerifyOTPVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mobilleOTP.layer.cornerRadius=6.0f;
    _mobilleOTP.layer.masksToBounds=YES;
    _mobilleOTP.layer.borderColor=[[UIColor colorWithRed:36.0/255.0 green:155.0/255.0 blue:129.0/255.0 alpha:1.0]CGColor];
    _mobilleOTP.layer.borderWidth= 2.0f;
    _mobilleOTP.delegate=self;
    
    _emailOTP.layer.cornerRadius=6.0f;
    _emailOTP.layer.masksToBounds=YES;
    _emailOTP.layer.borderColor=[[UIColor colorWithRed:36.0/255.0 green:155.0/255.0 blue:129.0/255.0 alpha:1.0]CGColor];
    _emailOTP.layer.borderWidth= 2.0f;
    _emailOTP.delegate=self;
    
    _headerLabel.text=[NSString stringWithFormat:@"Please enter an OTP sent to your mobile number %@ & Email ID %@",_mobileNumber,_emailID];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-Verify OTP Action
-(IBAction)verifyOTP:(id)sender
{
    if([_mobilleOTP.text length]==0)
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Mobile OTP should not be blank." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
    }
    else if([_emailOTP.text length]==0)
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Email OTP should not be blank." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];

    }
    else
    {
        [_mobilleOTP resignFirstResponder];
        [_emailOTP resignFirstResponder];
        if([AppDelegate getAppDelegate].isNetworkReachable)
        {
            [[AppDelegate getAppDelegate] showLoadingView:@"Please wait.."];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HandleVerifyOTPResponse:) name:VerifyOTP_Notification object:nil];
            NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:UserID,@"userId",_emailOTP.text,@"emailOTP",_mobilleOTP.text,@"mobileOTP", nil];
            [[ServiceClass sharedServiceClass] verifyOTP:dict];
        }
        else
        {
            [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Please check your intenet connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        }
        
    }
}
-(void)HandleVerifyOTPResponse:(NSNotification *)notif
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:VerifyOTP_Notification object:nil];
    [[AppDelegate getAppDelegate] hideLoadingView];
    if(notif.object!=nil)
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Verification Successful!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        NSDictionary *dict=(NSDictionary *)[AppHelper unarchiveForKey:@"UserInfo"];
        [dict setValue:@"1" forKey:@"isVerified"];
        [AppHelper archive:dict withKey:@"UserInfo"];
        
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HomeVC  *ConversationVC_obj=[storyBoard instantiateViewControllerWithIdentifier: @"HomeVC"];
        [self.navigationController pushViewController:ConversationVC_obj animated:YES];
        
        
        //[self performSegueWithIdentifier:@"movetohome_fr_otp" sender:nil];
       // [[AppDelegate getAppDelegate] addTabbar];
    }
}
#pragma mark-Verify OTP Action
-(IBAction)resendOTPAction:(id)sender
{
    if([AppDelegate getAppDelegate].isNetworkReachable)
    {
        [[AppDelegate getAppDelegate] showLoadingView:@"Please wait.."];
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:UserID,@"userId", nil];
        [[ServiceClass sharedServiceClass] resendOTPOfUser:dict];
    }
    else
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Please check your intenet connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }

    
}
#pragma mark-Cancel Button Action
-(IBAction)cancelButtonAction:(id)sender
{
    [AppHelper showAlertViewWithTag:1010 title:App_Name message:@"Are you sure you want cancel the registration process." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes"];
   
}

#pragma mark-UIAlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1010)
    {
        if(buttonIndex!=alertView.cancelButtonIndex)
        {
            Remove_User_Defaults;
            [self.navigationController  popToRootViewControllerAnimated:YES];
        }
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
