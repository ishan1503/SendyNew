//
//  BidListVC.m
//  Sendy
//
//  Created by Ishan Shikha on 22/10/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "BidListVC.h"
#import "UILabel+Extra.h"
#import "TPFloatRatingView.h"
#import "UILabel+Extra.h"
#import "CurrentOffers.h"
@interface BidListVC()
{
    IBOutlet UILabel *createdOn;
    IBOutlet UILabel *timeOn;
    IBOutlet UILabel *deliveryAdd;
    IBOutlet UILabel *parcelType;
    IBOutlet UIImageView *parcelImage;
    
    IBOutlet UILabel *headerLabel;
    IBOutlet UITableView *tableview;
    
    NSInteger selectedIndex;
}
@end

@implementation BidListVC
-(IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    createdOn.text=[@"Created On: " stringByAppendingString:[self terminateTime:[self.dict objectForKey:@"createdOn"]]];
    [createdOn setAttributeText:NSMakeRange(0, 11)];

    timeOn.text=[@"Time: " stringByAppendingString:[self terminateDate:[self.dict objectForKey:@"createdOn"]]];
    [timeOn setAttributeText:NSMakeRange(0, 5)];
   
    deliveryAdd.text=[@"Delivery Add: " stringByAppendingString:[self.dict objectForKey:@"deliveryAddress"]];
    [deliveryAdd setAttributeText:NSMakeRange(0, 13)];
    parcelType.text=[self.dict objectForKey:@"parcelType"];
    parcelImage.image=[UIImage imageNamed:[[AppDelegate getAppDelegate].imageArray objectAtIndex:[[AppDelegate getAppDelegate].labelArray indexOfObject:[self.dict objectForKey:@"parcelType"]]]];
    
    
    NSArray *bidArray=(NSArray *)[self.dict objectForKey:@"bid"];
    headerLabel.text=[NSString stringWithFormat:@"%lu Bids",(unsigned long)bidArray.count];
    
 
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
}
#pragma mark-Table View Delegate & Datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 154.0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *bidArray=(NSArray *)[self.dict objectForKey:@"bid"];
    return bidArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BidListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    NSArray *bidArray=(NSArray *)[self.dict objectForKey:@"bid"];
    NSDictionary *dataDict=[bidArray objectAtIndex:indexPath.row];
    
    __weak  UIImageView *profilePicUser=(UIImageView *)[cell.contentView viewWithTag:1022];
    UILabel *userName=(UILabel *)[cell.contentView viewWithTag:1023];
    UILabel *noteLabel =(UILabel *)[cell.contentView viewWithTag:1028];
    UILabel *bidLabel=(UILabel *)[cell.contentView viewWithTag:1027];
    TPFloatRatingView *ratingView=(TPFloatRatingView *)[cell.contentView viewWithTag:1030];
    UIButton *messageButton=(UIButton *)[cell.contentView viewWithTag:1029];
    UIButton *reviewBUtton=(UIButton *)[cell.contentView viewWithTag:1035];
    UIButton *awardButton=(UIButton *)[cell.contentView viewWithTag:1036];

    
    UIImage *image = [[UIImage imageNamed:@"msg.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [messageButton setImage:image forState:UIControlStateSelected];
    [messageButton setImage:image forState:UIControlStateHighlighted];
    [messageButton setImage:image forState:UIControlStateNormal];
    messageButton.tintColor =greenColor;
    [messageButton addTarget:self action:@selector(showAlert) forControlEvents:UIControlEventTouchUpInside];
    
    [awardButton addTarget:self action:@selector(awardDelivery:) forControlEvents:UIControlEventTouchUpInside];
    
    if(![dataDict[@"bidderRatings"] isKindOfClass:[NSNull class]])
    {
        ratingView.emptySelectedImage = [UIImage imageNamed:@"StarEmpty"];
        ratingView.fullSelectedImage = [UIImage imageNamed:@"StarFull"];
        ratingView.contentMode = UIViewContentModeScaleAspectFill;
        ratingView.maxRating = 5;
        ratingView.minRating = 0;
        ratingView.rating = [dataDict[@"bidderRatings"] floatValue];
        ratingView.editable = NO;
        ratingView.halfRatings = YES;
        ratingView.floatRatings = YES;
    }
    
    
    profilePicUser.layer.cornerRadius =30.0;
    profilePicUser.clipsToBounds = YES;
    profilePicUser.backgroundColor=greenColor;
    profilePicUser.layer.borderWidth=1.0;
    profilePicUser.layer.borderColor = greenColor.CGColor;
    
    if(![dataDict[@"profilePic"] isKindOfClass:[NSNull class]])
        [profilePicUser setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dataDict[@"profilePic"]]] placeholderImage:[UIImage imageNamed:@"myprofile.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            if(image)
                profilePicUser.image=image;
            else
                profilePicUser.image=[UIImage imageNamed:@"myprofile.png"];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
    else
        profilePicUser.image=[UIImage imageNamed:@"myprofile.png"];
    
    
    if(![dataDict[@"bidderName"] isKindOfClass:[NSNull class]])
        userName.text=dataDict[@"bidderName"];
    else
        userName.text=@"";

    
    if(![dataDict[@"bidAmount"] isKindOfClass:[NSNull class]])
    {
        NSString *currencyType=@"";
        if([dataDict[@"bidAmountType"] isEqualToString:@"EUR"])
            currencyType=@"€";
        else if ([dataDict[@"bidAmountType"] isEqualToString:@"USD"])
            currencyType=@"$";
        else
            currencyType=@"£";
        
        bidLabel.text=[NSString stringWithFormat:@"Bid Amount: %@",[NSString stringWithFormat:@"%@ %@",currencyType,   dataDict[@"bidAmount"] ]];
    }
    else
        bidLabel.text=@"Bid Amount:";

    [bidLabel setAttributeText:NSMakeRange(0, 11)];
    
    if(![dataDict[@"bidNote"] isKindOfClass:[NSNull class]])
        noteLabel.text=[NSString stringWithFormat:@"Notes: %@",dataDict[@"bidNote"]];
    else
        noteLabel.text=@"Notes:";
    [noteLabel setAttributeText:NSMakeRange(0, 6)];

    if(![dataDict[@"totalReview"] isKindOfClass:[NSNull class]])
        [reviewBUtton setTitle:[NSString stringWithFormat:@"%@ Reviews",dataDict[@"totalReview"]] forState:UIControlStateNormal];
    else
        [reviewBUtton setTitle:@"0 Reviews" forState:UIControlStateNormal];
    [reviewBUtton addTarget:self action:@selector(showAlert) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)awardDelivery:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    UITableViewCell *cell=(UITableViewCell *)[[[btn superview] superview] superview];
    selectedIndex =[tableview indexPathForCell:cell].row;
    [AppHelper showAlertViewWithTag:1010155 title:App_Name message:@"Want to Award the Delivery ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes"];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1010155 && buttonIndex!=alertView.cancelButtonIndex)
    {
        if([AppDelegate getAppDelegate].isNetworkReachable)
        {
            [[AppDelegate getAppDelegate] showLoadingView:@"Please wait..."];
            
            NSArray *bidArray=(NSArray *)[self.dict objectForKey:@"bid"];
            NSDictionary *dataDict=[bidArray objectAtIndex:selectedIndex];

            NSMutableDictionary *dict=[NSMutableDictionary dictionary];
            [dict setObject:dataDict[@"bidBy"] forKey:@"awardTo"];
            [dict setObject:UserID forKey:@"awardFrom"];
            [dict setObject:self.dict[@"id"] forKey:@"itemId"];
            [dict setObject:dataDict[@"bidAmountType"] forKey:@"paymentType"];
            [dict setObject:dataDict[@"bidAmount"] forKey:@"amount"];

            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAwardResponse) name:Job_Awarded_Notification object:nil];
            [[ServiceClass sharedServiceClass] awardJobWithDictionary:dict];
        }
        else
        {
            [AppHelper showAlertViewWithTag:10101 title:App_Name message:@"Please check your internert connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];

        }
        
    }
    else if(alertView.tag==1055)
    {
        CurrentOffers *obj=(CurrentOffers *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        [obj getCurrentOffers];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)getAwardResponse
{
    [AppHelper showAlertViewWithTag:1055 title:App_Name message:@"Job Awarded" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
}
-(void)showAlert
{
    [AppHelper showAlertViewWithTag:10101 title:App_Name message:@"Under Development" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];

}
-(NSString *)terminateDate:(NSString *)date
{
    NSString *dateAndTime = date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] ];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //[dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate   *aDate = [dateFormatter dateFromString:dateAndTime];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    NSString *dateString = [dateFormatter2 stringFromDate:aDate];
    return dateString;
    
}
-(NSString *)terminateTime:(NSString *)date
{
    NSString *dateAndTime = date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] ];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //[dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate   *aDate = [dateFormatter dateFromString:dateAndTime];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString = [dateFormatter2 stringFromDate:aDate];
    return dateString;
    
}
@end
