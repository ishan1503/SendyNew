//
//  postedjobsListingVC.m
//  Sendy
//
//  Created by Prankur on 16/04/16.
//  Copyright (c) 2016 Ishan Gupta. All rights reserved.
//

#import "postedjobsListingVC.h"
#import "create_sendIntem_1.h"
#import "ProfileSetupVC.h"

@interface postedjobsListingVC ()
{
    IBOutlet UITableView *tblpostedjob;
    NSMutableArray *postedjobarr;
    IBOutlet UISegmentedControl *jobtypesegment;
}

@end

@implementation postedjobsListingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getdatapostedjoblisting];
}
- (void)viewWillAppear:(BOOL)animated
{
    [tblpostedjob performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)getdatapostedjoblisting
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Postedjobsresponse:) name:Posted_job_Listing object:nil];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:UserID forKey:@"userId"];
    if(jobtypesegment.selectedSegmentIndex == 0)
    {
        [dict setObject:@"local" forKey:@"jobType"];
    }
    else
    {
        [dict setObject:@"long" forKey:@"jobType"];
    }
    [[ServiceClass sharedServiceClass] getPostedjobListing:dict];
}
- (IBAction)segmentchangeforJobtype:(id)sender
{
    [postedjobarr removeAllObjects];
    [tblpostedjob reloadData];
    [self getdatapostedjoblisting];
}

-(void)Postedjobsresponse:(NSNotification *)not
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Posted_job_Listing object:nil];
    if([not.object count]>0)
    {
        [postedjobarr removeAllObjects];
        postedjobarr=[not.object mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
                [tblpostedjob reloadData];
            });
        //messagelabel.hidden=YES;
    }
    else
    {
        //messagelabel.hidden=NO;
    }

    //NSLog(@"%@",notif);
}





# pragma mark - Cell Setup

//- (void)setUpCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
//{
//    cell.label.text = [postedjobarr objectAtIndex:indexPath.row];
//}

# pragma mark - UITableViewControllerDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return postedjobarr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 0.001;
    else
        return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    NSDictionary *dataDict=nil;
    dataDict=[postedjobarr objectAtIndex:indexPath.section];
//    dataDict[@"bidsCount"];
//    dataDict[@"fromAddress"];
//    dataDict[@"itemId"];
//    dataDict[@"size"];
//    dataDict[@"toAddress"];
    if(indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"itemnamecell"];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"itemnamecell"];
        }
        UILabel *itemname=(UILabel *)[cell.contentView viewWithTag:101];
        UIImageView *itemsize=(UIImageView *)[cell.contentView viewWithTag:102];
        NSString* sizetype =  dataDict[@"size"];
        itemname.text = dataDict[@"itemName"];
        if([sizetype  isEqual: @"XS"])
        {
            [itemsize setImage:[UIImage imageNamed:@"xs_post.png"]];
        }
        else if ([sizetype  isEqual: @"S"])
        {
            [itemsize setImage:[UIImage imageNamed:@"s_post.png"]];
        }
        else if ([sizetype  isEqual: @"M"])
        {
            [itemsize setImage:[UIImage imageNamed:@"m_post.png"]];
        }
        else if ([sizetype  isEqual: @"L"])
        {
            [itemsize setImage:[UIImage imageNamed:@"l_post.png"]];
        }
    }
    else if (indexPath.row == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"addresscell"];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addresscell"];
        }
        UILabel *address=(UILabel *)[cell.contentView viewWithTag:103];
        address.text = dataDict[@"fromAddress"];
    }
    else if (indexPath.row == 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"addresscell"];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addresscell"];
        }

        UILabel *address=(UILabel *)[cell.contentView viewWithTag:103];
        address.text = dataDict[@"toAddress"];
    }
    else if (indexPath.row == 3)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"bidreceivedcell"];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bidreceivedcell"];
        }
        UILabel *bidrec=(UILabel *)[cell.contentView viewWithTag:105];
        NSLog(@"%@",dataDict[@"bidsCount"]);
        bidrec.text = [NSString stringWithFormat:@"%@",dataDict[@"bidsCount"]];
        //dataDict[@"bidsCount"];
    }
    else if (indexPath.row == 4)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"postjoboperationcell"];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"postjoboperationcell"];
        }
        UIButton *mofifybtn=(UIButton *)[cell.contentView viewWithTag:501];
        UIButton *deletebtn=(UIButton *)[cell.contentView viewWithTag:502];

        [mofifybtn addTarget:self action:@selector(modifyPost:) forControlEvents:UIControlEventTouchUpInside];
        [deletebtn addTarget:self action:@selector(deletepost:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell respondsToSelector:@selector(tintColor)]) {
        CGFloat cornerRadius = 5.f;
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 0, 0);
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
        } else if (indexPath.row == 0) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        } else {
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        //set the border color
        layer.strokeColor = [UIColor lightGrayColor].CGColor;
        //set the border width
        layer.lineWidth = 1;
        layer.fillColor = [UIColor colorWithWhite:1.f alpha:1.0f].CGColor;
        
        
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
            lineLayer.backgroundColor = tableView.separatorColor.CGColor;
            [layer addSublayer:lineLayer];
        }
        
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = testView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 1)
//    {
//        static UITableViewCell *cell = nil;
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            cell = [tblpostedjob dequeueReusableCellWithIdentifier:@"addresscell"];
//        });
//        UILabel *itemname=(UILabel *)[cell.contentView viewWithTag:101];
//        itemname.text = [postedjobarr objectAtIndex:indexPath.section][@"itemName"];
//        [cell layoutIfNeeded];
//        CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//        return size.height;
//    }
//    static DynamicTableViewCell *cell = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    });
//    
//    [self setUpCell:cell atIndexPath:indexPath];
//    return [self calculateHeightForConfiguredSizingCell:cell];
    if (indexPath.row)
    {
        return UITableViewAutomaticDimension;
    }
    else
    {
        return 56;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.row == 3)
    {
        
    }
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell
{
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

-(void)modifyPost:(id)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletepostresponse:) name:delete_postedjob_notification object:nil];
    UIButton *btn=(UIButton *)sender;
    UITableViewCell *cell=(UITableViewCell *)[[btn superview] superview] ;
    NSIndexPath* indexPath = [tblpostedjob indexPathForCell:cell];
    [AppDelegate getAppDelegate].ismodifyjob = @"modifydata";
    [[AppDelegate getAppDelegate].senderDeliverydata removeAllObjects];
    [AppDelegate getAppDelegate].senderDeliverydata = [postedjobarr objectAtIndex:indexPath.section];
    UIStoryboard *mainStoryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    create_sendIntem_1 *profileSetupVC=[mainStoryBoard instantiateViewControllerWithIdentifier:@"create_sendIntem_1"];
    [self.navigationController showViewController:profileSetupVC sender:nil];
}

-(void)deletepost:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    UITableViewCell *cell=(UITableViewCell *)[[btn superview] superview] ;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deletepostresponse:) name:delete_postedjob_notification object:nil];
    NSIndexPath* indexPath = [tblpostedjob indexPathForCell:cell];
    NSDictionary *dataDict= [postedjobarr objectAtIndex:indexPath.section];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:dataDict[@"itemId"] forKey:@"itemId"];
    [[ServiceClass sharedServiceClass] deletepost:dict];
}

-(void)deletepostresponse:(NSNotification *)not
{
    [[NSNotificationCenter defaultCenter]removeObserver:delete_postedjob_notification];
    [self getdatapostedjoblisting];
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


@end
