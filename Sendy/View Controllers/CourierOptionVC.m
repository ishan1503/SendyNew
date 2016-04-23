//
//  CourierOptionVC.m
//  Sendy
//
//  Created by Ishan Shikha on 23/04/16.
//  Copyright © 2016 Ishan Gupta. All rights reserved.
//

#import "CourierOptionVC.h"
#import "CourierTimeAddressVC.h"
#import "create_send_item_2.h"
@interface CourierOptionVC ()
{
    IBOutlet UIButton *onDemandButton;
    IBOutlet UIButton *onExistingTrips;
}
@end

@implementation CourierOptionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    onDemandButton.layer.borderColor=[UIColor colorWithRed:41.0/265.0f green:168.0/265.0f blue:147.0/265.0f alpha:1.0].CGColor;
    onExistingTrips.layer.borderColor=[UIColor colorWithRed:41.0/265.0f green:168.0/265.0f blue:147.0/265.0f alpha:1.0].CGColor;
    
    onDemandButton.layer.cornerRadius=onDemandButton.frame.size.height;
    onExistingTrips.layer.cornerRadius=onExistingTrips.frame.size.height;

    
    onDemandButton.layer.borderWidth=2.0;
    onExistingTrips.layer.borderWidth=2.0;

    // Do any additional setup after loading the view.
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

-(IBAction)pushOnStepTwo:(id)sender
{
[self performSegueWithIdentifier:@"PushOnStep" sender:sender];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if((UIButton *)sender==onDemandButton)
        [(CourierTimeAddressVC *) segue.destinationViewController setIsOpenForOnDemand:YES];
    else
        [(CourierTimeAddressVC *) segue.destinationViewController setIsOpenForOnDemand:NO];

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
