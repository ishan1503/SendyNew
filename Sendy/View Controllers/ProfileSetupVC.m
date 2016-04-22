//
//  ProfileSetupVC.m
//  Sendy
//
//  Created by Ishan Shikha on 01/06/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "ProfileSetupVC.h"
#import "TLTagsControl.h"
#import "LocationVC.h"
#import "VerifyOTPVC.h"
#import "ProfileSetupCell.h"
#import "ChatService.h"


@interface ProfileSetupVC ()
{
    __weak IBOutlet UIImageView *profilePic;
    NSMutableArray *labelArray;
    IBOutlet UITableView *profileSetupTableview;
    IBOutlet UIView *headerView;
    UITextField *firstNameTextField;
    UITextField *lastNameTextField;
    UITextField *emailTextField;
    UITextField *phoneNumberTextField;
    UITextField *passwordTextField;
    UITextField *countryCodeTextField;
    UITextField *nextTextfield;
    NSString *firstName;
    NSString *secondName;
    NSString *email;
    NSString *phone;
    NSString *password;
    NSString *countryCode;
    
    
    IBOutlet NSLayoutConstraint *height;
    
    IBOutlet UIButton *saveButton;
    IBOutlet UILabel *infoLabel;
    
    BOOL imageSetupComplete;
    
    UITextField *nextTextField;
    CountryPicker *countryCodePicker;
}
@end

@implementation ProfileSetupVC
//@synthesize address;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view bringSubviewToFront:headerView];
    
    labelArray=[[NSMutableArray alloc] initWithCapacity:5];
    countryCodePicker=[[CountryPicker alloc] init];
    countryCodePicker.delegate=self;
    if(self.isComingtoEdit)
    {
        imageSetupComplete=YES;
        self.headerLabel.text=@"My Profile";
        firstName=[[AppHelper unarchiveForKey:@"UserInfo"] objectForKey:@"firstName"];
        secondName=[[AppHelper unarchiveForKey:@"UserInfo"] objectForKey:@"lastName"];
        email=[[AppHelper unarchiveForKey:@"UserInfo"] objectForKey:@"email"];
        countryCode=[[AppHelper unarchiveForKey:@"UserInfo"] objectForKey:@"countryCode"];
        phone=[[AppHelper unarchiveForKey:@"UserInfo"] objectForKey:@"mobile"];
        infoLabel.hidden=YES;
        [saveButton setImage:[UIImage imageNamed:@"submit.png"] forState:UIControlStateNormal];
        [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.5];
    }
    [labelArray addObject:@"First Name"];
    [labelArray addObject:@"Last Name"];
    [labelArray addObject:@"Email"];
    [labelArray addObject:@"Mobile Number"];
    if(!self.isComingtoEdit)
        [labelArray addObject:@"Password"];
    
    profilePic.layer.cornerRadius =50.0;
    profilePic.clipsToBounds = YES;
    profilePic.layer.borderWidth = 2.0f;
    profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGesture];
    
    if(_socailUserInfo)
    {
        NSURL *pictureURL;
        if([AppHelper userDefaultsForKey:@"FBUserInfo"])
            pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", [_socailUserInfo objectForKey:@"id"]]];
        else if ([AppHelper userDefaultsForKey:@"G+UserInfo"])
            pictureURL = [NSURL URLWithString:[_socailUserInfo objectForKey:@"picture"]];

        [profilePic setImageWithURLRequest:[NSURLRequest requestWithURL:pictureURL] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                profilePic.image=image;
                imageSetupComplete=YES;
            });
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
        
        [profileSetupTableview reloadData];
    }
    if(!IS_IPHONE_4_OR_LESS)
    {
        height.constant=-511;
    }
    if(self.isComingtoEdit)
    {
        [profilePic setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[AppHelper unarchiveForKey:@"UserInfo"] objectForKey:@"image_url"]]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                profilePic.image=image;
            });
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
    }
    // Do any additional setup after loading the view.
}

-(void)reloadTable
{
    [profileSetupTableview reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{

}

#pragma mark-ProfilePic Button Action
-(IBAction)AddPhoto:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:App_Name delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Take Photo",@"Select From Gallery",nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:picker animated:YES completion:NULL];
            }
            else
            {
                [AppHelper showAlertViewWithTag:101 title:App_Name message:@"This device does not have a camera." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            }
        }
            break;
        case 1:
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:NULL];
        }
            break;
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    profilePic.image= chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    imageSetupComplete=YES;
    
}

#pragma mark-Gesture Delegates and Selectors
-(void)handleTap:(UITapGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
    [self resetTableViewDown];
}

#pragma mark-Tablview Delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return labelArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 38.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PofileSetupCell";
    
    ProfileSetupCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    UILabel *leftLabel = (UILabel *)[cell viewWithTag:101];
    leftLabel.text=[labelArray objectAtIndex:indexPath.row];
    cell.differnce.constant=31;
        if (indexPath.row==0)
        {
            firstNameTextField=(UITextField *)[cell viewWithTag:102];
            firstNameTextField.hidden=NO;
            firstNameTextField.userInteractionEnabled=YES;
            firstNameTextField.placeholder=@"Enter First Name";
            [cell viewWithTag:103].hidden=YES;
            if(firstName.length>0)
                firstNameTextField.text=firstName;
            if([AppHelper userDefaultsForKey:@"G+UserInfo"])
                firstNameTextField.text=[_socailUserInfo objectForKey:@"given_name"];
            else if([AppHelper userDefaultsForKey:@"FBUserInfo"])
                firstNameTextField.text=[_socailUserInfo objectForKey:@"first_name"];
            else if([AppHelper userDefaultsForKey:@"LiUserInfo"])
                firstNameTextField.text=[_socailUserInfo objectForKey:@"firstName"];
//            if([self assignKeyTypeNext:firstNameTextField])
//                firstNameTextField.returnKeyType=UIReturnKeyNext;
        }
        else if (indexPath.row==1)
        {
            lastNameTextField=(UITextField *)[cell viewWithTag:102];
            lastNameTextField.hidden=NO;
            lastNameTextField.userInteractionEnabled=YES;
            lastNameTextField.placeholder=@"Enter Last Name";
            [cell viewWithTag:103].hidden=YES;

            if(secondName.length>0)
                lastNameTextField.text=secondName;
            if([AppHelper userDefaultsForKey:@"G+UserInfo"])
                lastNameTextField.text=[_socailUserInfo objectForKey:@"family_name"];
            else if([AppHelper userDefaultsForKey:@"FBUserInfo"])
                lastNameTextField.text=[_socailUserInfo objectForKey:@"last_name"];
            else if([AppHelper userDefaultsForKey:@"LiUserInfo"])
                lastNameTextField.text=[_socailUserInfo objectForKey:@"lastName"];
            
//            if([self assignKeyTypeNext:lastNameTextField])
//                lastNameTextField.returnKeyType=UIReturnKeyNext;

        }
        else if (indexPath.row==2)
        {
            emailTextField=(UITextField *)[cell viewWithTag:102];
            emailTextField.hidden=NO;
            emailTextField.userInteractionEnabled=YES;
            emailTextField.placeholder=@"Enter Email";
            emailTextField.keyboardType=UIKeyboardTypeEmailAddress;
            cell.differnce.constant=-10;
            if(email.length>0)
                emailTextField.text=email;
            else if([AppHelper userDefaultsForKey:@"FBUserInfo"])
                emailTextField.text=[_socailUserInfo objectForKey:@"email"];            
            [cell viewWithTag:103].hidden=YES;
            
//            if([self assignKeyTypeNext:emailTextField])
//                emailTextField.returnKeyType=UIReturnKeyNext;

            
        }
        else if (indexPath.row==3)
        {
            phoneNumberTextField=(UITextField *)[cell viewWithTag:102];
            phoneNumberTextField.hidden=NO;
            phoneNumberTextField.userInteractionEnabled=YES;
            phoneNumberTextField.placeholder=@"Enter Phone Number";
            phoneNumberTextField.keyboardType=UIKeyboardTypeNumberPad;
            if(phone.length>0)
                phoneNumberTextField.text=phone;
            
//            if([self assignKeyTypeNext:phoneNumberTextField])
//                phoneNumberTextField.returnKeyType=UIReturnKeyNext;

            
            countryCodeTextField=(UITextField *)[cell viewWithTag:103];
            countryCodeTextField.hidden=NO;
            countryCodeTextField.inputView=countryCodePicker;
            //countryCodeTextField.keyboardType=UIKeyboardTypePhonePad;
            if(countryCode.length>0)
                countryCodeTextField.text=countryCode;
            
//            if([self assignKeyTypeNext:countryCodeTextField])
//                countryCodeTextField.returnKeyType=UIReturnKeyNext;

        }
        else if (indexPath.row==4)
        {
            passwordTextField=(UITextField *)[cell viewWithTag:102];
            passwordTextField.hidden=NO;
            passwordTextField.userInteractionEnabled=YES;
            passwordTextField.placeholder=@"Enter Password";
            passwordTextField.secureTextEntry=YES;
            if(password.length>0)
                passwordTextField.text=password;
            [cell viewWithTag:103].hidden=YES;
        }

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)countryPicker:(__unused CountryPicker *)picker didSelectCountryWithName:(NSString *)name code:(NSString *)code
{
    if([[[CountryPicker getCountryCode:code] objectAtIndex:1] length]>0)
        countryCodeTextField.text = [@"+" stringByAppendingString:[[CountryPicker getCountryCode:code] objectAtIndex:1]];
}
#pragma mark-TextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    NSMutableArray *arr;
        if(self.isComingtoEdit)
            arr=[NSMutableArray arrayWithObjects:firstNameTextField,lastNameTextField,emailTextField,phoneNumberTextField,countryCodeTextField, nil];
        else
            arr=[NSMutableArray arrayWithObjects:firstNameTextField,lastNameTextField,emailTextField,phoneNumberTextField,passwordTextField,countryCodeTextField, nil];
    if([arr lastObject]==textField)
        textField.returnKeyType=UIReturnKeyDone;
    else
        textField.returnKeyType=UIReturnKeyNext;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    UITableViewCell *cell=(UITableViewCell *)[[textField superview] superview];
    
    if(self.isComingtoEdit)
    {
        if([profileSetupTableview indexPathForCell:cell].row==0)
            firstName=textField.text;
        else if ([profileSetupTableview indexPathForCell:cell].row==1)
            secondName=textField.text;
        else if ([profileSetupTableview indexPathForCell:cell].row==2)
            email=textField.text;
        else if ([profileSetupTableview indexPathForCell:cell].row==3&&textField.tag==102)
            phone=textField.text;
        else if ([profileSetupTableview indexPathForCell:cell].row==3&&textField.tag==103)
            countryCode=textField.text;
        else if ([profileSetupTableview indexPathForCell:cell].row==4)
            password=textField.text;
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==phoneNumberTextField&&[[textField.text stringByAppendingString:string] length]>10)
        return NO;
    if(textField==firstNameTextField || textField == lastNameTextField)
    {
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
            {
                return NO;
            }
        }
        
        return YES;
    }
    
    return YES;
}
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UITableViewCell *cell=(UITableViewCell *)[[textField superview] superview];
    NSIndexPath *indexPath=[profileSetupTableview indexPathForCell:cell];
    [self resetTableViewDown];
    if(IS_IPHONE_4_OR_LESS && indexPath.row>0)
    {
        [profileSetupTableview setContentOffset:CGPointMake(profileSetupTableview.frame.origin.x,35*indexPath.row) animated:YES];
    }
    else if(IS_IPHONE_5 && indexPath.row>2)
    {
        [profileSetupTableview setContentOffset:CGPointMake(profileSetupTableview.frame.origin.x,35*indexPath.row) animated:YES];

    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    NSMutableArray *arr;
    if(self.isComingtoEdit)
        arr=[NSMutableArray arrayWithObjects:firstNameTextField,lastNameTextField,emailTextField,phoneNumberTextField,countryCodeTextField, nil];
    else
        arr=[NSMutableArray arrayWithObjects:firstNameTextField,lastNameTextField,emailTextField,phoneNumberTextField,passwordTextField,countryCodeTextField, nil];
    if(textField.returnKeyType==UIReturnKeyNext)
    {
        nextTextField=[arr objectAtIndex:[arr indexOfObject:textField]+1];
        [nextTextField becomeFirstResponder];
        if(IS_IPHONE_4_OR_LESS && [arr indexOfObject:textField]>0)
        {
            [profileSetupTableview setContentOffset:CGPointMake(profileSetupTableview.frame.origin.x,35*[arr indexOfObject:textField]) animated:YES];
        }
        else if(IS_IPHONE_5 && [arr indexOfObject:textField]>2)
        {
            [profileSetupTableview setContentOffset:CGPointMake(profileSetupTableview.frame.origin.x,35*[arr indexOfObject:textField]) animated:YES];
        }
        if(nextTextField==[arr lastObject])
            nextTextField.returnKeyType=UIReturnKeyDone;
        else
            nextTextField.returnKeyType=UIReturnKeyNext;
    }
    else
        [textField resignFirstResponder];
    
    [self resetTableViewDown];
    return YES;
}
#pragma Reset Table View Down
-(void)resetTableViewDown
{
    [profileSetupTableview setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark-Save Button Action
-(IBAction)saveButtonAction:(id)sender
{
    [self setupProfileatRegistrationTime];
}
-(void)setupProfileatRegistrationTime
{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL myStringMatchesRegEx2=[emailTest evaluateWithObject:emailTextField.text];
    
    if(!imageSetupComplete)
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Please set your profile picture." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];

    }
    else if(firstNameTextField.text.length==0)
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"First name should note be blank." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
    else if (lastNameTextField.text.length==0)
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Last name should note be blank." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
    else if (emailTextField.text.length==0)
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Email should note be blank." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
    else if(!myStringMatchesRegEx2)
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Invalid Email" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        return;
    }
    else if (phoneNumberTextField.text.length==0)
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Phone Number should note be blank." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
    else if (countryCodeTextField.text.length==0)
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Country code should note be blank." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }

    else if (passwordTextField.text.length==0&&!self.isComingtoEdit)
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Password should note be blank." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
    else if (passwordTextField.text.length<5&&!self.isComingtoEdit)
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Password should be greater than 5 characters." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
    else
    {
        if([AppDelegate getAppDelegate].isNetworkReachable)
        {
            NSString *socialid=@"";
            NSString *socialType=@"";

            if(_socailUserInfo && !self.isComingtoEdit)
            {
                if([AppHelper userDefaultsForKey:@"FBUserInfo"])
                {
                    socialid=[_socailUserInfo objectForKey:@"id"];
                    socialType=@"fb";
                }
                else if([AppHelper userDefaultsForKey:@"G+UserInfo"])
                {
                    socialid=[_socailUserInfo objectForKey:@"sub"];
                    socialType=@"gp";
                }
                else if([AppHelper userDefaultsForKey:@"LiUserInfo"])
                {
                    socialid=[_socailUserInfo objectForKey:@"id"];
                    socialType=@"ln";
                }
            }
            [[AppDelegate getAppDelegate] showLoadingView:@"Please Wait..."];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileSetupResponse:) name:Profile_Setup__Notification_Rvcd object:nil];
            
            NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
            [paramDict setObject:firstNameTextField.text forKey:parm_firstName];
            [paramDict setObject:lastNameTextField.text forKey:parm_lastName];
            [paramDict setObject:phoneNumberTextField.text forKey:parm_mobile];
            [paramDict setObject:countryCodeTextField.text forKey:parm_countryCode];
            if(self.isComingtoEdit)
            {
                [paramDict setObject:UserID forKey:@"userId"];
                [[ServiceClass sharedServiceClass] updateProfileWithDictionary:paramDict WihImageUrl:[self imageWithImage:profilePic.image scaledToSize:CGSizeMake(140, 140)]];
            }
            else
            {
                [paramDict setObject:emailTextField.text forKey:parm_email];
                [paramDict setObject:passwordTextField.text forKey:parm_password];
                [paramDict setObject:socialid forKey:parm_socialId];
                [paramDict setObject:socialType forKey:parm_socialType];
                [paramDict setObject:@"we" forKey:parm_deviceId];
                [paramDict setObject:@"i" forKey:parm_deviceType];

                [[ServiceClass sharedServiceClass] profileSetupWithDictionary:paramDict WihImageUrl:[self imageWithImage:profilePic.image scaledToSize:CGSizeMake(140, 140)]  isForUpdate:NO];
            }
        }
        else
        {
            [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Please check your intenet connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        }
        
    }
}
-(void)profileSetupResponse:(NSNotification *)notif
{
//    countryCode = 91;
//    email = "sdfasd@gnaj.com";
//    firstName = tghsagj;
//    "image_url" = "http://52.89.119.20/assets/uploads/users/profimg/1450894705.png";
//    isVerified = 0;
//    lastName = dsfasf;
//    mobile = 9654838987;
//    profileImage = "1450894705.png";
//    qid = 7809910;
//    socialId = "";
//    socialType = "";
//    userId = 22;
    
    if(!self.isComingtoEdit)
    {
        NSDictionary *dict=(NSDictionary *)notif.object;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:Profile_Setup__Notification_Rvcd object:nil];
        if([dict count]>0)
        {
            [AppHelper archive:dict withKey:@"UserInfo"];
            //[[AppDelegate getAppDelegate]createQuickBloxSession];
            [[AppDelegate getAppDelegate] hideLoadingView];
            [self performSegueWithIdentifier:@"showVerifyScreen" sender:nil];
        }
    }
    else
    {
        NSDictionary *dict=(NSDictionary *)notif.object;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:Profile_Setup__Notification_Rvcd object:nil];
        if([dict count]>0)
        {
            [AppHelper archive:dict withKey:@"UserInfo"];
            [profileSetupTableview reloadData];
        }
        [AppHelper showAlertViewWithTag:1234 title:App_Name message:@"Profile Updated" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showVerifyScreen"])
    {
        [(VerifyOTPVC *)segue.destinationViewController setMobileNumber:[countryCodeTextField.text stringByAppendingString:phoneNumberTextField.text]];
        [(VerifyOTPVC *)segue.destinationViewController setEmailID:emailTextField.text];

    }
}
#pragma mark-AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1234)
    {
        [self backButtonPressed:nil];
    }
}
#pragma mark-Back Button
-(IBAction)backButtonPressed:(id)sender
{
    [AppHelper removeFromUserDefaultsWithKey:@"FBUserInfo"];
    [AppHelper removeFromUserDefaultsWithKey:@"LiUserInfo"];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
