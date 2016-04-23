//
//  MoreVC.m
//  Sendy
//
//  Created by Ishan Shikha on 29/06/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "MoreVC.h"
#import "ProfileSetupVC.h"
#import "SharingActivityProvider.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface MoreVC ()
{
    NSMutableArray *cellNameArray;
    NSMutableArray *iconNameArray;
}
@end

@implementation MoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    iconNameArray=[[NSMutableArray alloc] initWithObjects:@"profile",@"notification",@"password",@"terms",@"privacy",@"share",@"rate",@"logout", nil];
    cellNameArray=[[NSMutableArray alloc] initWithObjects:@"My Profile",@"Notifications",@"Change Password",@"Terms & Conditions",@"Privacy Policy",@"Share this App",@"Rate this App",@"Logout", nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellNameArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MoreCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MoreCell"];
    }
    UILabel *cellName=(UILabel *)[cell.contentView viewWithTag:1091];
    UIImageView *iconImage=(UIImageView *)[cell.contentView viewWithTag:98980];
    UIImageView *borderLine=(UIImageView *)[cell.contentView viewWithTag:98981];

    iconImage.image=[UIImage imageNamed:[iconNameArray objectAtIndex:indexPath.row]];
    cellName.text=[cellNameArray objectAtIndex:indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if(indexPath.row==cellNameArray.count-1)
        borderLine.hidden=YES;
    else
        borderLine.hidden=NO;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==cellNameArray.count-1)
    {
        [self logoutButton];
    }
    else if(indexPath.row==0)
    {
        UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProfileSetupVC *profileSetupVC=[mainStoryBoard instantiateViewControllerWithIdentifier:@"ProfileSetupVC"];
        profileSetupVC.isComingtoEdit=YES;
        [self.navigationController showViewController:profileSetupVC sender:nil];

    }
    else if(indexPath.row==2)
    {
        [self performSegueWithIdentifier:@"ChangePassword" sender:nil];
    }
    else if(indexPath.row==5)
    {
        SharingActivityProvider *sharingActivityProvider = [SharingActivityProvider alloc];
        UIImage *shareImage = [UIImage imageNamed:@"default"];
        NSURL *shareUrl = [NSURL URLWithString:@"http://google.com"];
        NSArray *activityProviders = @[sharingActivityProvider, shareImage, shareUrl];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityProviders applicationActivities:nil];
        // tell the activity view controller which activities should NOT appear
        activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
        // display the options for sharing
        activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
    else
        [AppHelper showAlertViewWithTag:10101 title:App_Name message:@"Under Development" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
}


#pragma mark-Logout Button
-(void)logoutButton
{
    FBSDKLoginManager *FBlogin = [[FBSDKLoginManager alloc] init];
    [FBlogin logOut];
    [AppHelper showAlertViewWithTag:10111 title:App_Name message:@"Do you want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes"];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==10111 && buttonIndex!=alertView.cancelButtonIndex)
    {
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        UINavigationController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"login_regNavigation"];
        [AppDelegate getAppDelegate].window.rootViewController=loginVC;
    }
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
