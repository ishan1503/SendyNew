//
//  ViewController.m
//  Sendy
//
//  Created by Ishan Shikha on 22/05/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "TutorialScreenVC.h"
#import "VerifyOTPVC.h"
#import "ProfileSetupVC.h"
@interface TutorialScreenVC ()
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIPageControl *pageControl;

}
@end

@implementation TutorialScreenVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.headerView.hidden=YES;
    for (int i=0; i<=3; i++)
    {
        scrollView.frame=CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y,SCREEN_WIDTH, 140.0);
        pageControl.frame=CGRectMake(SCREEN_WIDTH-39/2, 125, 39, 37);
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(i*scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, scrollView.frame.size.width, 21)];
        label.text=@"WELCOME TO SENDY";
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont boldSystemFontOfSize:17.0];
        label.textColor=[UIColor whiteColor];
        
        UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(0, label.frame.origin.y+32, scrollView.frame.size.width, 80)];
        label2.numberOfLines=4;
        label2.text=@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua";
        label2.backgroundColor=[UIColor clearColor];
        label2.textAlignment=NSTextAlignmentCenter;
        label2.font=[UIFont systemFontOfSize:16.0];
        label2.textColor=[UIColor whiteColor];
        

        [view addSubview:label];
        [view addSubview:label2];
        [scrollView addSubview:view];
    }
    scrollView.contentSize=CGSizeMake(scrollView.frame.size.width*4, scrollView.frame.size.height);
    scrollView.pagingEnabled=YES;
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *dict=(NSDictionary *)[AppHelper unarchiveForKey:@"ParamForLocalDelivery"];
    if([UserID length]>0&&[isVerified intValue]==0)
    {
        [self performSegueWithIdentifier:@"VerifyOTP" sender:nil];
    }
    else if (([UserID length]>0&&[isVerified intValue]==1&&[dict count]==0))
        [self performSegueWithIdentifier:@"InitialSetup" sender:nil];
    else if([UserID length]>0&&[isVerified intValue]==1&&[dict count]>0)
        [[AppDelegate getAppDelegate] addTabbar];

}
- (IBAction)changePage:(id)sender {
    CGFloat x = pageControl.currentPage * scrollView.frame.size.width;
    [scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView  {
    NSInteger pageNumber = roundf(scrollView.contentOffset.x / (scrollView.frame.size.width));
    pageControl.currentPage = pageNumber;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"VerifyOTP"])
    {
        VerifyOTPVC *obj=segue.destinationViewController;
        obj.mobileNumber=[[[AppHelper unarchiveForKey:@"UserInfo"] objectForKey:@"countryCode"] stringByAppendingString:[[AppHelper unarchiveForKey:@"UserInfo"] objectForKey:@"mobile"]];
        obj.emailID=[[AppHelper unarchiveForKey:@"UserInfo"] objectForKey:@"email"];
    }
    else if([segue.identifier isEqualToString:@"Profile Setup"])
    {
        ProfileSetupVC *obj=segue.destinationViewController;
        if([AppHelper userDefaultsForKey:@"FBUserInfo"]!=nil)
            obj.socailUserInfo=(NSDictionary *)[AppHelper userDefaultsForKey:@"FBUserInfo"];
        else if([AppHelper userDefaultsForKey:@"G+UserInfo"]!=nil)
             obj.socailUserInfo=(NSDictionary *)[AppHelper userDefaultsForKey:@"G+UserInfo"];
        else if([AppHelper userDefaultsForKey:@"LiUserInfo"]!=nil)
            obj.socailUserInfo=(NSDictionary *)[AppHelper userDefaultsForKey:@"LiUserInfo"];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
