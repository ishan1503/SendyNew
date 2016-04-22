//
//  AppHelper.m
//  Infinea
//
//  Created by Ritu Dalal on 6/26/14.
//  Copyright (c) 2014 Ritu Dalal. All rights reserved.
//

#import "AppHelper.h"
#import <UIKit/UIKit.h>
@implementation AppHelper

+(void)saveToUserDefaults:(id)value withKey:(NSString*)key
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults) {
		[standardUserDefaults setObject:value forKey:key];
		[standardUserDefaults synchronize];
	}
}

+(NSString*)userDefaultsForKey:(NSString*)key
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSString *val = nil;
    
	if (standardUserDefaults)
		val = [standardUserDefaults objectForKey:key];
	
	return val;
}
+(NSArray*)userDefaultsForArray:(NSString*)key
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSArray *val = nil;
	
	if (standardUserDefaults)
		val = [standardUserDefaults objectForKey:key];
	
	return val;
}
+(void)removeFromUserDefaultsWithKey:(NSString*)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    [standardUserDefaults removeObjectForKey:key];
    [standardUserDefaults synchronize];
}


+ (void) showAlertViewWithTag:(NSInteger)tag title:(NSString*)title message:(NSString*)msg delegate:(id)delegate cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles
{
    if(CbtnTitle !=nil)
    {
        if([CbtnTitle isEqualToString:@"No"])
        {
            CbtnTitle=NSLocalizedStringFromTable(@"No", [AppHelper getCurrentLanguage], nil);
        }
        else if([CbtnTitle isEqualToString:@"Yes"])
        {
            CbtnTitle=NSLocalizedStringFromTable(@"Yes", [AppHelper getCurrentLanguage], nil);
        }
    }
    if(otherBtnTitles !=nil)
    {
        if([otherBtnTitles isEqualToString:@"OK"])
        {
            otherBtnTitles=NSLocalizedStringFromTable(@"OK", [AppHelper getCurrentLanguage], nil);
        }
        else if([otherBtnTitles isEqualToString:@"No"])
        {
            otherBtnTitles=NSLocalizedStringFromTable(@"No", [AppHelper getCurrentLanguage], nil);
        }
        else if([otherBtnTitles isEqualToString:@"Yes"])
        {
            otherBtnTitles=NSLocalizedStringFromTable(@"Yes", [AppHelper getCurrentLanguage], nil);
        }
    }
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate
                                          cancelButtonTitle:CbtnTitle otherButtonTitles:otherBtnTitles, nil];
    alert.tag = tag;
	[alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];;

}



+ (NSString *)getCurrentLanguage
{
	//NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	//NSString *lag = [defaults objectForKey:@"Language"];
    
    return @"English";
    
    //    if ([lag isEqualToString:@"Deutsch"])
    //    {
    //        return @"German1";
    //    }else if ([lag isEqualToString:@"English"])
    //    {
    //        return @"Eng";
    //
    //    }else if ([lag isEqualToString:@"français"])
    //    {
    //
    //        return @"french";
    //    }else if ([lag isEqualToString:@"español"])
    //    {
    //        return @"Spanish";
    //
    //    }else if ([lag isEqualToString:@"italiano"])
    //    {
    //
    //        return @"Italian";
    //    }else if ([lag isEqualToString:@"català"])
    //    {
    //        return @"catalan";
    //
    //    }else if ([lag isEqualToString:@"Nederlands"])
    //    {
    //
    //        return @"Dutch";
    //    }else if ([lag isEqualToString:@"עברית"])
    //    {
    //        return @"Hebrew";
    //
    //    }else if ([lag isEqualToString:@"português"])
    //    {
    //
    //        return @"Portuguese";
    //    }else if ([lag isEqualToString:@"日本人"])
    //    {
    //        return @"Japanese";
    //
    //    }else if ([lag isEqualToString:@"中国的"])
    //    {
    //
    //        return @"Chinese";
    //    }else if ([lag isEqualToString:@"русский"])
    //    {
    //        return @"Russian";
    //
    //    }else if ([lag isEqualToString:@"Türk"])
    //    {
    //        
    //        return @"Turkish";
    //    }else if ([lag isEqualToString:@"العربية"])
    //    {
    //        return @"Arabic";
    //    }
    
}
+(NSString *)getUTCFormateDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    return dateString;
}

+(NSDate *)convertdate :(NSString *)date andtime:(NSString *)time
{
    NSString *dateAndTime = [NSString stringWithFormat:@"%@ %@",date,time];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] ];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //[dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate   *aDate = [dateFormatter dateFromString:dateAndTime];
    return aDate;
}

+ (BOOL)archive:(NSDictionary *)dict withKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = nil;
    if (dict) {
        data = [NSKeyedArchiver archivedDataWithRootObject:dict];
    }
    [defaults setObject:data forKey:key];
    return [defaults synchronize];
}

+ (NSDictionary *)unarchiveForKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:key];
    NSDictionary *userDict = nil;
    if (data) {
        userDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return userDict;
}

@end
