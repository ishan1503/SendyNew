//
//  AwardedSenderDetail.m
//  Sendy
//
//  Created by Ishan Shikha on 25/10/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "AwardedSenderDetail.h"
#import "UILabel+Extra.h"
#import "TPFloatRatingView.h"
#import "ReviewsVC.h"
#import "ConversationVC.h"
#import "ChatService.h"

@interface AwardedSenderDetail()
{
    IBOutlet UILabel *createdOn;
    IBOutlet UILabel *timeOn;
    IBOutlet UILabel *deliveryAdd;
    IBOutlet UILabel *parcelType;
    IBOutlet UIImageView *parcelImage;
    NSString *methodName;
    
    IBOutlet UITableView *tableview;
}
@end
@implementation AwardedSenderDetail
-(void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",self.dict);
    parcelImage.image=[UIImage imageNamed:[[AppDelegate getAppDelegate].imageArray objectAtIndex:[[AppDelegate getAppDelegate].labelArray indexOfObject:[[self.dict objectForKey:@"parcelType"] capitalizedString]]]];

    NSLog(@"%@",[self.navigationController viewControllers]);
    createdOn.text=[@"Awarded On: " stringByAppendingString:[self terminateTime:[self.dict objectForKey:@"awardDate"]]];
    [createdOn setAttributeText:NSMakeRange(0, 11)];
    
    timeOn.text=[@"Time: " stringByAppendingString:[self terminateDate:[self.dict objectForKey:@"awardDate"]]];
    [timeOn setAttributeText:NSMakeRange(0, 5)];
    
    deliveryAdd.text=[@"Delivery Add: " stringByAppendingString:[self.dict objectForKey:@"deliveryAddress"]];
    [deliveryAdd setAttributeText:NSMakeRange(0, 13)];
    
    parcelType.text=[[self.dict objectForKey:@"parcelType"] capitalizedString];
    
}
-(NSString *)terminateDate:(NSString *)date
{
    NSString *dateAndTime = date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] ];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //[dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *aDate = [dateFormatter dateFromString:dateAndTime];
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
#pragma mark-Table View Delegate & Datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
        return 154.0;
    else
        return 50.0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
        return 1;
    else
    {
        if(self.isOpenForDeliverer)
            return 3;
        else
            return 4;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        static NSString *CellIdentifier = @"AwardDetail";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        UIView *backGroundView=(UIView *)[cell.contentView viewWithTag:555];
        backGroundView.layer.cornerRadius=5.0;
        __weak  UIImageView *profilePicUser=(UIImageView *)[cell.contentView viewWithTag:1022];
        UILabel *userName=(UILabel *)[cell.contentView viewWithTag:1023];
        UILabel *bidLabel=(UILabel *)[cell.contentView viewWithTag:1025];
        //Add by Prankur
        UIButton *msgbtn= (UIButton *)[cell.contentView viewWithTag:1029];
        [msgbtn addTarget:self action:@selector(createdialog_chat:) forControlEvents:   UIControlEventTouchUpInside];
        TPFloatRatingView *ratingView=(TPFloatRatingView *)[cell.contentView viewWithTag:1026];
        UIButton *reviewBUtton=(UIButton *)[cell.contentView viewWithTag:1027];
        [reviewBUtton addTarget:self action:@selector(openReview:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *noteLabel=(UILabel *)[cell.contentView viewWithTag:1028];
        profilePicUser.layer.cornerRadius =30.0;
        profilePicUser.clipsToBounds = YES;
        profilePicUser.backgroundColor=greenColor;
        
        NSString *imageParam;
        if(self.isOpenForDeliverer)
            imageParam=@"userPic";
        else
            imageParam=@"profilePic";
        
        if(![self.dict[imageParam] isKindOfClass:[NSNull class]])
            [profilePicUser setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.dict[imageParam]]] placeholderImage:[UIImage imageNamed:@"myprofile.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                if(image)
                    profilePicUser.image=image;
                else
                    profilePicUser.image=[UIImage imageNamed:@"myprofile.png"];
                
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                
            }];
        else
            profilePicUser.image=[UIImage imageNamed:@"myprofile.png"];
        
        NSString *userNameParam;
        NSString *amountParam;
        NSString *amountTypeParam;
        NSString *ratingparam;
        if(self.isOpenForDeliverer)
        {
            userNameParam=@"userName";
            amountParam=@"price";
            amountTypeParam=@"paymentType";
            ratingparam=@"userRating";
        }
        else
        {
            userNameParam=@"price";
            amountParam=@"winningAmount";
            amountTypeParam=@"winningCurrencyType";
            ratingparam=@"ratings";

        }
        userName.text=self.dict[userNameParam];
        
        
        
        if(![self.dict[amountParam] isKindOfClass:[NSNull class]])
        {
            NSString *currencyType=@"";
            if([self.dict[amountTypeParam] isEqualToString:@"EUR"])
                currencyType=@"€";
            else if ([self.dict[amountTypeParam] isEqualToString:@"USD"])
                currencyType=@"$";
            else
                currencyType=@"£";
            
            bidLabel.text=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@ %@",currencyType,   self.dict[amountParam] ]];
        }
        else
            bidLabel.text=@"";
        
        
        if(![self.dict[ratingparam] isKindOfClass:[NSNull class]])
        {
            ratingView.emptySelectedImage = [UIImage imageNamed:@"StarEmpty"];
            ratingView.fullSelectedImage = [UIImage imageNamed:@"StarFull"];
            ratingView.contentMode = UIViewContentModeScaleAspectFill;
            ratingView.maxRating = 5;
            ratingView.minRating = 0;
            ratingView.rating = [self.dict[ratingparam] floatValue];
            ratingView.editable = NO;
            ratingView.halfRatings = YES;
            ratingView.floatRatings = YES;
        }

        NSArray *reviewArray=self.dict[@"review"];
        
        if(![self.dict[@"review"] isKindOfClass:[NSNull class]])
            [reviewBUtton setTitle:[NSString stringWithFormat:@"%lu Reviews",(unsigned long)reviewArray.count] forState:UIControlStateNormal];
        else
            [reviewBUtton setTitle:@"0 Reviews" forState:UIControlStateNormal];
        
        
//        if(![self.dict[@"notes"] isKindOfClass:[NSNull class]])
//            noteLabel.text=[NSString stringWithFormat:@"Notes: %@",self.dict[@"notes"]];
//        else
            noteLabel.text=@"Notes:";
        [noteLabel setAttributeText:NSMakeRange(0, 6)];

        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;

    }
    else
    {
        static NSString *CellIdentifier = @"ActionCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        UILabel *label=(UILabel *)[cell.contentView viewWithTag:1202];
        UIImageView *imageView=(UIImageView *)[cell.contentView viewWithTag:1203];
        if(indexPath.row==0)
        {
            label.text=@"Fee paid into escrow";
            
            if([self.dict[@"feePaid"] integerValue])
            {
                UIImage *image = [[UIImage imageNamed:@"check_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                imageView.image=image;
                imageView.tintColor =greenColor;

            }
            else
                imageView.image=[UIImage imageNamed:@"check_gray"];

        }
        else if(indexPath.row==1)
        {
            NSString *paramName;
            if(self.isOpenForDeliverer)
            {
                label.text=@"Item Recieved";
                paramName=@"itemGiven";
            }
            else
            {
                label.text=@"Item Given";
                paramName=@"itemRecieved";

            }
            if([self.dict[paramName] integerValue])
            {
                UIImage *image = [[UIImage imageNamed:@"check_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                imageView.image=image;
                imageView.tintColor =greenColor;

            }
            else
                imageView.image=[UIImage imageNamed:@"check_gray"];

        }
        else if(indexPath.row==2)
        {
            label.text=@"Item Delivered";
            if([self.dict[@"itemDelivered"] integerValue])
            {
                UIImage *image = [[UIImage imageNamed:@"check_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                imageView.image=image;
                imageView.tintColor =greenColor;
            }
            else
                imageView.image=[UIImage imageNamed:@"check_gray"];
        }
        else
        {
            label.text=@"Payment Completed";
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1)
    {
        if(self.isOpenForDeliverer)
        {
            if(indexPath.row==2&&[[self.dict objectForKey:@"itemGiven"] integerValue]==1)
            {
                [self activityPressed:indexPath];
            }
            else
            {
                [AppHelper showAlertViewWithTag:12121 title:App_Name message:@"Wait for item to be given by sender." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            }
            
            if(indexPath.row==1)
            {
                if(indexPath.row==2&&[[self.dict objectForKey:@"itemRecieved"] integerValue]==1&&[[self.dict objectForKey:@"itemDelivered"] integerValue]==0)
                {
                    [self activityPressed:indexPath];
                }
                else
                {
                    [AppHelper showAlertViewWithTag:12121 title:App_Name message:@"Recieve the item from sender to deliver." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                }

            }
        }
        else
        {
            if(indexPath.row==1&&[[self.dict objectForKey:@"itemGiven"] integerValue]==0)
            {
                [self activityPressed:indexPath];
            }
        }
    }
}
-(void)activityPressed:(id)sender
{
    UITableViewCell *cell=(UITableViewCell *)sender;
    NSIndexPath *indexPath=[tableview indexPathForCell:cell];
 
    if(indexPath.section==1)
    {
        if(self.isOpenForDeliverer)
        {
            if(indexPath.row==1)
            {
                methodName=@"itemReceived";
            }
            else if(indexPath.row==2)
            {
                methodName=@"itemDelivered";
            }
        }
        else
        {
            if(indexPath.row==1)
            {
                methodName=@"itemGiven";
            }
        }
        if([AppDelegate getAppDelegate].isNetworkReachable)
        {
            [[AppDelegate getAppDelegate] showLoadingView:@"Please wait..."];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleActivityResponse:) name:Activity_Notification object:nil];
            [[ServiceClass sharedServiceClass] activityPressed:[NSMutableDictionary dictionaryWithObject:self.dict[@"awardId"] forKey:@"awardId"] andMethodName:methodName];
        }
        else
        {
            [AppHelper showAlertViewWithTag:10101 title:App_Name message:@"Please check your internert connection." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        }

    }
    
}
-(void)handleActivityResponse:(NSNotification *)not
{
    if([methodName isEqualToString:@"itemReceived"])
    {
        [self.dict setObject:@"1" forKey:@"itemRecieved"];
        [tableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }
    else if ([methodName isEqualToString:@"itemDelivered"])
    {
        [self.dict setObject:@"1" forKey:@"itemDelivered"];
        [tableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];

    }
    else if ([methodName isEqualToString:@"itemGiven"])
    {
        [self.dict setObject:@"1" forKey:@"itemGiven"];
        [tableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==1)
        return 30;
    else
        return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==1)
    {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(9, 0,tableView.frame.size.width-18 , 30)];
        label.font=[UIFont systemFontOfSize:15.0];
        label.text=@"   ACTIVITIES";
        return label;
    }
    else
        return nil;
}
-(void)openReview:(id)sender
{
    if([self.dict[@"review"] count]>0)
    {
        [self performSegueWithIdentifier:@"OpenReviews" sender:self.dict[@"review"]];

    }
    else
    {
        [AppHelper showAlertViewWithTag:10101 title:App_Name message:@"No reviews for this user." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];

    }
    
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"newchatsegue"])
    {
        ConversationVC *destinationViewController = [[ConversationVC alloc]init];
        if(self.createdDialog != nil)
        {
            destinationViewController.dialog = self.createdDialog;
            self.createdDialog = nil;
            return YES;
        }
        else
        {
            return NO;
//            QBChatDialog *dialog = [ChatService shared].dialogs[((UITableViewCell *)sender).tag];
//            destinationViewController.dialog = dialog;
        }
        return YES;
    }
    return NO;
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if([segue.identifier isEqualToString:@"OpenReviews"])
//    {
//        [(ReviewsVC *)segue.destinationViewController setReviesArray:(NSArray *)sender];
//    }
//    else if([segue.identifier isEqualToString:@"newchatsegue"])
//    {
//        NSLog(@"perdsfjdahfghj");
//                ConversationVC *destinationViewController = (ConversationVC *)segue.destinationViewController;
//        if(self.createdDialog != nil)
//        {
//            destinationViewController.dialog = self.createdDialog;
//            self.createdDialog = nil;
//        }
//        else
//        {
//            QBChatDialog *dialog = [ChatService shared].dialogs[((UITableViewCell *)sender).tag];
//            destinationViewController.dialog = dialog;
//        }
//    }
//}



-(IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createdialog_chat:(id)sender
{
     QBChatDialog *chatDialog = [QBChatDialog new];
    NSMutableArray *selectedUsersIDs = [NSMutableArray array];
    [selectedUsersIDs addObject:(@"7166895")];
    chatDialog.occupantIDs = selectedUsersIDs;
    chatDialog.type = QBChatDialogTypePrivate;
    //__weak __typeof(self)weakSelf = self;
//    ConversationVC *destinationViewController = [[ConversationVC alloc]init];
//    if(self.createdDialog != nil)
//    {
//        destinationViewController.dialog = self.createdDialog;
//        self.createdDialog = nil;
//    }

    
    [QBRequest createDialog:chatDialog successBlock:^(QBResponse *response, QBChatDialog *createdDialog)
    {
        NSLog(@"%@",response);
        NSLog(@"%@",createdDialog.ID.description);
        if(createdDialog.type != QBChatDialogTypePrivate || [ChatService shared].dialogsAsDictionary[createdDialog.ID] == nil)
        {
            [[ChatService shared].dialogs insertObject:createdDialog atIndex:0];
            [[ChatService shared].dialogsAsDictionary setObject:createdDialog forKey:createdDialog.ID];
            self.createdDialog = createdDialog;
//            if ([self shouldPerformSegueWithIdentifier:@"newchatsegue" sender:nil])
//            {
                NSLog(@"%@",[self.navigationController viewControllers]);
                //ConversationVC *destinationViewController = [[ConversationVC alloc]init];
                UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ConversationVC  *ConversationVC_obj=[storyBoard instantiateViewControllerWithIdentifier: @"ConversationVC"];

                if(self.createdDialog != nil)
                {
                    //ConversationVC *destinationViewController = [[ConversationVC alloc]init];
                    ConversationVC_obj.dialog = self.createdDialog;
                    self.createdDialog = nil;
                }
                else
                {
                    QBChatDialog *dialog = [ChatService shared].dialogs[0];
                    ConversationVC_obj.dialog = dialog;
                }
                [self.navigationController pushViewController:ConversationVC_obj animated:YES];
        }
        else
        {
            createdDialog = [ChatService shared].dialogsAsDictionary[createdDialog.ID];
            self.createdDialog = createdDialog;
            UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ConversationVC  *ConversationVC_obj=[storyBoard instantiateViewControllerWithIdentifier: @"ConversationVC"];
            ConversationVC_obj.dialog = createdDialog;
            [self.navigationController pushViewController:ConversationVC_obj animated:YES];

            //  ConversationVC *conversation_obj = [[ConversationVC alloc]init];
            //  conversation_obj.dialog = createdDialog;
        }
        // and join it
        if(createdDialog.type != QBChatDialogTypePrivate)
        {
            [createdDialog setOnJoin:^()
            {
                NSLog(@"Dialog joined");
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGroupDialogJoined object:nil];
            }];
            [createdDialog setOnJoinFailed:^(NSError *error) {
                NSLog(@"Join Fail, error: %@", error);
            }];
            [createdDialog join];
        }
//        DialogsViewController *dialogsViewController = weakSelf.navigationController.viewControllers[0];
//        dialogsViewController.createdDialog = createdDialog;
//        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    } errorBlock:^(QBResponse *response) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors"
                                                        message:response.error.error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        [alert show];
        
    }];
}
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if([segue.destinationViewController isKindOfClass:ChatViewController.class]){
//        ChatViewController *destinationViewController = (ChatViewController *)segue.destinationViewController;
//        
//        if(self.createdDialog != nil){
//            destinationViewController.dialog = self.createdDialog;
//            self.createdDialog = nil;
//        }else{
//            QBChatDialog *dialog = [ChatService shared].dialogs[((UITableViewCell *)sender).tag];
//            destinationViewController.dialog = dialog;
//        }
//    }
//}



@end
