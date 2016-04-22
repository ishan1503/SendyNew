//
//  Define.h
//  Infinea
//
//  Created by Ritu Dalal on 6/26/14.
//  Copyright (c) 2014 Ritu Dalal. All rights reserved.
//

#ifndef Infinea_Define_h
#define Infinea_Define_h

#define App_Name                                    @"Sendy"
#define BaseUrl                                     @"http://52.89.119.20/Api/"






#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define greenColor [UIColor colorWithRed:(41/255.0) green:(168/255.0) blue:(147/255.0) alpha:1.0]
#define Remove_User_Defaults             NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];[[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];[AppHelper removeFromUserDefaultsWithKey:@"FBUserInfo"];[AppHelper removeFromUserDefaultsWithKey:@"LiUserInfo"];[AppHelper removeFromUserDefaultsWithKey:@"G+UserInfo"]

#define UserID  [[AppHelper unarchiveForKey:@"UserInfo"]objectForKey:@"userId"]
#define isVerified  [[AppHelper unarchiveForKey:@"UserInfo"]objectForKey:@"isVerified"]

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


//Notification
#define Registeration_Notification                 @"Registeration_Notification"
#define VerifyOTP_Notification                     @"VerifyOTP_Notification"
#define resendOTP_Notification                     @"resendOTP_Notification"
#define Twitter_Tokens_Rvcd                        @"Twitter_Tokens_Rvcd"
#define Profile_Setup__Notification_Rvcd           @"Profile_Setup__Notification_Rvcd"
#define Login_Notification                         @"Login_Notification"
#define checkUser_Notification                     @"checkUser_Notification"
#define CreateTrip_Notification                    @"CreateTrip_Notification"
#define EditTrip_Notification                      @"EditTrip_Notification"
#define SearchTrip_Notification                    @"SearchTrip_Notification"
#define AwardTrip_Notification                     @"AwardTrip_Notification"
#define MyDeliveries_Notification                  @"MyDeliveries_Notification"
#define CancelTrip_Notification                    @"CancelTrip_Notification"
#define CancelItem_Notification                    @"CancelItem_Notification"
#define Activity_Notification                      @"Activity_Notification"

#define MyTrip_Notification                        @"MyTrip_Notification"
#define InitialSetup_Done_Notification             @"InitialSetup_Done_Notification"
#define Item_Created_Notification                  @"Item_Created_Notification"
#define Item_Updated_Notification                  @"Item_Updated_Notification"
#define Sender_Near_By_You_Notification            @"Sender_Near_By_You_Notification"
#define Post_Bid_Notification                      @"Post_Bid_Notification"
#define Delivere_Trip_RCVD_Notification            @"Delivere_Trip_RCVD_Notification"
#define Current_Offers_RCVD_Notification           @"Current_Offers_RCVD_Notification"
#define Job_Awarded_Notification                   @"Job_Awarded_Notification"
#define Awarded_Deliveries_As_Sender_Notification  @"Awarded_Deliveries_As_Sender_Notification"
#define Awarded_Deliveries_As_Deliverer_Notification  @"Awarded_Deliveries_As_Deliverer_Notification"
#define Completed_Deliveries_As_Sender_Notification  @"Completed_Deliveries_As_Sender_Notification"
#define Completed_Deliveries_As_Deliverer_Notification  @"Completed_Deliveries_As_Deliverer_Notification"
#define Bids_Deliverer_Rcvd_Notification                   @"Bids_Deliverer_Rcvd_Notification"


//Service Method
#define Register        @"register"
#define VerifyOTP       @"verifyOTP"
#define resendOTP       @"resendOTP"
#define profileSetup    @"profileSetup"
#define login1          @"login1"
#define forgotPassword  @"forgotPassword"
#define socialLogin1      @"socialLogin"
#define changePassword  @"changePassword"
#define updateProfile   @"updateProfile"
#define createTrip      @"createTrip"
#define editTrip        @"updateTrip"
#define findTrip        @"findTrip"
#define awardJob        @"awardJob"
#define myDeliveries    @"myDeliveries"
#define myTrip          @"myTrip"
#define cancelTrip1             @"cancelTrip"
#define offerLocalDelivery      @"setParamForLocalDelivery"
#define CreateItemForDelivery   @"CreateItemForDelivery"
#define sender_near_by_you      @"senderNearByYou"
#define postBid                 @"postBid"
#define tripsAsDeliverer        @"tripsAsDeliverer"
#define currentOfferAsSender    @"currentOfferAsSender"
#define awardJob                @"awardJob"
#define awardedAsSender           @"awardedAsSender"
#define completedDeliveryAsSender @"completedDeliveryAsSender"
#define completedAsDeliverer    @"completedAsDeliverer"
#define bidsAsDeliverer            @"bidsAsDeliverer"
#define cancelItem              @"cancelItem"
#define editItem                @"editItem"
#define awardedAsDeliverer      @"awardedAsDeliverer"


//Keys
#define parm_firstName          @"firstName"
#define parm_lastName           @"lastName"
#define parm_email              @"email"
#define parm_mobile             @"mobile"
#define parm_countryCode        @"countryCode"
#define parm_password           @"password"
#define parm_socialId           @"socialId"
#define parm_socialType         @"socialType"
#define parm_image              @"image"
#define parm_deviceType         @"deviceType"
#define parm_deviceId           @"deviceId"

//new item by prankur
#define createItem              @"createItem"
#define postedJobs              @"postedJobs"
#define inProgressJobs          @"inProgressJobs"
#define completedJobs           @"completedJobs"
#define deletePostedJobs        @"deletePostedJobs"

//notifications
#define create_item_notification    @"create_item_notification"
#define Posted_job_Listing          @"Posted_job_Listing"
#define delete_postedjob_notification   @"delete_postedjob_notification"

#endif

