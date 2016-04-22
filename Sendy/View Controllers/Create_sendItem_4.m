//
//  Create_sendItem_4.m
//  Sendy
//
//  Created by Prankur on 16/03/16.
//  Copyright (c) 2016 Ishan Gupta. All rights reserved.
//

#import "Create_sendItem_4.h"
#import "ProfileSetupVC.h"

@interface Create_sendItem_4 ()
{
    IBOutlet UITableView *tableview_cr;
    
    NSIndexPath *selectedindex;
}

@end

@implementation Create_sendItem_4

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", [AppDelegate getAppDelegate].senderDeliverydata);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:true];
}
- (IBAction)popenProfile:(id)sender
{
    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileSetupVC *profileSetupVC=[mainStoryBoard instantiateViewControllerWithIdentifier:@"ProfileSetupVC"];
    profileSetupVC.isComingtoEdit=YES;
    [self.navigationController showViewController:profileSetupVC sender:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"timwusercell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timwusercell"];
    }
    
    UILabel *sizename=(UILabel *)[cell.contentView viewWithTag:10];
    UILabel *sizedesc=(UILabel *)[cell.contentView viewWithTag:11];
    
    if (indexPath.row == 0)
    {
        sizename.text = @"Urgent";
        sizedesc.text = @"as soon as Possible";
    }
    else if (indexPath.row == 1)
    {
        sizename.text = @"Anytime today";
        sizedesc.text = @"it's Flexible";
    }
    if(selectedindex == indexPath)
    {
        sizename.textColor = [UIColor redColor];
    }
    else
    {
        sizename.textColor = [UIColor colorWithRed:64.0/255.0 green:187.0/255.0 blue:167.0/255.0 alpha:1.0];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    selectedindex = indexPath;
    [tableview_cr reloadData];
}

- (IBAction)nextAction:(id)sender
{
    if(selectedindex == nil)
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Please select service time" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        return;
        
    }
    if(selectedindex.row == 0)
    {
        [[AppDelegate getAppDelegate].senderDeliverydata setObject:@"U" forKey:@"service"];
    }
    else if(selectedindex.row == 1)
    {
        [[AppDelegate getAppDelegate].senderDeliverydata setObject:@"A" forKey:@"service"];
    }
    [[AppDelegate getAppDelegate].senderDeliverydata setObject:UserID forKey:@"userId"];

    NSLog(@"%@", [AppDelegate getAppDelegate].senderDeliverydata);

    if([[AppDelegate getAppDelegate].ismodifyjob  isEqual: @"modifydata"])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyitemResponse:) name:modify_postedjob_notification object:nil];
        [[ServiceClass sharedServiceClass] modifyPost:[AppDelegate getAppDelegate].senderDeliverydata];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createitemResponse:) name:create_item_notification object:nil];
        [[ServiceClass sharedServiceClass] postdeliverysender:[AppDelegate getAppDelegate].senderDeliverydata];
    }
}

-(void)createitemResponse:(NSNotification *)notif
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:create_item_notification object:nil];
    [AppHelper showAlertViewWithTag:101145 title:App_Name message:@"Item successfully created" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [[AppDelegate getAppDelegate].senderDeliverydata removeAllObjects];
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:self.navigationController.viewControllers.count-5] animated:true];
}

-(void)modifyitemResponse:(NSNotification *)notif
{
    [[NSNotificationCenter defaultCenter]removeObserver:modify_postedjob_notification];
    [[AppDelegate getAppDelegate].senderDeliverydata removeAllObjects];
    [AppDelegate getAppDelegate].ismodifyjob = @"createnewitem";
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:self.navigationController.viewControllers.count-5] animated:true];
}
@end
