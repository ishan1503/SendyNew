//
//  BidVC.m
//  Sendy
//
//  Created by Ishan Shikha on 11/10/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "BidVC.h"
#import "TPFloatRatingView.h"
#import "UILabel+Extra.h"
#import "HomeVC.h"
#import "MyBidsVC.h"
@interface BidVC ()
{
    IBOutlet UITableView *tableview;
    UISegmentedControl *segment;
    NSInteger selectedSegmentIndice;
    IBOutlet UILabel *headerLabel;
    UISegmentedControl *currencySegment;
    
    UITextField *amountTextField;
    UITextView *notesTextField;
    NSString *notes;
    NSString *amount;
}
@end

@implementation BidVC
- (void)viewDidLoad {
    [super viewDidLoad];
    selectedSegmentIndice=0;
    
    if(![self.infoDict[@"userName"] isKindOfClass:[NSNull class]])
        headerLabel.text=self.infoDict[@"userName"];
    else
        headerLabel.text=@"";
    if(self.isComingToEdit)
    {
        if(![self.infoDict[@"SenderName"] isKindOfClass:[NSNull class]])
            headerLabel.text=self.infoDict[@"SenderName"];
        else
            headerLabel.text=@"";
    }
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tableview addGestureRecognizer:tapGesture];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)handleTap:(UITapGestureRecognizer *)gesture
{
    [self resetTableViewDown];
    [self.view endEditing:YES];
}
#pragma mark-Selected Segment Handler
-(void)segmentSelect:(id)sender
{
    if(segment.selectedSegmentIndex==0)
    {
        [segment setSelectedSegmentIndex:0];
        
    }
    else
    {
        [AppHelper showAlertViewWithTag:1212 title:App_Name message:@"Under Development" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [segment setSelectedSegmentIndex:1];
    }
}
#pragma mark-BackButton
-(IBAction)backButtonPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-Table View Delegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =nil;
    if(indexPath.row==0)
        CellIdentifier = @"cell1";
    else
        CellIdentifier=@"cell2";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
   
    if(self.infoDict && indexPath.row==0)
    {
        
        __weak  UIImageView *profilePicUser=(UIImageView *)[cell.contentView viewWithTag:1021];
        UILabel *parcelTypeName=(UILabel *)[cell.contentView viewWithTag:1025];
        UILabel *senderLocation=(UILabel *)[cell.contentView viewWithTag:1026];
        UILabel *deliveryLocation=(UILabel *)[cell.contentView viewWithTag:1027];
        UILabel *currentBidLabel=(UILabel *)[cell.contentView viewWithTag:1023];
        UILabel *deliveryDateLabel=(UILabel *)[cell.contentView viewWithTag:1024];
        TPFloatRatingView *ratingView=(TPFloatRatingView *)[cell.contentView viewWithTag:1022];

        NSString *ratings;
        if(self.isComingToEdit)
            ratings=self.infoDict[@"SenderRating"];
        else
            ratings=self.infoDict[@"ratings"];
        
        if(![ratings isKindOfClass:[NSNull class]])
        {
            ratingView.emptySelectedImage = [UIImage imageNamed:@"StarEmpty"];
            ratingView.fullSelectedImage = [UIImage imageNamed:@"StarFull"];
            ratingView.contentMode = UIViewContentModeScaleAspectFill;
            ratingView.maxRating = 5;
            ratingView.minRating = 0;
            ratingView.rating = [ratings floatValue];
            ratingView.editable = NO;
            ratingView.halfRatings = YES;
            ratingView.floatRatings = YES;
        }
    
       
       profilePicUser.layer.cornerRadius =25.0;
       profilePicUser.clipsToBounds = YES;
       profilePicUser.backgroundColor=greenColor;
       
        NSString *imageParam;
        if(self.isComingToEdit)
            imageParam=@"SenderPic";
        else
            imageParam=@"imageUrl";
        
       if(![self.infoDict[imageParam] isKindOfClass:[NSNull class]])
           [profilePicUser setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.infoDict[imageParam]]] placeholderImage:[UIImage imageNamed:@"myprofile.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
               if(image)
                   profilePicUser.image=image;
               else
                   profilePicUser.image=[UIImage imageNamed:@"myprofile.png"];
               
           } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
               
           }];
       else
           profilePicUser.image=[UIImage imageNamed:@"myprofile.png"];
    
        if(![self.infoDict[@"parcelType"] isKindOfClass:[NSNull class]])
        {
            NSString *weightType=@"";
            NSString *spaceType=@"";
            NSString *dim=@"";
          if(![self.infoDict[@"weightType"] isKindOfClass:[NSNull class]]&&![self.infoDict[@"spaceType"] isKindOfClass:[NSNull class]]&&!self.infoDict)
          {
            
            if([[self.infoDict objectForKey:@"weightType"] isEqualToString:@"k"]||[[self.infoDict objectForKey:@"weightType"] isEqualToString:@"K"])
                weightType=@" K";
            else if([[self.infoDict objectForKey:@"weightType"] isEqualToString:@"g"]||[[self.infoDict objectForKey:@"weightType"] isEqualToString:@"G"])
                weightType=@" G";
            else
                weightType=@" L";
            
            if([[self.infoDict objectForKey:@"spaceType"] isEqualToString:@"i"]||[[self.infoDict objectForKey:@"spaceType"] isEqualToString:@"I"])
                spaceType=@" In";
            else
                spaceType=@" Cm";
              
            dim=[[[[[[[[[[@"" stringByAppendingString:[self.infoDict objectForKey:@"weightValue"]] stringByAppendingString:weightType] stringByAppendingString:@", "] stringByAppendingString:@"H "] stringByAppendingString:[self.infoDict objectForKey:@"height"]] stringByAppendingString:@" L "] stringByAppendingString:[self.infoDict objectForKey:@"length"]] stringByAppendingString:@" W "] stringByAppendingString:[self.infoDict objectForKey:@"width"]] stringByAppendingString:spaceType];

          }
            
            
        parcelTypeName.text=[NSString stringWithFormat:@"Item: %@ (%@)",[self.infoDict[@"parcelType"] capitalizedString],dim];

        }
        else
            parcelTypeName.text=@"";
        [parcelTypeName setAttributeText:NSMakeRange(0,5)];

        if(![self.infoDict[@"senderLocation"] isKindOfClass:[NSNull class]])
            senderLocation.text=[NSString stringWithFormat:@"Sender Location : %@",[self.infoDict[@"senderLocation"] capitalizedString]];
        else
            senderLocation.text=@"Sender Location : ";
        [senderLocation setAttributeText:NSMakeRange(0,17)];
        
        NSString *deliveryParam;
        if(self.isComingToEdit)
            deliveryParam=@"deliveryAddress";
        else
            deliveryParam=@"deliveryLocation";
        
        
        if(![self.infoDict[deliveryParam] isKindOfClass:[NSNull class]])
            deliveryLocation.text=[NSString stringWithFormat:@"Delivery Location : %@",[self.infoDict[deliveryParam] capitalizedString]];
        else
            deliveryLocation.text=@"Delivery Location : ";
        [deliveryLocation setAttributeText:NSMakeRange(0,19)];
       
        NSString *bidParam;
        NSString *bidTypeParam;
        if(self.isComingToEdit)
        {
            bidParam=@"lowestBid";
            bidTypeParam=@"lowestBidCurrencyType";
        }
        else
        {
            bidParam=@"currentBid";
            bidTypeParam=@"bidAmountType";

        }
        
        if(![self.infoDict[bidParam] isKindOfClass:[NSNull class]])
        {
            NSString *currencyType=@"";
            if([self.infoDict[bidTypeParam] isEqualToString:@"EUR"])
                currencyType=@"€";
            else if ([self.infoDict[bidTypeParam] isEqualToString:@"USD"])
                currencyType=@"$";
            else
                currencyType=@"£";
            if(self.isComingToEdit)
                currentBidLabel.text=[NSString stringWithFormat:@"Lowest Bid : %@",[NSString stringWithFormat:@"%@ %@",currencyType,   self.infoDict[bidParam] ]];
            else
                currentBidLabel.text=[NSString stringWithFormat:@"Curr. Bid : %@",[NSString stringWithFormat:@"%@ %@",currencyType,   self.infoDict[bidParam] ]];

        }
        else
        {
            if(self.isComingToEdit)
                currentBidLabel.text=@"Lowest Bid : 0 Bid";

            else
                currentBidLabel.text=@"Curr. Bid : 0 Bid";
        }
        if(self.isComingToEdit)
            [currentBidLabel setAttributeText:NSMakeRange(0,12)];
        else
            [currentBidLabel setAttributeText:NSMakeRange(0,11)];
        
        if(![self.infoDict[@"delieveryDate"] isKindOfClass:[NSNull class]])
        {
            deliveryDateLabel.text=[NSString stringWithFormat:@"Delivery Date: %@",[self terminateTime:self.infoDict[@"delieveryDate"]]];
        }
        else
            deliveryDateLabel.text=@"Delivery Date: ";
        [deliveryDateLabel setAttributeText:NSMakeRange(0,15)];
    }
    else
    {
        currencySegment=(UISegmentedControl *)[cell.contentView viewWithTag:1021];
        
        amountTextField=(UITextField *)[cell.contentView viewWithTag:1022];
        amountTextField.delegate=self;
        amountTextField.layer.borderWidth=1.0;
        amountTextField.layer.borderColor = greenColor.CGColor;
        amountTextField.layer.cornerRadius =4.0;
        amountTextField.clipsToBounds = YES;
        amountTextField.keyboardType=UIKeyboardTypeNumberPad;
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        amountTextField.leftView = paddingView;
        amountTextField.leftViewMode = UITextFieldViewModeAlways;

        
        notesTextField=(UITextView *)[cell.contentView viewWithTag:1023];
        notesTextField.delegate=self;
        notesTextField.layer.borderWidth=1.0;
        notesTextField.layer.borderColor = greenColor.CGColor;
        notesTextField.layer.cornerRadius =4.0;
        notesTextField.clipsToBounds = YES;
        if([notesTextField.text isEqualToString:@"Enter Notes"])
            notesTextField.textColor=[UIColor lightGrayColor];
        else
            notesTextField.textColor=[UIColor blackColor];
        if(self.isComingToEdit)
        {
            amountTextField.text=self.infoDict[@"myBid"];
            amount=self.infoDict[@"myBid"];
            
            if([self.infoDict[@"myBidCurrencyType"] isEqualToString:@"EUR"])
                [currencySegment setSelectedSegmentIndex:2];
            else if ([self.infoDict[@"myBidCurrencyType"] isEqualToString:@"USD"])
                [currencySegment setSelectedSegmentIndex:0];
            else
                [currencySegment setSelectedSegmentIndex:1];
            
            notesTextField.text=self.infoDict[@"note"];
            notes=self.infoDict[@"note"];
            notesTextField.textColor=[UIColor blackColor];
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 50.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,50.0)];
    headerView.backgroundColor=[UIColor colorWithRed:214.0/265.0 green:214.0/265.0 blue:214.0/265.0 alpha:0.7];

    
    NSArray *itemArray = [NSArray arrayWithObjects: @"Details", @"Read Reviews",nil];
    segment=[[UISegmentedControl alloc] initWithItems:itemArray];
    segment.frame=CGRectMake(5, 10, SCREEN_WIDTH-10, 30);
    segment.tintColor=greenColor;
    segment.backgroundColor=[UIColor whiteColor];
    [segment addTarget:self action:@selector(segmentSelect:) forControlEvents:UIControlEventValueChanged];
    [segment setSelectedSegmentIndex:selectedSegmentIndice];
    [headerView addSubview:segment];
    return headerView;
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
-(void)reloadTable
{
    selectedSegmentIndice=segment.selectedSegmentIndex;
    [tableview reloadData];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self resetTableViewDown];
    [UIView animateWithDuration:0.4 animations:^{
        if(IS_IPHONE_4_OR_LESS)
        {
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-250, self.view.frame.size.width, self.view.frame.size.height)];
        }
        else if (IS_IPHONE_5)
        {
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-150, self.view.frame.size.width, self.view.frame.size.height)];
        }
    }];
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self resetTableViewDown];
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self resetTableViewDown];
    if([textView.text isEqualToString:@"Enter Notes"])
    {
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        if(IS_IPHONE_4_OR_LESS)
        {
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-300, self.view.frame.size.width, self.view.frame.size.height)];
        }
        else if (IS_IPHONE_5)
        {
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-200, self.view.frame.size.width, self.view.frame.size.height)];
        }
    }];
    
    return YES;
    
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    amount=textField.text;
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if(textView.text.length==0)
    {
        textView.text=@"Enter Notes";
        textView.textColor=[UIColor lightGrayColor];
    }
    if(![textView.text isEqualToString:@"Enter Notes"])
        notes=notesTextField.text;
    return YES;
}
#pragma Reset Table View Down
-(void)resetTableViewDown
{
    [UIView animateWithDuration:0.4 animations:^{
        [self.view setFrame:CGRectMake(self.view.frame.origin.x,0, self.view.frame.size.width, self.view.frame.size.height)];
    }];
}
-(IBAction)postBidClicked:(id)sender
{
    if ([AppDelegate getAppDelegate].isNetworkReachable) {
        
        
        if(amount.length==0)
        {
            [AppHelper showAlertViewWithTag:12121 title:App_Name message:@"Bid amount should not be blank." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        }
        else if (notes.length==0)
        {
            [AppHelper showAlertViewWithTag:12121 title:App_Name message:@"Notes should not be blank." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        }
        else
        {
            NSMutableDictionary *dict=[NSMutableDictionary dictionary];
            [dict setObject:UserID forKey:@"bidBy"];
            
            [dict setObject:amount forKey:@"bidAmount"];
            
            if(currencySegment.selectedSegmentIndex==0)
                [dict setObject:@"USD" forKey:@"bidAmountType"];
            else if (currencySegment.selectedSegmentIndex==1)
                [dict setObject:@"GBP" forKey:@"bidAmountType"];
            else
                [dict setObject:@"EUR" forKey:@"bidAmountType"];
            if(!self.isComingToEdit)
                [dict setObject:self.infoDict[@"id"] forKey:@"itemId"];
            else
                [dict setObject:self.infoDict[@"itemId"] forKey:@"itemId"];
            [dict setObject:notes forKey:@"bidNote"];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePostBidResponse:) name:Post_Bid_Notification object:nil];
            [[ServiceClass sharedServiceClass] postBidWithDictionary:dict];
        }

    }
    else
    {
        [AppHelper showAlertViewWithTag:1211 title:App_Name message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
}
-(void)handlePostBidResponse:(NSNotification *)not
{
    [[AppDelegate getAppDelegate] hideLoadingView];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Post_Bid_Notification object:nil];
    [AppHelper showAlertViewWithTag:11111 title:App_Name message:@"Bid sucessfully posted." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    if(!self.isComingToEdit)
    {
        HomeVC *obj=(HomeVC *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        //[obj getListOfSender];
    }
    else
    {
        MyBidsVC *obj=(MyBidsVC *)[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        [obj getMyBids];

    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (11111&&buttonIndex==alertView.cancelButtonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end