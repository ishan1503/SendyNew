//
//  WelcomeScreenVC.m
//  Sendy
//
//  Created by Ishan Shikha on 24/05/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "WelcomeScreenVC.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "ProfileSetupVC.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import "LIALinkedInHttpClient.h"
//#import "LIALinkedInClientExampleCredentials.h"
#import "LIALinkedInApplication.h"
#import "TTTAttributedLabel.h"
#import "ProfileSetupVC.h"
#import "VerifyOTPVC.h"
#import "HomeVC.h"
@interface WelcomeScreenVC ()
{
    GTMOAuth2ViewControllerTouch *controller;
    LIALinkedInHttpClient *_client;
    IBOutlet TTTAttributedLabel *bottomLabel;
    IBOutlet UILabel *messageLabel;
    IBOutlet UIView *signupview;
    NSString *serviceSelected;
    NSDictionary *dict;
    IBOutlet NSLayoutConstraint *height;
    IBOutlet UIButton *loginbtn;
    
}
@end

@implementation WelcomeScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //self.headerView.hidden=YES;
    _client = [self client];
      // Do any additional setup after loading the view.
    bottomLabel.delegate=self;
    bottomLabel.linkAttributes = @{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                    NSUnderlineStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle] };

    NSRange r1 = [bottomLabel.text rangeOfString:@"Terms & Condition"];
    NSRange r2 = [bottomLabel.text rangeOfString:@"Privacy Policy"];
    [bottomLabel addLinkToURL:[NSURL URLWithString:@"action://show-Terms"] withRange:r1];
    [bottomLabel addLinkToURL:[NSURL URLWithString:@"action://show-Privacy"] withRange:r2];
}



- (void)viewWillLayoutSubviews
{
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:signupview.bounds];
    signupview.layer.masksToBounds = NO;
    signupview.layer.shadowColor = [UIColor blackColor].CGColor;
    signupview.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    signupview.layer.shadowOpacity = 0.5f;
    signupview.layer.shadowPath = shadowPath.CGPath;
    
    loginbtn.layer.cornerRadius = 20;
    loginbtn.layer.borderWidth = 1;
    loginbtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view layoutIfNeeded];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if ([[url scheme] hasPrefix:@"action"]) {
        if ([[url host] hasPrefix:@"show-Terms"]) {
            [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Terms & Conditions is under development" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        } else if ([[url host] hasPrefix:@"show-Privacy"]) {
            [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Privacy Policy is under development" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        }
    } else {
        /* deal with http links here */
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-Manual Registration
-(IBAction)openManualRegistration:(id)sender
{
    [self performSegueWithIdentifier:@"Manual Registration" sender:nil];
}
#pragma mark-Linked In Login
- (IBAction)didTapConnectWithLinkedIn:(id)sender {
    [self.client getAuthorizationCode:^(NSString *code) {
        [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
            NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
            [self requestMeWithToken:accessToken];
        }                   failure:^(NSError *error) {
            NSLog(@"Quering accessToken failed %@", error);
        }];
    }                      cancel:^{
     
    }                     failure:^(NSError *error) {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:[NSString stringWithFormat:@"%@",error.localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }];
}
- (void)requestMeWithToken:(NSString *)accessToken {
    [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        NSLog(@"current user %@", result);
        [[AppDelegate getAppDelegate] hideLoadingView];
        dict=(NSDictionary *)result;
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
            dict=(NSDictionary *)controller.signIn.userProfile;
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
    serviceSelected=@"FB";
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
                             
                             dict=(NSDictionary *)user;
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
#pragma mark-Perform Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Manual Registration"])
    {
        ProfileSetupVC *obj=segue.destinationViewController;
        if([AppHelper userDefaultsForKey:@"FBUserInfo"]!=nil)
            obj.socailUserInfo=(NSDictionary *)[AppHelper userDefaultsForKey:@"FBUserInfo"];
        else if ([AppHelper userDefaultsForKey:@"G+UserInfo"]!=nil)
           obj.socailUserInfo=(NSDictionary *)[AppHelper userDefaultsForKey:@"G+UserInfo"];
        else if ([AppHelper userDefaultsForKey:@"LiUserInfo"]!=nil)
            obj.socailUserInfo=(NSDictionary *)[AppHelper userDefaultsForKey:@"LiUserInfo"];
    }
    else if([segue.identifier isEqualToString:@"VerifyOTP"])
    {
        [(VerifyOTPVC *)segue.destinationViewController setMobileNumber:[[[AppHelper unarchiveForKey:@"UserInfo"] objectForKey:@"countryCode"]stringByAppendingString:[[AppHelper unarchiveForKey:@"UserInfo"] objectForKey:@"mobile"]]];
        [(VerifyOTPVC *)segue.destinationViewController setEmailID:[[AppHelper unarchiveForKey:@"UserInfo"] objectForKey:@"email"]];
    }
}

#pragma Mark-Social Login
-(void)socialLogin:(NSDictionary *)dict1
{
    if([AppDelegate getAppDelegate].isNetworkReachable)
    {
        [[AppDelegate getAppDelegate] showLoadingView:@"Please Wait..."];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetLoginInfo:) name:Login_Notification object:nil];
        [[ServiceClass sharedServiceClass] checkUserMethod:[dict1 mutableCopy]];
    }
    else
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Please check your intenet connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
}
-(void)GetLoginInfo:(NSNotification *)notif
{
    NSDictionary *dict1=(NSDictionary *)notif.object;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Login_Notification object:nil];
    if([dict1 count]>0)
    {
        if([[dict1 objectForKey:@"ParamForLocalDelivery"] count]>0&&![[[dict objectForKey:@"ParamForLocalDelivery"] objectForKey:@"address"] isKindOfClass:[NSNull class]])
            [AppHelper archive:[dict1 objectForKey:@"ParamForLocalDelivery"] withKey:@"ParamForLocalDelivery"];

        NSDictionary *dict3=(NSDictionary *)[AppHelper unarchiveForKey:@"ParamForLocalDelivery"];
        
        [[AppDelegate getAppDelegate] addTabbar];
//        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        HomeVC  *ConversationVC_obj=[storyBoard instantiateViewControllerWithIdentifier: @"HomeVC"];
//        [self.navigationController pushViewController:ConversationVC_obj animated:YES];

        
        [AppHelper archive:dict1 withKey:@"UserInfo"];
        [[AppDelegate getAppDelegate] hideLoadingView];
//        if([UserID length]>0&&[isVerified intValue]==0)
//            [self performSegueWithIdentifier:@"VerifyOTP" sender:nil];
//        else if (([UserID length]>0&&[isVerified intValue]==1&&[dict3 count]==0))
//            [self performSegueWithIdentifier:@"InitialSetup" sender:nil];
//        else if([UserID length]>0&&[isVerified intValue]==1&&[dict3 count]>0)
         //   [[AppDelegate getAppDelegate] addTabbar];
    }
    else
    {
       
        if([AppHelper userDefaultsForKey:@"FBUserInfo"]!=nil)
        {
            [self performSegueWithIdentifier:@"Manual Registration" sender:nil];
            
        }
        else if ([AppHelper userDefaultsForKey:@"G+UserInfo"]!=nil)
        {
            [self performSegueWithIdentifier:@"Manual Registration" sender:nil];

        }
        else if ([AppHelper userDefaultsForKey:@"LiUserInfo"]!=nil)
        {
            [self performSegueWithIdentifier:@"Manual Registration" sender:nil];

        }
    }
    //[AppHelper removeFromUserDefaultsWithKey:@"FBUserInfo"];
    //[AppHelper removeFromUserDefaultsWithKey:@"LiUserInfo"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
