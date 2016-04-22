//
//  ForgotPasswordVC.m
//  Sendy
//
//  Created by Ishan Shikha on 21/06/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "ForgotPasswordVC.h"

@interface ForgotPasswordVC ()
{
    IBOutlet UITextField *emailTextField;
}
@end

@implementation ForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    emailTextField.returnKeyType=UIReturnKeySend;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES ];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [emailTextField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self forgetpassword:nil];
    return YES;
}

- (IBAction)forgetpassword:(id)sender
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL myStringMatchesRegEx=[emailTest evaluateWithObject: emailTextField.text];
    if(emailTextField.text.length==0)
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Email should not be blank" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
    else if (!myStringMatchesRegEx)
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Invalid email" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
    }
    else
    {
        if([AppDelegate getAppDelegate].isNetworkReachable)
        {
            NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:emailTextField.text,@"email",nil];
            [[ServiceClass sharedServiceClass] forgotPasswordMethod:dict];
        }
        else
        {
            [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Please check your intenet connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        }
        
    }
    [emailTextField resignFirstResponder];
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
