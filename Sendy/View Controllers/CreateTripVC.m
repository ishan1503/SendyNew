//
//  HomeVC.m
//  Sendy
//
//  Created by Ishan Shikha on 21/06/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "CreateTripVC.h"
#import "NMBottomTabBar.h"
#import "LocationVC.h"
#import "TripListVC.h"
@interface CreateTripVC ()
{
    IBOutlet UITableView *tableview;
    CLLocationManager *locationManager;
    
    UIDatePicker *pickerView;
    UIView *dateAndTimeSlectorView;
    UIButton *dateButton;
    UIButton *timeButton;
    NSString *selectedDate;

}

@end

@implementation CreateTripVC
-(void)viewWillDisappear:(BOOL)animated
{

}
-(void)viewWillAppear:(BOOL)animated
{
    if([self.fromAddressDictioanry count]==0&&!self.tripInfo)
    {
        
        locationManager = [[CLLocationManager alloc] init];
        
        locationManager.delegate = self;
        
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]))
        {
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [locationManager requestAlwaysAuthorization];
            }
            else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"])
            {
                [locationManager  requestWhenInUseAuthorization];
            }
            else
            {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
        [locationManager startUpdatingLocation];

    }
    
    [tableview reloadData];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    dateAndTimeSlectorView=[[UIView alloc] initWithFrame:CGRectMake(0, -260, [[AppDelegate getAppDelegate] widthOfDevice],260)];
    if([self.tripInfo count]>0)
    {
        self.fromAddress=self.tripInfo[@"fromAddress"];
        self.fromAddressDictioanry=[NSDictionary dictionaryWithObjectsAndKeys:self.tripInfo[@"fromCountry"],@"Country",self.tripInfo[@"fromCity"],@"City",self.tripInfo[@"fromZip"],@"ZIP", nil];
        self.fromLocation=CLLocationCoordinate2DMake([self.tripInfo[@"fromlatitude"] floatValue], [self.tripInfo[@"fromLongitude"] floatValue]);

        self.toAddress=self.tripInfo[@"toAddress"];
        self.toAddressDictionary=[NSDictionary dictionaryWithObjectsAndKeys:self.tripInfo[@"toCountry"],@"Country",self.tripInfo[@"toCity"],@"City",self.tripInfo[@"toZip"],@"ZIP",nil];
        self.toLocation=CLLocationCoordinate2DMake([self.tripInfo[@"tolatitude"] floatValue], [self.tripInfo[@"toLongitude"] floatValue]);
        
        selectedDate=[self formatDateFromService:self.tripInfo[@"departureDate"]];
        
    }
    [tableview reloadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil)
    {
        
        [self getCurrentAddress:currentLocation];
        locationManager.delegate=nil;
    }
}
-(void)getCurrentAddress:(CLLocation *)location
{
    [[AppDelegate getAppDelegate] showLoadingView:@"Fetching current location..."];
    CLLocationCoordinate2D droppedAt = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    

    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:droppedAt.latitude longitude:droppedAt.longitude];
    
    [geoCoder reverseGeocodeLocation: loc completionHandler: ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
        NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
        [[AppDelegate getAppDelegate] hideLoadingView];
        CLLocationCoordinate2D location1;
        location1.latitude = location.coordinate.latitude;
        location1.longitude = location.coordinate.longitude;
        self.fromLocation=location1;
        self.fromAddress=locatedAt;
        self.fromAddressDictioanry=placemark.addressDictionary;
        [tableview reloadData];
    }];
    
}


#pragma mark-Table View Delegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0 || section==1)
        return 4;
    else
        return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HomeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeCell"];
    }
    UILabel *label=(UILabel *)[cell.contentView viewWithTag:10110];
    UITextField *textField=(UITextField *)[cell.contentView viewWithTag:10111];
    
    textField.userInteractionEnabled=NO;
    NSDictionary *dict=indexPath.section==0?self.fromAddressDictioanry:self.toAddressDictionary;
    
    dateButton=(UIButton *)[cell.contentView viewWithTag:789653];


    if(indexPath.section==0 || indexPath.section==1)
    {
        dateButton.hidden=YES;
        if(indexPath.row==0)
        {
            label.text=@"Country";
            textField.placeholder=label.text;
            textField.text=[dict objectForKey:@"Country"];
        }
        else if (indexPath.row==1)
        {
            label.text=@"City";
            textField.placeholder=label.text;
            textField.text=[[dict objectForKey:@"City"] length]>0?[dict objectForKey:@"City"]:[dict objectForKey:@"SubAdministrativeArea"];
        }
        else if (indexPath.row==2)
        {
            label.text=@"Zip";
            textField.placeholder=label.text;
            textField.text=[dict objectForKey:@"ZIP"];

        }
        else if (indexPath.row==3)
        {
            label.text=@"Address";
            textField.placeholder=label.text;
            textField.text=indexPath.section==0?self.fromAddress:self.toAddress;
        }
    }
    else
    {
        dateButton.hidden=NO;
        label.text=@"Trip Date";
        textField.hidden=YES;
        if(selectedDate.length>0)
            [dateButton setTitle:selectedDate forState:UIControlStateNormal];
        else
            [dateButton setTitle:@"Select Date" forState:UIControlStateNormal];
        [dateButton addTarget:self action:@selector(createDatePickerwithModedDateOnly:) forControlEvents:UIControlEventTouchUpInside];
    }
        
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(IS_IPHONE_4_OR_LESS)
        return 35.0;
    else
        return 40.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{

        if(IS_IPHONE_4_OR_LESS)
            return 25.0;
        else
            return 30.0;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40.0)];

        headerView.backgroundColor=[UIColor colorWithRed:(229.0/255.0) green:(229.0/255.0) blue:(229.0/255.0) alpha:1.0];
        
        
        
        UILabel *HeaderLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 4, 100, 22)];
        HeaderLabel.font=[UIFont systemFontOfSize:15.0];
        
        UIImageView *arrowImage=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 5, 20, 20)];
        arrowImage.image=[UIImage imageNamed:@"arrowbottom.png"];
        
        UIButton *changeButton=[UIButton buttonWithType:UIButtonTypeCustom];
        changeButton.frame=CGRectMake(SCREEN_WIDTH-100, 5, 60, 20);
        [changeButton setTitleColor:[UIColor colorWithRed:(49.0/255.0) green:(174.0/255.0) blue:(153.0/255.0) alpha:1.0] forState:UIControlStateNormal];
        changeButton.titleLabel.font=[UIFont systemFontOfSize:14.0];
        [changeButton addTarget:self action:@selector(changeButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        
        if(section==0)
        {
            changeButton.tag=2001;
            HeaderLabel.text=@"From";
            if(self.fromAddressDictioanry.count==0)
                [changeButton setTitle:@"Map" forState:UIControlStateNormal];
            else
                [changeButton setTitle:@"Change" forState:UIControlStateNormal];
            
        }
        else if(section==1)
        {
            changeButton.tag=2002;
            HeaderLabel.text=@"To";
            if(self.toAddressDictionary.count==0)
                [changeButton setTitle:@"Map" forState:UIControlStateNormal];
            else
                [changeButton setTitle:@"Change" forState:UIControlStateNormal];
        }
        else
        {
            changeButton.hidden=YES;
            HeaderLabel.text=@"Date";

        }
        [headerView addSubview:HeaderLabel];
        [headerView addSubview:arrowImage];
        [headerView addSubview:changeButton];

    return headerView;

}
-(IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)changeButtonPress:(id)sender
{
    UIButton *changeButton=(UIButton *)sender;
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LocationVC *obj=[storyBoard instantiateViewControllerWithIdentifier:@"LocationVC"];
    obj.creteTripVC=self;
    
    if(changeButton.tag==2001)
    {
        obj.address=self.fromAddress;
        obj.isOPenForTo=NO;
        
    }
    else
    {
        obj.address=self.toAddress;
        obj.isOPenForTo=YES;
    }
    
    [self.navigationController presentViewController:obj animated:YES completion:nil];

}
-(IBAction)nextButtonPress:(id)sender
{
    if([AppDelegate getAppDelegate].isNetworkReachable)
    {
        if([self.fromAddressDictioanry[@"Country"] length]==0)
            [AppHelper showAlertViewWithTag:10101 title:App_Name message:@"From country should not be blank" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else if ([self.fromAddressDictioanry[@"City"] length]==0&&[[self.fromAddressDictioanry objectForKey:@"SubAdministrativeArea"] length]==0)
            [AppHelper showAlertViewWithTag:10101 title:App_Name message:@"From city should not be blank" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else if ([self.fromAddressDictioanry[@"ZIP"] length]==0)
            [AppHelper showAlertViewWithTag:10101 title:App_Name message:@"From zip should not be blank" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else if ([self.fromAddressDictioanry[@"FormattedAddressLines"] count]==0&&!self.tripInfo)
            [AppHelper showAlertViewWithTag:10101 title:App_Name message:@"From address should not be blank" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else if (self.fromAddress.length==0&&self.tripInfo)
            [AppHelper showAlertViewWithTag:10101 title:App_Name message:@"From address should not be blank" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else if([self.toAddressDictionary[@"Country"] length]==0)
            [AppHelper showAlertViewWithTag:10101 title:App_Name message:@"To country should not be blank" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else if ([self.toAddressDictionary[@"City"] length]==0 &&[[self.toAddressDictionary objectForKey:@"SubAdministrativeArea"] length]==0)
            [AppHelper showAlertViewWithTag:10101 title:App_Name message:@"To city should not be blank" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else if ([self.toAddressDictionary[@"ZIP"] length]==0)
            [AppHelper showAlertViewWithTag:10101 title:App_Name message:@"To zip should not be blank" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else if ([self.toAddressDictionary[@"FormattedAddressLines"] count]==0&&!self.tripInfo)
            [AppHelper showAlertViewWithTag:10101 title:App_Name message:@"To address should not be blank" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else if (self.toAddress.length==0&&self.tripInfo)
            [AppHelper showAlertViewWithTag:10101 title:App_Name message:@"To address should not be blank" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else if ([selectedDate isEqualToString:@"Select Date"]||selectedDate.length==0)
            [AppHelper showAlertViewWithTag:10101 title:App_Name message:@"Trip date should not be blank" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else
        {
            NSMutableDictionary *paramDict=[NSMutableDictionary dictionary];
            [paramDict setObject:UserID forKey:@"userId"];
            
            [paramDict setObject:self.fromAddressDictioanry[@"Country"] forKey:@"fromCountry"];
            if([self.fromAddressDictioanry[@"City"] length]>0)
                [paramDict setObject:self.fromAddressDictioanry[@"City"] forKey:@"fromCity"];
            else
                [paramDict setObject:self.fromAddressDictioanry[@"SubAdministrativeArea"] forKey:@"fromCity"];
            
            [paramDict setObject:self.fromAddressDictioanry[@"ZIP"] forKey:@"fromZip"];
            [paramDict setObject:self.fromAddress forKey:@"fromAddress"];
            [paramDict setObject:[NSString stringWithFormat:@"%f",self.fromLocation.latitude] forKey:@"fromLat"];
            [paramDict setObject:[NSString stringWithFormat:@"%f",self.fromLocation.longitude] forKey:@"fromLong"];
            
            [paramDict setObject:self.toAddressDictionary[@"Country"] forKey:@"toCountry"];
            
            if([self.toAddressDictionary[@"City"] length]>0)
                [paramDict setObject:self.toAddressDictionary[@"City"] forKey:@"toCity"];
            else
                [paramDict setObject:self.toAddressDictionary[@"SubAdministrativeArea"] forKey:@"toCity"];
            
            [paramDict setObject:self.toAddressDictionary[@"ZIP"] forKey:@"toZip"];
            [paramDict setObject:self.toAddress forKey:@"toAddress"];
            [paramDict setObject:[NSString stringWithFormat:@"%f",self.toLocation.latitude] forKey:@"toLat"];
            [paramDict setObject:[NSString stringWithFormat:@"%f",self.toLocation.longitude] forKey:@"toLong"];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCraeteTripResponse:) name:CreateTrip_Notification object:nil];

            if(!self.tripInfo)
            {
                [paramDict setObject:[AppHelper getUTCFormateDate:[AppHelper convertdate:[self formatDateForService:selectedDate] andtime:@""]] forKey:@"departureDate"];
                [[ServiceClass sharedServiceClass] createTripWithDictionary:paramDict];
            }
            else
            {
                [paramDict setObject:[AppHelper getUTCFormateDate:[AppHelper convertdate:[self formatDateForService:selectedDate] andtime:@""]] forKey:@"departureDate"];
                [paramDict setObject:[self.tripInfo objectForKey:@"tripId"] forKey:@"tripId"];
                [[ServiceClass sharedServiceClass] editTripWithDictionary:paramDict];

            }
        }

    }
    else
    {
        [AppHelper showAlertViewWithTag:1211 title:App_Name message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    
  }
-(void)handleCraeteTripResponse:(NSNotification *)not
{
    [[AppDelegate getAppDelegate] hideLoadingView];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CreateTrip_Notification object:nil];
    
    NSString *message;
    
    if(self.tripInfo)
    {
        message=@"Trip sucessfully updated.";
        TripListVC *obj=(TripListVC *)[[self.navigationController viewControllers] objectAtIndex:[self.navigationController viewControllers].count-2];
        [obj getTrips];
    }
    else
        message=@"Trip sucessfully created.";
    
    [AppHelper showAlertViewWithTag:11111 title:App_Name message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (11111&&buttonIndex==alertView.cancelButtonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(IBAction)createDatePickerwithModedDateOnly:(id)sender
{
    [self doneButtonPressed:nil];
   // UIButton *button=(UIButton *)sender;
    if(dateAndTimeSlectorView.frame.origin.y==260)
        dateAndTimeSlectorView.frame=CGRectMake(0, -260, [[AppDelegate getAppDelegate] widthOfDevice],260);
    else
        dateAndTimeSlectorView.frame=CGRectMake(0, 260, [[AppDelegate getAppDelegate] widthOfDevice],260);
    
    if(!pickerView)
    {
        dateAndTimeSlectorView.backgroundColor=[UIColor whiteColor];
        
        UIToolbar *pickerToolbar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [[AppDelegate getAppDelegate] widthOfDevice], 44)];
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
        [barItems addObject:flexSpace];
        
        [barItems addObject:doneBtn];
        [barItems addObject:flexSpace];
        [barItems addObject:cancelBtn];
        [barItems addObject:flexSpace];
        
        [pickerToolbar setItems:barItems animated:YES];
        
        
        pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44,[[AppDelegate getAppDelegate] widthOfDevice], 216)];
        [pickerView addTarget:self action:@selector(datePickerDateChanged:) forControlEvents:UIControlEventValueChanged];
        [dateAndTimeSlectorView addSubview:pickerToolbar];
        [dateAndTimeSlectorView addSubview:pickerView];
        pickerView.minimumDate=[NSDate date];
        [self.view addSubview:dateAndTimeSlectorView];
    }
    if(selectedDate)
    {
        [pickerView setDate:[AppHelper convertdate:[self formatDateForService:selectedDate] andtime:@""]];
    }
    pickerView.datePickerMode = UIDatePickerModeDateAndTime;
    pickerView.hidden = NO;
    [tableview setContentOffset:CGPointMake(tableview.contentOffset.x, 250) animated:YES];
}
- (void)datePickerDateChanged:(UIDatePicker *)paramDatePicker
{
    //dd-MM-yyyy
    NSDateFormatter *FormatDate = [[NSDateFormatter alloc] init];
    [FormatDate setLocale: [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [FormatDate setDateFormat:@"dd-MM-yyyy HH:mm"];
    selectedDate=[FormatDate stringFromDate:[paramDatePicker date]];
    [tableview reloadData];
    
}

-(void)doneButtonPressed:(id)sender
{
    dateAndTimeSlectorView.frame=CGRectMake(0, -260, [[AppDelegate getAppDelegate] widthOfDevice],260);
    [tableview setContentOffset:CGPointMake(tableview.contentOffset.x, 0) animated:YES];
    
}

-(void)cancelButtonPressed:(id)sender{
    dateAndTimeSlectorView.frame=CGRectMake(0, -260, [[AppDelegate getAppDelegate] widthOfDevice],260);
    [tableview setContentOffset:CGPointMake(tableview.contentOffset.x, 0) animated:YES];
    
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
-(NSString *)formatDateFromService:(NSString *)date
{
    NSString *dateAndTime = date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] ];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //[dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate   *aDate = [dateFormatter dateFromString:dateAndTime];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *dateString = [dateFormatter2 stringFromDate:aDate];
    return dateString;
    
}
-(NSString *)formatDateForService:(NSString *)date
{
    NSString *dateAndTime = date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] ];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];

    //[dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate   *aDate = [dateFormatter dateFromString:dateAndTime];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter2 stringFromDate:aDate];
    return dateString;
    
}

@end
