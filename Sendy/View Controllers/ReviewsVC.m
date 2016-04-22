//
//  ReviewsVC.m
//  Sendy
//
//  Created by Ishan Shikha on 25/10/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "ReviewsVC.h"

@implementation ReviewsVC

-(void)viewDidLoad
{
    [super viewDidLoad];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.reviesArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    

        static NSString *CellIdentifier = @"ReviewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        __weak  UIImageView *profilePicUser=(UIImageView *)[cell.contentView viewWithTag:1021];
        UILabel *userName=(UILabel *)[cell.contentView viewWithTag:1022];
        UILabel *dateLabel=(UILabel *)[cell.contentView viewWithTag:1023];
        UILabel *comments=(UILabel *)[cell.contentView viewWithTag:1024];
        
        
        
        profilePicUser.layer.cornerRadius =20.0;
        profilePicUser.clipsToBounds = YES;
        profilePicUser.backgroundColor=greenColor;
        
        
        NSDictionary *dict=[self.reviesArray objectAtIndex:indexPath.row];
        
        if(![dict[@"reviewProfilePic"] isKindOfClass:[NSNull class]])
            [profilePicUser setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dict[@"reviewProfilePic"]]] placeholderImage:[UIImage imageNamed:@"myprofile.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                if(image)
                    profilePicUser.image=image;
                else
                    profilePicUser.image=[UIImage imageNamed:@"myprofile.png"];
                
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                
            }];
        else
            profilePicUser.image=[UIImage imageNamed:@"myprofile.png"];
        
        userName.text=dict[@"reviewUserName"];
        
        dateLabel.text=[self terminateTime:dict[@"reviewDate"]];
        comments.text=dict[@"reviewText"];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
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
-(IBAction)backButtonPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
