//
//  MakeADeliveryVC.m
//  Sendy
//
//  Created by Ishan Shikha on 14/07/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "ParcelOptionVC.h"
#import "CreateItemVC.h"
@interface ParcelOptionVC ()
{
    IBOutlet UITableView *tableview;
}
@end

@implementation ParcelOptionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(IBAction)backButtonPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 30.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,30.0)];
    headerView.backgroundColor=[UIColor colorWithRed:214.0/265.0 green:214.0/265.0 blue:214.0/265.0 alpha:1.0];
    
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-50, 30)];
    label.font=[UIFont systemFontOfSize:13.0];
    label.text=@"What are you sending ?";
    
    [headerView addSubview:label];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    cell.contentView.backgroundColor=[UIColor clearColor];
    
    UIImageView *iconImage=(UIImageView *)[cell.contentView viewWithTag:1021];
    iconImage.image=[UIImage imageNamed:[[AppDelegate getAppDelegate].imageArray objectAtIndex:indexPath.row]];
    
    UILabel *label=(UILabel *)[cell.contentView viewWithTag:1022];
    label.text=[[AppDelegate getAppDelegate].labelArray objectAtIndex:indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(!self.createItemVC)
        [self performSegueWithIdentifier:@"openCreateDelivey" sender:[tableview cellForRowAtIndexPath:indexPath]];
    else
    {
        self.createItemVC.parcelTypeName=[[AppDelegate getAppDelegate].labelArray objectAtIndex:indexPath.row];
        self.createItemVC.parcelTypeImageName=[[AppDelegate getAppDelegate].imageArray objectAtIndex:indexPath.row];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *cell=(UITableViewCell *)sender;
    if([segue.identifier isEqualToString:@"openCreateDelivey"])
    {
        CreateItemVC *obj=(CreateItemVC *)segue.destinationViewController;
        obj.parcelTypeName=[[AppDelegate getAppDelegate].labelArray objectAtIndex:[tableview indexPathForCell:cell].row];
        obj.parcelTypeImageName=[[AppDelegate getAppDelegate].imageArray objectAtIndex:[tableview indexPathForCell:cell].row];
    }
}
@end
