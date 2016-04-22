//
//  ServiceClass.h
//  Infinea
//
//  Created by Ritu Dalal on 6/27/14.
//  Copyright (c) 2014 Ritu Dalal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ServiceClass : NSObject<UIAlertViewDelegate>

+(ServiceClass *) sharedServiceClass;

-(void)signupWithDictionary:(NSDictionary *)dictionary;
-(void)verifyOTP:(NSDictionary *)dictionary;
-(void)resendOTPOfUser:(NSDictionary *)dictionary;
-(void)profileSetupWithDictionary:(NSDictionary *)dictionary WihImageUrl:(UIImage *)userimage isForUpdate:(BOOL)update;
-(void)loginUser:(NSDictionary *)dictionary;
-(void)forgotPasswordMethod:(NSDictionary *)dictionary;
-(void)changePasswordMethod:(NSDictionary *)dictionary;
-(void)checkUserMethod:(NSDictionary *)dictionary;
-(void)createTripWithDictionary:(NSDictionary *)dictionary;
-(void)findTripWithDictionary:(NSDictionary *)dictionary;
-(void)awardTripWithDictionary:(NSDictionary *)dictionary;
-(void)getMyTrip;
-(void)getMyDeliveries;
-(void)cancelTripWithDictionary:(NSDictionary *)dictionary;
-(void)cancelItemWithDictionary:(NSDictionary *)dictionary;

-(void)editTripWithDictionary:(NSDictionary *)dictionary;
-(void)initialSetupWithDictionary:(NSDictionary *)dictionary;
-(void)createItemDictionary:(NSDictionary *)dictionary;
-(void)editItemDictionary:(NSDictionary *)dictionary;
-(void)updateProfileWithDictionary:(NSMutableDictionary *)dictionary WihImageUrl:(UIImage *)userimage;
-(void)findSenderNearByYouWithDictionary:(NSMutableDictionary *)dictionary;
-(void)postBidWithDictionary:(NSMutableDictionary *)dictionary;
-(void)fetchDelivererTripWithDictionary:(NSMutableDictionary *)dictionary;
-(void)getCurrentOffersWithDictionary:(NSMutableDictionary *)dictionary;
-(void)awardJobWithDictionary:(NSMutableDictionary *)dictionary;
-(void)awardeAsSenderWithDictionary:(NSMutableDictionary *)dictionary;
-(void)awardeAsDelivererWithDictionary:(NSMutableDictionary *)dictionary;
-(void)completedAsSenderWithDictionary:(NSMutableDictionary *)dictionary;
-(void)completedAsDelivererWithDictionary:(NSMutableDictionary *)dictionary;
-(void)bidsAsDelivererWithDictionary:(NSMutableDictionary *)dictionary;
-(void)activityPressed:(NSMutableDictionary *)dictionary andMethodName:(NSString *)methodName;

-(void)postdeliverysender:(NSMutableDictionary *)dictionary;
-(void)getPostedjobListing:(NSDictionary *)dictionary;
-(void)deletepost:(NSMutableDictionary *)dictionary;
-(void)modifyPost:(NSMutableDictionary *)dictionary;

@end
