//
//  AppDelegate.h
//  Sendy
//
//  Created by Ishan Shikha on 22/05/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GooglePlus/GooglePlus.h>
#import "NMBottomTabBarController.h"
@class GTMOAuth2Authentication;

@interface AppDelegate : UIResponder <UIApplicationDelegate,NMBottomTabBarControllerDelegate>
{
    UIView *activityView1;
    
}
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,assign)BOOL isNetworkReachable;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (strong, nonatomic) NSMutableArray *labelArray;
@property (strong, nonatomic) NSMutableDictionary *senderDeliverydata;
@property (strong,nonatomic) NSString *ismodifyjob;

@property (strong,nonatomic) UINavigationController *myactivityNavigation;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;




+(AppDelegate *)getAppDelegate;
-(void)showLoadingView:(NSString*)msg;
-(void)hideLoadingView;
-(CGFloat)widthOfDevice;
-(CGFloat)heightOfDevice;
-(void)addTabbar;
-(void)createQuickBloxSession;

@end

