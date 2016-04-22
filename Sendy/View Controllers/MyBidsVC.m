//
//  MyBidsVC.m
//  Sendy
//
//  Created by Ishan Shikha on 27/10/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "MyBidsVC.h"
#import "TPFloatRatingView.h"
#import "UILabel+Extra.h"
#import "BidVC.h"
@interface MyBidsVC()
{
    IBOutlet UILabel *messageLabel;
    IBOutlet UITableView *tableview;
    NSArray *bidsArray;
}
@end
@implementation MyBidsVC
-(void)viewDidLoad
{
    [super viewDidLoad];
    messageLabel.hidden=YES;
    [self getMyBids];
}
-(IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getMyBids
{
    if([AppDelegate getAppDelegate].isNetworkReachable)
    {
        [[AppDelegate getAppDelegate] showLoadingView:@"Please wait..."];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMyBidsResponse:) name:Bids_Deliverer_Rcvd_Notification object:nil];
        [[ServiceClass sharedServiceClass] bidsAsDelivererWithDictionary:[NSMutableDictionary dictionaryWithObject:UserID forKey:@"userId"]];
    }
    else
    {
        [AppHelper showAlertViewWithTag:10101 title:App_Name message:@"Please check your internert connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
    }
}
-(void)handleMyBidsResponse:(NSNotification *)not
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Awarded_Deliveries_As_Sender_Notification object:nil];
    if([not.object count]>0)
    {
        bidsArray=[NSArray array];
        bidsArray=not.object;
        messageLabel.hidden=YES;
    }
    else
    {
        messageLabel.hidden=NO;
        messageLabel.text=@"No Bids Found.";
    }
    [tableview reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return bidsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyBidsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    __weak  UIImageView *profilePicUser=(UIImageView *)[cell.contentView viewWithTag:1022];
    UILabel *userName=(UILabel *)[cell.contentView viewWithTag:1023];
    UIImageView *parcelTypeImage=(UIImageView *)[cell.contentView viewWithTag:1024];
    UILabel *parcelTypeName=(UILabel *)[cell.contentView viewWithTag:1025];
    UILabel *senderLocation=(UILabel *)[cell.contentView viewWithTag:1026];
    UILabel *deliveryLocation=(UILabel *)[cell.contentView viewWithTag:1027];
    UILabel *myBidLabel=(UILabel *)[cell.contentView viewWithTag:1028];
    UILabel *lowestBidLabel=(UILabel *)[cell.contentView viewWithTag:1029];

    TPFloatRatingView *ratingView=(TPFloatRatingView *)[cell.contentView viewWithTag:1030];
    UIButton *changeButton=(UIButton *)[cell.contentView viewWithTag:1031];
    [changeButton addTarget:self action:@selector(editBid:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *dataDict=nil;
    
    if(indexPath.row<bidsArray.count)
        dataDict=[bidsArray objectAtIndex:indexPath.row];
    
    if(dataDict)
    {
        if(![dataDict[@"userRating"] isKindOfClass:[NSNull class]])
        {
            ratingView.emptySelectedImage = [UIImage imageNamed:@"StarEmpty"];
            ratingView.fullSelectedImage = [UIImage imageNamed:@"StarFull"];
            ratingView.contentMode = UIViewContentModeScaleAspectFill;
            ratingView.maxRating = 5;
            ratingView.minRating = 0;
            ratingView.rating = [dataDict[@"userRating"] floatValue];
            ratingView.editable = NO;
            ratingView.halfRatings = YES;
            ratingView.floatRatings = YES;
        }
        
        
        profilePicUser.layer.cornerRadius =30.0;
        profilePicUser.clipsToBounds = YES;
        profilePicUser.backgroundColor=greenColor;
        profilePicUser.layer.borderWidth=1.0;
        profilePicUser.layer.borderColor = greenColor.CGColor;
        
        if(![dataDict[@"userPic"] isKindOfClass:[NSNull class]])
            [profilePicUser setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dataDict[@"userPic"]]] placeholderImage:[UIImage imageNamed:@"myprofile.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                if(image)
                    profilePicUser.image=image;
                else
                    profilePicUser.image=[UIImage imageNamed:@"myprofile.png"];
                
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                
            }];
        else
            profilePicUser.image=[UIImage imageNamed:@"myprofile.png"];
        
        if(![dataDict[@"userName"] isKindOfClass:[NSNull class]])
            userName.text=dataDict[@"userName"];
        else
            userName.text=@"";
        
        if(![dataDict[@"parcelType"] isKindOfClass:[NSNull class]])
            parcelTypeImage.image=[self getParcelImageByName:[dataDict[@"parcelType"] capitalizedString]];
        else
            parcelTypeImage.image=nil;
        
        if(![dataDict[@"parcelType"] isKindOfClass:[NSNull class]])
            parcelTypeName.text=[dataDict[@"parcelType"] capitalizedString];
        else
            parcelTypeName.text=@"";
        
        if(![dataDict[@"senderLocation"] isKindOfClass:[NSNull class]])
            senderLocation.text=[NSString stringWithFormat:@"Sender Location : %@",[dataDict[@"senderLocation"] capitalizedString]];
        else
            senderLocation.text=@"Sender Location : ";
        [senderLocation setAttributeText:NSMakeRange(0,17)];
        
        
        
        if(![dataDict[@"deliveryAddress"] isKindOfClass:[NSNull class]])
            deliveryLocation.text=[NSString stringWithFormat:@"Delivery Location : %@",[dataDict[@"deliveryAddress"] capitalizedString]];
        else
            deliveryLocation.text=@"Delivery Location : ";
        [deliveryLocation setAttributeText:NSMakeRange(0,19)];
        
        if(![dataDict[@"myBid"] isKindOfClass:[NSNull class]])
        {
            
            NSString *currencyType=@"";
            if([dataDict[@"myBidCurrencyType"] isEqualToString:@"EUR"])
                currencyType=@"€";
            else if ([dataDict[@"myBidCurrencyType"] isEqualToString:@"USD"])
                currencyType=@"$";
            else
                currencyType=@"£";
            
            myBidLabel.text=[NSString stringWithFormat:@"My Bid:%@",[NSString stringWithFormat:@"%@%@",currencyType,   dataDict[@"myBid"] ]];
        }
        else
            myBidLabel.text=@"My Bid:0";
        [myBidLabel setAttributeText:NSMakeRange(0,7)];

        if(![dataDict[@"lowestBid"] isKindOfClass:[NSNull class]])
        {
            
            NSString *currencyType=@"";
            if([dataDict[@"lowestBidCurrencyType"] isEqualToString:@"EUR"])
                currencyType=@"€";
            else if ([dataDict[@"lowestBidCurrencyType"] isEqualToString:@"USD"])
                currencyType=@"$";
            else
                currencyType=@"£";
            
            lowestBidLabel.text=[NSString stringWithFormat:@"Lowest Bid:%@",[NSString stringWithFormat:@"%@%@",currencyType,   dataDict[@"lowestBid"] ]];
        }
        else
            lowestBidLabel.text=@"Lowest Bid:0";
        [lowestBidLabel setAttributeText:NSMakeRange(0,11)];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(UIImage *)getParcelImageByName:(NSString *)parcelName
{
    NSInteger index=[[AppDelegate getAppDelegate].labelArray indexOfObject:parcelName];
    if(index<[AppDelegate getAppDelegate].imageArray.count)
        return [UIImage imageNamed:[[AppDelegate getAppDelegate].imageArray objectAtIndex:index]];
    else
        return nil;
}
-(void)editBid:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    UITableViewCell *cell=(UITableViewCell *)[[[btn superview] superview] superview];
    NSIndexPath *index=[tableview indexPathForCell:cell];
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BidVC *bidVC=[storyBoard instantiateViewControllerWithIdentifier:@"BidVC"];
    bidVC.isComingToEdit=YES;
    bidVC.infoDict=[bidsArray objectAtIndex:index.row];
    [self.navigationController pushViewController:bidVC animated:YES];
}
@end
