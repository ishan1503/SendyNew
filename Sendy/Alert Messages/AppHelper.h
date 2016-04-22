//
//  AppHelper.h
//  Infinea
//
//  Created by Ritu Dalal on 6/26/14.
//  Copyright (c) 2014 Ritu Dalal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppHelper : NSObject
+ (void)showAlertViewWithTag:(NSInteger)tag title:(NSString*)title message:(NSString*)msg delegate:(id)delegate
            cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles;
+ (NSString *)getCurrentLanguage;
+(void)saveToUserDefaults:(id)value withKey:(NSString*)key;
+(NSString*)userDefaultsForKey:(NSString*)key;
+(NSArray*)userDefaultsForArray:(NSString*)key;
+(void)removeFromUserDefaultsWithKey:(NSString*)key;
+(NSString *)getUTCFormateDate:(NSDate *)localDate;
+(NSDate *)convertdate :(NSString *)date andtime:(NSString *)time;
+ (BOOL)archive:(NSDictionary *)dict withKey:(NSString *)key;
+ (NSDictionary *)unarchiveForKey:(NSString *)key;
@end
