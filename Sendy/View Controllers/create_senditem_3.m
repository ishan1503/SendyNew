//
//  create_senditem_3.m
//  Sendy
//
//  Created by Prankur on 16/03/16.
//  Copyright (c) 2016 Ishan Gupta. All rights reserved.
//

#import "create_senditem_3.h"
#import "ProfileSetupVC.h"
#import "Create_sendItem_4.h"

@interface create_senditem_3 ()
{
    NSIndexPath *selectedindex;
}

@end

@implementation create_senditem_3
{
    IBOutlet UIButton*  postbtn;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([[AppDelegate getAppDelegate].senderDeliverydata[@"jobType"]  isEqual: @"local"])
    {
        [postbtn setImage:[UIImage imageNamed:@"nextbtn.png"] forState:UIControlStateNormal];
    }
    else
    {
        [postbtn setImage:[UIImage imageNamed:@"postjob.png"] forState:UIControlStateNormal];
    }
    NSLog(@"%@", [AppDelegate getAppDelegate].senderDeliverydata);
    
    if([[AppDelegate getAppDelegate].ismodifyjob  isEqual: @"modifydata"])
    {
        NSString* sizetype =  (NSString*)[[AppDelegate getAppDelegate].senderDeliverydata objectForKey:@"size"];
        if([sizetype  isEqual: @"XS"])
        {
            selectedindex = [NSIndexPath indexPathForRow:0 inSection:0];
        }
        else if ([sizetype  isEqual: @"S"])
        {
            selectedindex = [NSIndexPath indexPathForRow:1 inSection:0];
        }
        else if ([sizetype  isEqual: @"M"])
        {
            selectedindex = [NSIndexPath indexPathForRow:2 inSection:0];
        }
        else if ([sizetype  isEqual: @"L"])
        {
            selectedindex = [NSIndexPath indexPathForRow:3 inSection:0];
        }
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:true];

}
- (IBAction)openProfile:(id)sender
{
    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileSetupVC *profileSetupVC=[mainStoryBoard instantiateViewControllerWithIdentifier:@"ProfileSetupVC"];
    profileSetupVC.isComingtoEdit=YES;
    [self.navigationController showViewController:profileSetupVC sender:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"itemsizecell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"itemsizecell"];
    }

    UILabel *sizename=(UILabel *)[cell.contentView viewWithTag:10];
    UILabel *sizedesc=(UILabel *)[cell.contentView viewWithTag:11];
    UIImageView *itemimg=(UIImageView *)[cell.contentView viewWithTag:12];
    UIImageView *itemsizeimg=(UIImageView *)[cell.contentView viewWithTag:9];
    if([[AppDelegate getAppDelegate].ismodifyjob  isEqual: @"modifydata"])
    {
        if(selectedindex == indexPath)
        {
            cell.selectionStyle = true;
        }
    }
    if (indexPath.row == 0)
    {
        sizename.text = @"FITS IN A POCKET";
        sizedesc.text = @"Phone,keys,glasses etc.";
        itemimg.image = [UIImage imageNamed:@"pocket.png"];
        itemsizeimg.image = [UIImage imageNamed:@"XS.png"];
    }
    else if (indexPath.row == 1)
    {
        sizename.text = @"FITS IN A BAG";
        sizedesc.text = @"Laptop,book,clothes etc.";
        itemimg.image = [UIImage imageNamed:@"bag1.png"];
        itemsizeimg.image = [UIImage imageNamed:@"S.png"];
    }
    else if (indexPath.row == 2)
    {
        sizename.text = @"FIT IN A CAR";
        sizedesc.text = @"Painting,guitar,pet etc.";
        itemimg.image = [UIImage imageNamed:@"car.png"];
        itemsizeimg.image = [UIImage imageNamed:@"m.png"];
    }
    else if (indexPath.row == 3)
    {
        sizename.text = @"FIT IN A BIG CAR OR VAN";
        sizedesc.text = @"Furniture,bicycle etc.";
        itemimg.image = [UIImage imageNamed:@"van.png"];
        itemsizeimg.image = [UIImage imageNamed:@"L.png"];

    }
    return cell;
}

- (IBAction)nextAction:(id)sender
{
    
    if(selectedindex == nil)
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"PLease select item size" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        return;
    }
    if(selectedindex.row == 0)
    {
        [[AppDelegate getAppDelegate].senderDeliverydata setObject:@"XS" forKey:@"size"];
    }
    else if(selectedindex.row == 1)
    {
        [[AppDelegate getAppDelegate].senderDeliverydata setObject:@"S" forKey:@"size"];
    }
    else if(selectedindex.row == 2)
    {
        [[AppDelegate getAppDelegate].senderDeliverydata setObject:@"M" forKey:@"size"];
    }
    else if(selectedindex.row == 3)
    {
        [[AppDelegate getAppDelegate].senderDeliverydata setObject:@"L" forKey:@"size"];
    }
    if([[AppDelegate getAppDelegate].senderDeliverydata[@"jobType"]  isEqual: @"local"])
    {
        UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        Create_sendItem_4 *obj=[storyBoard instantiateViewControllerWithIdentifier:@"Create_sendItem_4"];
        [self.navigationController pushViewController:obj animated:true];
    }
    else
    {
        [[AppDelegate getAppDelegate].senderDeliverydata setObject:UserID forKey:@"userId"];
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    selectedindex = indexPath;
}

-(void)createitemResponse:(NSNotification *)notif
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:create_item_notification object:nil];
    [AppHelper showAlertViewWithTag:101145 title:App_Name message:@"Item successfully created" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:self.navigationController.viewControllers.count-4] animated:true];
}


-(void)modifyitemResponse:(NSNotification *)notif
{
    [[NSNotificationCenter defaultCenter]removeObserver:modify_postedjob_notification];
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:self.navigationController.viewControllers.count-4] animated:true];

}

@end
