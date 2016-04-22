//
//  howitwork1.m
//  Sendy
//
//  Created by Prankur on 05/03/16.
//  Copyright © 2016 Ishan Gupta. All rights reserved.
//

#import "howitwork1.h"

@interface howitwork1 ()

@end

@implementation howitwork1

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([UserID length]==0)
    {
        
    }
    else if([UserID length]>0&&[isVerified intValue]==0)
        [self performSegueWithIdentifier:@"VerifyOTP" sender:nil];
    else
        [[AppDelegate getAppDelegate] addTabbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
