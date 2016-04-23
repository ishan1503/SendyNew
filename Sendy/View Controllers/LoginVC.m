//
//  LoginVC.m
//  Sendy
//
//  Created by Ishan Shikha on 02/06/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "LoginVC.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"
#import "NMBottomTabBarController.h"
#import "ProfileSetupVC.h"
#import "VerifyOTPVC.h"
#import "HomeVC.h"
@interface LoginVC ()
{
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UIView *textFieldView;
    GTMOAuth2ViewControllerTouch *controller;
    LIALinkedInHttpClient *_client;
}

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     _client = [self client];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGesture];
    emailTextField.delegate=self;
    emailTextField.keyboardType=UIKeyboardTypeEmailAddress;
    passwordTextField.delegate=self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark-Gesture Delegates and Selectors

-(void)handleTap:(UITapGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
}
#pragma mark-Login Button Click
-(IBAction)loginButtonClick:(id)sender
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL myStringMatchesRegEx=[emailTest evaluateWithObject: emailTextField.text];
    
    if([emailTextField.text length]==0)
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Email should note be blank." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
    else if(!myStringMatchesRegEx)
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Invalid Email" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        return;
    }
    else if ([passwordTextField.text length]==0)
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Password should note be blank." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
    else
    {
        [emailTextField resignFirstResponder];
        [passwordTextField resignFirstResponder];
        if([AppDelegate getAppDelegate].isNetworkReachable)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetLoginInfo:) name:Login_Notification object:nil];
            NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:emailTextField.text,@"email",passwordTextField.text,@"password",nil];
            [[ServiceClass sharedServiceClass] loginUser:dict];
        }
        else
        {
            [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Please check your intenet connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        }
    }
}
-(void)GetLoginInfo:(NSNotification *)notif
{
    NSDictionary *dict=(NSDictionary *)notif.object;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Login_Notification object:nil];
    if([dict count]>0)
    {
        if([[dict objectForKey:@"ParamForLocalDelivery"] count]>0&&![[[dict objectForKey:@"ParamForLocalDelivery"] objectForKey:@"address"] isKindOfClass:[NSNull class]])
            [AppHelper archive:[dict objectForKey:@"ParamForLocalDelivery"] withKey:@"ParamForLocalDelivery"];
        NSDictionary *dict2=(NSDictionary *)[AppHelper unarchiveForKey:@"ParamForLocalDelivery"];
        
        [[AppDelegate getAppDelegate] hideLoadingView];
        [AppHelper archive:dict withKey:@"UserInfo"];
        //change by prankur
        
//        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        HomeVC  *ConversationVC_obj=[storyBoard instantiateViewControllerWithIdentifier: @"HomeVC"];
//        [self.navigationController pushViewController:ConversationVC_obj animated:YES];

        if([UserID length]>0&&[isVerified intValue]==0)
            [self performSegueWithIdentifier:@"VerifyOTP" sender:nil];
//        else if (([UserID length]>0&&[isVerified intValue]==1&&[dict2 count]==0))
//            [self performSegueWithIdentifier:@"InitialSetup" sender:nil];
        else
//            [UserID length]>0&&[isVerified intValue]==1&&[dict2 count]>0
            [[AppDelegate getAppDelegate] addTabbar];
        
    }
    else
    {
        [[AppDelegate getAppDelegate] hideLoadingView];
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProfileSetupVC *obj=[storyBoard instantiateViewControllerWithIdentifier:@"ProfileSetupVC"];
        if([AppHelper userDefaultsForKey:@"FBUserInfo"]!=nil)
            obj.socailUserInfo=(NSDictionary *)[AppHelper userDefaultsForKey:@"FBUserInfo"];
        else if ([AppHelper userDefaultsForKey:@"G+UserInfo"]!=nil)
            obj.socailUserInfo=(NSDictionary *)[AppHelper userDefaultsForKey:@"G+UserInfo"];
        else if ([AppHelper userDefaultsForKey:@"LiUserInfo"]!=nil)
            obj.socailUserInfo=(NSDictionary *)[AppHelper userDefaultsForKey:@"LiUserInfo"];
        [self.navigationController showViewController:obj sender:nil];
    }
    //[AppHelper removeFromUserDefaultsWithKey:@"FBUserInfo"];
   // [AppHelper removeFromUserDefaultsWithKey:@"LiUserInfo"];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"VerifyOTP"])
    {
        [(VerifyOTPVC *)segue.destinationViewController setMobileNumber:[[[AppHelper unarchiveForKey:@"UserInfo"] objectForKey:@"countryCode"]stringByAppendingString:[[AppHelper unarchiveForKey:@"UserInfo"] objectForKey:@"mobile"]]];
        [(VerifyOTPVC *)segue.destinationViewController setEmailID:[[AppHelper unarchiveForKey:@"UserInfo"] objectForKey:@"email"]];
        
    }
}
#pragma mark-Linked In Login
- (IBAction)didTapConnectWithLinkedIn:(id)sender
{
    [self.client getAuthorizationCode:^(NSString *code) {
        [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
            NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
            [self requestMeWithToken:accessToken];
        }                   failure:^(NSError *error) {
            NSLog(@"Quering accessToken failed %@", error);
        }];
    }         cancel:^{
        
    }  failure:^(NSError *error) {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:[NSString stringWithFormat:@"%@",error.localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }];
}
- (void)requestMeWithToken:(NSString *)accessToken {
    [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        NSLog(@"current user %@", result);
        [[AppDelegate getAppDelegate] hideLoadingView];
        NSDictionary *dict=(NSDictionary *)result;
        [AppHelper saveToUserDefaults:dict withKey:@"LiUserInfo"];
        [self socialLogin:[NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"id"],@"socialId",@"",@"email",@"ln",@"socialType",nil]];

    }        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:[NSString stringWithFormat:@"%@",error.localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }];
}

- (LIALinkedInHttpClient *)client {
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:@"https://86borders.com/dssb/oAuth2SocialNetwork/linkedin"
                                                                                    clientId:@"75vejl24ersx7y"
                                                                                clientSecret:@"Zw71n1amoA5bcx9s"
                                                                                       state:@"DCEEFWF45453sdffef424"
                                                                               grantedAccess:@[@"r_basicprofile+r_emailaddress"]];
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}
#pragma mark-Google Plus Login
-(IBAction)googlePlusLogin:(id)sender
{
    void (^handler)(id, id, id) =
    ^(GTMOAuth2ViewControllerTouch *viewController,
      GTMOAuth2Authentication *auth,
      NSError *error)
    {
        if (!error)
        {
            [[AppDelegate getAppDelegate] hideLoadingView];
            NSDictionary *dict=(NSDictionary *)controller.signIn.userProfile;
            [AppHelper saveToUserDefaults:dict withKey:@"G+UserInfo"];
            [self socialLogin:[NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"sub"],@"socialId",@"",@"email",@"gp",@"socialType",nil]];
        }
        else if(![sender isKindOfClass:[UIButton class]])
        {
            [[AppDelegate getAppDelegate] hideLoadingView];
            [AppHelper showAlertViewWithTag:101 title:App_Name message:[NSString stringWithFormat:@"%@",error.localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        }
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    };
    controller = [GTMOAuth2ViewControllerTouch
                  controllerWithScope:kGTLAuthScopePlusLogin
                  clientID:[GPPSignIn sharedInstance].clientID
                  clientSecret:@"yrPCBlB_I5tCpMab6AbNubT-"
                  keychainItemName:[GPPSignIn sharedInstance].keychainName
                  completionHandler:handler] ;
    controller.signIn.shouldFetchGoogleUserEmail = YES;
    controller.signIn.shouldFetchGoogleUserProfile=YES;
    
    [self presentViewController:controller animated:YES completion:^{
    }];
    
    
}
#pragma mark-Facebook Login
-(IBAction)facebookLogin:(id)sender
{
    [[AppDelegate getAppDelegate] showLoadingView:@"Please Wait..."];
    FBSDKLoginManager *FBlogin = [[FBSDKLoginManager alloc] init];
    [FBlogin logOut];
    [FBlogin logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error)
        {
            [[AppDelegate getAppDelegate] hideLoadingView];
            [AppHelper showAlertViewWithTag:101 title:App_Name message:[NSString stringWithFormat:@"%@",error.localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        }
        else if (result.isCancelled)
        {
            [[AppDelegate getAppDelegate] hideLoadingView];
            [AppHelper showAlertViewWithTag:101 title:App_Name message:@"You have cancel the authentication process." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        }
        else
        {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"email"])
            {
                if ([FBSDKAccessToken currentAccessToken])
                {
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id user, NSError *error)
                     {
                         if (!error)
                         {
                             [[AppDelegate getAppDelegate] hideLoadingView];
                             NSDictionary *dict=(NSDictionary *)user;
                             [AppHelper saveToUserDefaults:dict withKey:@"FBUserInfo"];

                             [self socialLogin:[NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"id"],@"socialId",@"",@"email",@"fb",@"socialType",nil]];
                         }
                     }];
                }
            }
            else
            {
                [[AppDelegate getAppDelegate] hideLoadingView];
                
            }
        }
    }];
}
#pragma Mark-Social Login
-(void)socialLogin:(NSDictionary *)dict
{
    if([AppDelegate getAppDelegate].isNetworkReachable)
    {
        [[AppDelegate getAppDelegate] showLoadingView:@"Please Wait..."];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetLoginInfo:) name:Login_Notification object:nil];
        [[ServiceClass sharedServiceClass] checkUserMethod:[dict mutableCopy]];
    }
    else
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Please check your intenet connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
    
}
@end
