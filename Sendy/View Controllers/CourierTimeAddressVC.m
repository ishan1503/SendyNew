//
//  CourierTimeAddressVC.m
//  Sendy
//
//  Created by Ishan Shikha on 23/04/16.
//  Copyright © 2016 Ishan Gupta. All rights reserved.
//

#import "CourierTimeAddressVC.h"

@interface CourierTimeAddressVC ()

@end

@implementation CourierTimeAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.isOpenForOnDemand)
    {
        height.constant=90;
        myTripView.hidden=YES;
    }
    else
    {
         height.constant=186;
         myTripView.hidden=NO;
    }
    searchJobButton.layer.borderColor=[UIColor colorWithRed:41.0/265.0f green:168.0/265.0f blue:147.0/265.0f alpha:1.0].CGColor;
    searchJobButton.layer.cornerRadius=searchJobButton.frame.size.height/2.0;
    searchJobButton.layer.borderWidth=2.0;

    [self addTopBorderWithColor:[UIColor lightGrayColor] andWidth:1.0];
    [self addBottomBorderWithColor:[UIColor lightGrayColor] andWidth:1.0];
    // Do any additional setup after loading the view.
}
- (void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    UIView *border = [UIView new];
    border.backgroundColor = color;
    [border setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    border.frame = CGRectMake(0, 0, myTripView.frame.size.width, borderWidth);
    [myTripView addSubview:border];
}

- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    UIView *border = [UIView new];
    border.backgroundColor = color;
    [border setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    border.frame = CGRectMake(0, myTripView.frame.size.height - borderWidth, myTripView.frame.size.width, borderWidth);
    [myTripView addSubview:border];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-Back Button Action
-(IBAction)backButtonPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)searchJobs:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:App_Name message:@"Under Development" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
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
