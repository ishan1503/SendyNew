//
//  ChangePasswordVC.m
//  Sendy
//
//  Created by Ishan Shikha on 04/07/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "ChangePasswordVC.h"

@interface ChangePasswordVC ()
{
    IBOutlet UITextField *oldPassword;
    IBOutlet UITextField *newPassword;
    IBOutlet UITextField *confirmNewPassword;
}
@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [oldPassword becomeFirstResponder];
    oldPassword.returnKeyType=UIReturnKeyNext;
    newPassword.returnKeyType=UIReturnKeyNext;
    confirmNewPassword.returnKeyType=UIReturnKeyGo;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-BackButton
-(IBAction)backButtonPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-Textfield Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    if(textField==oldPassword)
        [newPassword becomeFirstResponder];
    else if (textField==newPassword)
        [confirmNewPassword becomeFirstResponder];
    else
    {
        if([oldPassword.text length]==0)
            [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Old Password should not be blank." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else if([oldPassword.text length]<5)
            [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Old Password should not be less than 5 characters." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else if([newPassword.text length]==0)
            [AppHelper showAlertViewWithTag:101 title:App_Name message:@"New Password should not be blank." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else if([newPassword.text length]<5)
            [AppHelper showAlertViewWithTag:101 title:App_Name message:@"New Password should not be less than 5 characters." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else if([confirmNewPassword.text length]==0)
            [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Confirm New Password should not be blank." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else if([confirmNewPassword.text length]<5)
            [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Confirm New Password should not be less than 5 characters." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else if(![newPassword.text isEqualToString:confirmNewPassword.text])
            [AppHelper showAlertViewWithTag:10101 title:App_Name message:@"New Passowrd and Confirm Password should be same." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else
            [[ServiceClass sharedServiceClass] changePasswordMethod:[NSDictionary dictionaryWithObjectsAndKeys:oldPassword.text,@"oldPassword",newPassword.text,@"newPassword",UserID,@"userId",nil]];
    }
    return YES;
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
