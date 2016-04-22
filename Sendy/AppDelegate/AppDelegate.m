//
//  AppDelegate.m
//  Sendy
//
//  Created by Ishan Shikha on 22/05/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import <GooglePlus/GooglePlus.h>
#import "NMBottomTabBarController.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <Quickblox/Quickblox.h>
#import "ChatService.h"
#import "Define.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
static NSString * const kClientID =@"652996012964-tfgir3aakin1iopjn3cuonls77iisojr.apps.googleusercontent.com";


+(AppDelegate *)getAppDelegate
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   // [self addTabbar];
    
  /*  self.imageArray=[[NSMutableArray alloc] initWithObjects:@"books",@"cloths",@"document",@"electronic",@"food",@"household",@"personal",@"other", nil];
    self.labelArray=[[NSMutableArray alloc] initWithObjects:@"Books",@"Clothing & Accessories",@"Documents",@"Electronics",@"Food & Drinks",@"Household Items",@"Personal Items",@"Others", nil];
    
    [QBApplication sharedApplication].applicationId = 25751;
    [QBConnection registerServiceKey:@"ujSnwQ6prvtGbDc"];
    [QBConnection registerServiceSecret:@"4rWwNT8Y6GegMV4"];
    [QBSettings setAccountKey:@"C3Y5kBXaroYVtXsqQFBg"];
   */

//    [QBApplication sharedApplication].applicationId = 31654;
//    [QBConnection registerServiceKey:@"vurWfW4zB4EPGP8"];
//    [QBConnection registerServiceSecret:@"s9F8edpxCyyZwg4"];
//    [QBSettings setAccountKey:@"Nys41WGQfGQ6M8Ge7FBc"];
//
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [GPPSignIn sharedInstance].clientID = kClientID;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    [NSThread sleepForTimeInterval:3.0];
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            _isNetworkReachable=YES;
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            _isNetworkReachable=NO;
        });
    };
    [reach startNotifier];
    //[self createQuickBloxSession];
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
    return YES;
    
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}
-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        _isNetworkReachable=YES;
    }
    else
    {
        _isNetworkReachable=NO;
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
   // if ([GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation])
        //return [GPPURLHandler handleURL:url  sourceApplication:sourceApplication annotation:annotation];
  //  else
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                             openURL:url
                                                   sourceApplication:sourceApplication
                                                          annotation:annotation];

//return NO;
    

        //return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.abc.Sample.Sendy" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Sendy" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Sendy.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}
#pragma mark Loading View

-(void)showLoadingView:(NSString*)msg
{
    if (activityView1 == nil)
    {
        activityView1 = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 768, 1024)];
        
        activityView1.backgroundColor = [UIColor clearColor];
        activityView1.alpha = 0.8;
        
        UIView* viewLoading;
        UILabel* lblLoading;
        UIActivityIndicatorView *activityWheel;
        
        
        viewLoading=[[UIView alloc] initWithFrame:CGRectMake(([self widthOfDevice]-100)/2, ([self heightOfDevice]-100)/2, 100, 100)];
        lblLoading=[[UILabel alloc] initWithFrame:CGRectMake(([self widthOfDevice]-100)/2, (([self heightOfDevice]-100)/2)-15, 100, 100)];
        activityWheel=[[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(([self widthOfDevice]-20)/2, (([self heightOfDevice]-100)/2)+60, 20, 20)];
        
        viewLoading.backgroundColor=[UIColor blackColor];
        CALayer *layer = [viewLoading layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:8.0];
        [layer setBorderWidth:1.0];
        [activityView1 addSubview:viewLoading];
        
        lblLoading.numberOfLines=0;
        lblLoading.text=msg;
        lblLoading.backgroundColor=[UIColor clearColor];
        lblLoading.textAlignment=NSTextAlignmentCenter;
        [lblLoading setContentMode:UIViewContentModeBottom];
        lblLoading.textColor=[UIColor whiteColor];
        [lblLoading setFont:[UIFont systemFontOfSize:14.0]];
        activityWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        activityWheel.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                          UIViewAutoresizingFlexibleRightMargin |
                                          UIViewAutoresizingFlexibleTopMargin |
                                          UIViewAutoresizingFlexibleBottomMargin);
        
        [activityView1 addSubview:lblLoading];
        [activityView1 addSubview:activityWheel];
    }
    
    [self.window addSubview: activityView1];
    [[[activityView1 subviews] objectAtIndex:1] setText:msg];
    [[[activityView1 subviews] objectAtIndex:2] startAnimating];
    
}

-(void)hideLoadingView
{
    [[[activityView1 subviews] objectAtIndex:2] stopAnimating];
    [activityView1 removeFromSuperview];
}
-(CGFloat)widthOfDevice
{
    if(IS_IPHONE_4_OR_LESS)
        return 320.0;
    else if(IS_IPHONE_5)
        return 320.0;
    else if(IS_IPHONE_6)
        return 375.0;
    else if(IS_IPHONE_6P)
        return 414.0;
    else
        return 0.0;
}
-(CGFloat)heightOfDevice
{
    if(IS_IPHONE_4_OR_LESS)
        return 468.0;
    else if(IS_IPHONE_5)
        return 568.0;
    else if(IS_IPHONE_6)
        return 667.0;
    else if(IS_IPHONE_6P)
        return 736.0;
    else
        return 0.0;
    
}
#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
#pragma mark-Tab Bar Methods
-(void)addTabbar
{
    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *homeNavigation=[mainStoryBoard instantiateViewControllerWithIdentifier:@"HomeNavigation"];
    UINavigationController *messageNavigation=[mainStoryBoard instantiateViewControllerWithIdentifier:@"MessageNavigation"];
    UINavigationController *activityNavigation=[mainStoryBoard instantiateViewControllerWithIdentifier:@"MyActivityNavigation"];
    UINavigationController *moreNavigation=[mainStoryBoard instantiateViewControllerWithIdentifier:@"MoreNavigation"];
    NMBottomTabBarController *tabBarController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"NMBottomTabBarControllerTab"];
    self.window.rootViewController=tabBarController;
    tabBarController.tabBar.separatorImage = [UIImage imageNamed:@"divider.png"];
    tabBarController.controllers = [NSArray arrayWithObjects:homeNavigation,messageNavigation,activityNavigation,moreNavigation, nil];
    tabBarController.delegate = self;
    [tabBarController.tabBar configureTabAtIndex:0 andTitleOrientation :kTItleToBottomOfIcon  withUnselectedBackgroundImage:[UIImage imageNamed:@"tabbarbg.png"] selectedBackgroundImage:[UIImage imageNamed:@"tabbarbg_active.png"] iconImage:[UIImage imageNamed:@"home"] iconImageSelected:[UIImage imageNamed:@"home_active"] andText:@"Home"andTextFont:[UIFont systemFontOfSize:12.0] andFontColour:[UIColor whiteColor]];
    [tabBarController.tabBar configureTabAtIndex:1 andTitleOrientation : kTItleToBottomOfIcon withUnselectedBackgroundImage:[UIImage imageNamed:@"tabbarbg.png"] selectedBackgroundImage:[UIImage imageNamed:@"tabbarbg_active.png"] iconImage:[UIImage imageNamed:@"msg"] iconImageSelected:[UIImage imageNamed:@"msg_active"] andText:@"Messages" andTextFont:[UIFont systemFontOfSize:12.0] andFontColour:[UIColor whiteColor]];
    [tabBarController.tabBar configureTabAtIndex:2 andTitleOrientation : kTItleToBottomOfIcon withUnselectedBackgroundImage:[UIImage imageNamed:@"tabbarbg.png"] selectedBackgroundImage:[UIImage imageNamed:@"tabbarbg_active.png"] iconImage:[UIImage imageNamed:@"activity"] iconImageSelected:[UIImage imageNamed:@"activity_active"] andText:@"My Activity" andTextFont:[UIFont systemFontOfSize:12.0] andFontColour:[UIColor whiteColor]];
    [tabBarController.tabBar configureTabAtIndex:3 andTitleOrientation : kTItleToBottomOfIcon withUnselectedBackgroundImage:[UIImage imageNamed:@"tabbarbg.png"] selectedBackgroundImage:[UIImage imageNamed:@"tabbarbg_active.png"] iconImage:[UIImage imageNamed:@"more"] iconImageSelected:[UIImage imageNamed:@"more_active"] andText:@"More" andTextFont:[UIFont systemFontOfSize:12.0] andFontColour:[UIColor whiteColor]];
    tabBarController.tabBar.hidden = false;
    [tabBarController selectTabAtIndex:0];
    [AppHelper removeFromUserDefaultsWithKey:@"FBUserInfo"];
    [AppHelper removeFromUserDefaultsWithKey:@"LiUserInfo"];
}


-(void)createQuickBloxSession
{
    QBSessionParameters *extendedAuthRequest = [[QBSessionParameters alloc] init];
    NSString *model = [[UIDevice currentDevice] model];
    NSDictionary *dict2=(NSDictionary *)[AppHelper unarchiveForKey:@"ParamForLocalDelivery"];
    if ([model isEqualToString:@"iPhone Simulator"])
    {
        extendedAuthRequest.userLogin = [[AppHelper unarchiveForKey:@"UserInfo"]objectForKey:@"email"];
        extendedAuthRequest.userPassword = @"sendy@123";
        //extendedAuthRequest.userLogin = @"test12";
        //extendedAuthRequest.userPassword = @"test12345";
    }
    else
    {
        extendedAuthRequest.userLogin = [AppHelper userDefaultsForKey:parm_email];
        extendedAuthRequest.userPassword = @"sendy@123";
    }
    //__weak __typeof(self)weakSelf = self;
    [QBRequest createSessionWithExtendedParameters:extendedAuthRequest successBlock:^(QBResponse *response, QBASession *session) {
        // Save current user
        //
        QBUUser *currentUser = [QBUUser user];
        currentUser.ID = session.userID;
        if ([model isEqualToString:@"iPhone Simulator"]) {
            currentUser.login = [[AppHelper unarchiveForKey:@"UserInfo"]objectForKey:@"email"];
            currentUser.password = @"sendy@123";

//            currentUser.login = @"test12";
//            currentUser.password = @"test12345";
        }else{
            currentUser.login = [AppHelper userDefaultsForKey:parm_email];
            currentUser.password = @"sendy@123";
        }
        // Login to QuickBlox Chat
        //
        [[ChatService shared] loginWithUser:currentUser completionBlock:^{
            // hide alert after delay
           // double delayInSeconds = 1.0;
           // dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                [weakSelf dismissViewControllerAnimated:YES completion:nil];
//            });
        }];
        // Subscribe to push notifications
        //
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        else{
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
        }
#else
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
#endif
    } errorBlock:^(QBResponse *response) {
        
        NSString *errorMessage = [[response.error description] stringByReplacingOccurrencesOfString:@"(" withString:@""];
        errorMessage = [errorMessage stringByReplacingOccurrencesOfString:@")" withString:@""];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors"
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        [alert show];
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"New Push received\n: %@", userInfo);
}



@end
