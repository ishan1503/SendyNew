//
//  OfferDeliveryVC.m
//  Sendy
//
//  Created by Ishan Shikha on 05/07/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "CreateItemVC.h"
#import "TLTagsControl.h"
#import "LocationVC.h"
#import "ParcelOptionVC.h"
@interface CreateItemVC ()
{
   
    IBOutlet UITableView *tableview;
    float weight;
    float width;
    float height;
    float length;
    IBOutlet UISegmentedControl *weightSegment;
    IBOutlet UISegmentedControl *widthSegment;
    IBOutlet UISegmentedControl *lengthSegment;
    IBOutlet UISegmentedControl *heightSegment;
    IBOutlet UIButton *changeParcelType;
    UIDatePicker *pickerView;
    UIView *dateAndTimeSlectorView;
    UIButton *dateButton;
    UIButton *timeButton;
    
    IBOutlet UISegmentedControl *weightOptionSegment;
    IBOutlet UISegmentedControl *spaceOptionSegment;
    
    IBOutlet  UIButton *submitButton;
    IBOutlet UIImageView *parcelTypeImageView;
    IBOutlet UILabel *parcelTypeNameLabel;
    
}
@end

@implementation CreateItemVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    dateAndTimeSlectorView=[[UIView alloc] initWithFrame:CGRectMake(0, -260, [[AppDelegate getAppDelegate] widthOfDevice],260)];
    weight=0.0;
    width=0.0;
    height=0.0;
    length=0.0;
    // Do any additional setup after loading the view.
    changeParcelType.hidden=YES;
    if(self.itemInfo)
    {
        self.parcelTypeName=self.itemInfo[@"parcelType"];
        self.parcelTypeImageName=[self getParcelImageByName:self.parcelTypeName];
        self.fromAddress=self.itemInfo[@"fromAddress"];
        self.toAddress=self.itemInfo[@"toAddress"];
        self.toAddressLocation=CLLocationCoordinate2DMake([self.itemInfo[@"toLat"] floatValue], [self.itemInfo[@"toLong"] floatValue]);
        self.fromAddressLocation=CLLocationCoordinate2DMake([self.itemInfo[@"fromLat"] floatValue], [self.itemInfo[@"fromLong"] floatValue]);
        weight=[self.itemInfo[@"weightValue"] floatValue];
        width=[self.itemInfo[@"width"] floatValue];
        height=[self.itemInfo[@"height"] floatValue];
        length=[self.itemInfo[@"length"] floatValue];
        
        self.fromAddressDictioanry=[NSDictionary dictionaryWithObjectsAndKeys:self.itemInfo[@"fromCountry"],@"Country",self.itemInfo[@"fromCity"],@"City",self.itemInfo[@"fromZip"],@"ZIP", nil];
        self.toAddressDictioanry=[NSDictionary dictionaryWithObjectsAndKeys:self.itemInfo[@"toCountry"],@"Country",self.itemInfo[@"toCity"],@"City",self.itemInfo[@"toZip"],@"ZIP",nil];
        changeParcelType.hidden=NO;
    }
    
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGesture];
    
}
-(NSString *)getParcelImageByName:(NSString *)parcelName
{
    NSInteger index=[[AppDelegate getAppDelegate].labelArray indexOfObject:parcelName];
    if(index<[AppDelegate getAppDelegate].imageArray.count)
        return [[AppDelegate getAppDelegate].imageArray objectAtIndex:index];
    else
        return nil;
}
-(void)viewWillAppear:(BOOL)animated
{
    [tableview reloadData];
    parcelTypeNameLabel.text=self.parcelTypeName;
    parcelTypeImageView.image=[UIImage imageNamed:self.parcelTypeImageName];

}
#pragma mark-Gesture Delegates and Selectors
-(void)handleTap:(UITapGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)ChangeParcelType:(id)sender
{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ParcelOptionVC *bidVC=[storyBoard instantiateViewControllerWithIdentifier:@"ParcelOptionVC"];
    bidVC.createItemVC=self;
    [self.navigationController pushViewController:bidVC animated:YES];
}
-(IBAction)backButtonPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)addButtonClicked:(id)sender
{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:App_Name
                                                          message:@"Enter Stops" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    myAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[myAlertView textFieldAtIndex:0] becomeFirstResponder];
    [myAlertView show];
}
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag==101145)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(indexPath.row==0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell4" forIndexPath:indexPath];
        cell.contentView.backgroundColor=[UIColor clearColor];
        
        UIButton *fromButton=(UIButton *)[cell.contentView viewWithTag:8790];
        [fromButton addTarget:self action:@selector(fromButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *toButton=(UIButton *)[cell.contentView viewWithTag:8791];
        [toButton addTarget:self action:@selector(toButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *fromLabel=(UILabel *)[cell.contentView viewWithTag:1503];
        if(self.fromAddress.length>0)
            fromLabel.text=self.fromAddress;
        
        UILabel *toLabel=(UILabel *)[cell.contentView viewWithTag:1504];
        if(self.toAddress.length>0)
            toLabel.text=self.toAddress;

    }

    else if(indexPath.row==1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.contentView.backgroundColor=[UIColor clearColor];
        
        UIView *backgroundView=(UIView *)[cell.contentView viewWithTag:1021];
        backgroundView.layer.cornerRadius = 5.0;
        backgroundView.clipsToBounds = YES;
        backgroundView.layer.borderWidth = 0.0f;
        
        
        UILabel *weightLabel=(UILabel *)[cell.contentView viewWithTag:1022];
        weightLabel.text=[NSString stringWithFormat:@"%0.1f",weight];
        
        weightSegment =(UISegmentedControl *)[cell.contentView viewWithTag:12345];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touched:)];
        [weightSegment addGestureRecognizer:tap];
        
        weightOptionSegment =(UISegmentedControl *)[cell.contentView viewWithTag:54321];
        if(self.itemInfo)
        {
            if([self.itemInfo[@"weightType"] isEqualToString:@"Kg"])
                [weightOptionSegment setSelectedSegmentIndex:0];
            else if([self.itemInfo[@"weightType"] isEqualToString:@"Gm"]||[self.itemInfo[@"weightType"] isEqualToString:@"Gms"]||[self.itemInfo[@"weightType"] isEqualToString:@"gm"]||[self.itemInfo[@"weightType"] isEqualToString:@"gms"]||[self.itemInfo[@"weightType"] isEqualToString:@"G"]||[self.itemInfo[@"weightType"] isEqualToString:@"g"])
                [weightOptionSegment setSelectedSegmentIndex:1];
            else
                [weightOptionSegment setSelectedSegmentIndex:2];
        }
    }
    else if(indexPath.row==2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        cell.contentView.backgroundColor=[UIColor clearColor];
        
        UIView *backgroundView=(UIView *)[cell.contentView viewWithTag:1021];
        backgroundView.layer.cornerRadius = 5.0;
        backgroundView.clipsToBounds = YES;
        backgroundView.layer.borderWidth = 0.0f;
        
        spaceOptionSegment =(UISegmentedControl *)[cell.contentView viewWithTag:8765];
        
        widthSegment =(UISegmentedControl *)[cell.contentView viewWithTag:8766];
        UITapGestureRecognizer *tap3=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touched:)];
        [widthSegment addGestureRecognizer:tap3];
        
        lengthSegment =(UISegmentedControl *)[cell.contentView viewWithTag:8767];
        UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touched:)];
        [lengthSegment addGestureRecognizer:tap1];
        
        heightSegment =(UISegmentedControl *)[cell.contentView viewWithTag:8768];
        UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touched:)];
        [heightSegment addGestureRecognizer:tap2];
        
        UILabel *widthLabel=(UILabel *)[cell.contentView viewWithTag:8769];
        widthLabel.text=[NSString stringWithFormat:@"%0.1f",width];
        
        UILabel *lengthLabel=(UILabel *)[cell.contentView viewWithTag:8770];
        lengthLabel.text=[NSString stringWithFormat:@"%0.1f",length];
        
        UILabel *heightLabel=(UILabel *)[cell.contentView viewWithTag:8771];
        heightLabel.text=[NSString stringWithFormat:@"%0.1f",height];
        
        if(self.itemInfo)
        {
            if([self.itemInfo[@"spaceType"] isEqualToString:@"Inch"])
                [weightOptionSegment setSelectedSegmentIndex:0];
            else
                [weightOptionSegment setSelectedSegmentIndex:2];
        }

    }
    else if(indexPath.row==3)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
        cell.contentView.backgroundColor=[UIColor clearColor];
        
        UIView *backgroundView=(UIView *)[cell.contentView viewWithTag:12345];
        backgroundView.layer.cornerRadius = 5.0;
        backgroundView.clipsToBounds = YES;
        backgroundView.layer.borderWidth = 0.0f;
        
        dateButton=(UIButton *)[cell.contentView viewWithTag:12222];
        timeButton=(UIButton *)[cell.contentView viewWithTag:12223];
        if(self.itemInfo)
        {
            [dateButton setTitle:[self terminateTime:[self formatDateFromService:self.itemInfo[@"delieveryDate"]]] forState:UIControlStateNormal];
            [timeButton setTitle:[self terminateDate:[self formatDateFromService:self.itemInfo[@"delieveryDate"]]] forState:UIControlStateNormal];

        }
      
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==1||indexPath.row==0)
        return 130.0;
    else if(indexPath.row==2)
        return 250.0;
    else
        return 90.0;
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
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate   *aDate = [dateFormatter dateFromString:dateAndTime];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter2 stringFromDate:aDate];
    return dateString;
    
}
-(NSString *)terminateDate:(NSString *)date
{
    NSString *dateAndTime = date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] ];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
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
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    //[dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate   *aDate = [dateFormatter dateFromString:dateAndTime];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString = [dateFormatter2 stringFromDate:aDate];
    return dateString;
    
}
-(void)fromButtonClicked:(id)sender
{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LocationVC *obj=[storyBoard instantiateViewControllerWithIdentifier:@"LocationVC"];
    obj.createItemVC=self;
    obj.address=self.fromAddress;
    obj.isOPenForTo=NO;
    [self.navigationController presentViewController:obj animated:YES completion:nil];
    
}
-(void)toButtonClicked:(id)sender
{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LocationVC *obj=[storyBoard instantiateViewControllerWithIdentifier:@"LocationVC"];
    obj.createItemVC=self;
    obj.address=self.toAddress;
    obj.isOPenForTo=YES;
    [self.navigationController presentViewController:obj animated:YES completion:nil];

}

- (void)touched:(UITapGestureRecognizer *) tapGesture {
    
    UISegmentedControl *segmentCOntrol=(UISegmentedControl *)tapGesture.view;
    CGPoint point = [tapGesture locationInView:segmentCOntrol];
    NSUInteger segmentSize = segmentCOntrol.bounds.size.width /segmentCOntrol.numberOfSegments;
    NSUInteger touchedSegment = point.x / segmentSize;
        segmentCOntrol.selectedSegmentIndex = touchedSegment;
    if(segmentCOntrol==weightSegment)
        [self weightSegmentPressed:segmentCOntrol];
    else
        [self spaceSegmentPressed:segmentCOntrol];
  
}
-(IBAction)spaceSegmentPressed:(id)sender
{
    UISegmentedControl *segmentControl=(UISegmentedControl *)sender;
    if(segmentControl==widthSegment)
    {
        if(segmentControl.selectedSegmentIndex==0)
            width=width+0.5;
        else
        {
            if(width>0)
                width=width-0.5;
        }
        UITableViewCell *cell=(UITableViewCell *)[[[segmentControl superview] superview] superview];
        UILabel *weightLabel=(UILabel *)[cell.contentView viewWithTag:8769];
        weightLabel.text=[NSString stringWithFormat:@"%0.1f",width];

    }
    else if(segmentControl==lengthSegment)
    {
        if(segmentControl.selectedSegmentIndex==0)
            length=length+0.5;
        else
        {
            if(length>0)
                length=length-0.5;
        }
        UITableViewCell *cell=(UITableViewCell *)[[[segmentControl superview] superview] superview];
        UILabel *weightLabel=(UILabel *)[cell.contentView viewWithTag:8770];
        weightLabel.text=[NSString stringWithFormat:@"%0.1f",length];

    }
    else
    {
        if(segmentControl.selectedSegmentIndex==0)
            height=height+0.5;
        else
        {
            if(height>0)
                height=height-0.5;
        }
        UITableViewCell *cell=(UITableViewCell *)[[[segmentControl superview] superview] superview];
        UILabel *weightLabel=(UILabel *)[cell.contentView viewWithTag:8771];
        weightLabel.text=[NSString stringWithFormat:@"%0.1f",height];
    }
 
}

-(IBAction)weightSegmentPressed:(id)sender
{
    UISegmentedControl *segmentControl=(UISegmentedControl *)sender;
    if(segmentControl.selectedSegmentIndex==0)
        weight=weight+0.5;
    else
    {
        if(weight>0)
            weight=weight-0.5;
    }
    UITableViewCell *cell=(UITableViewCell *)[[[segmentControl superview] superview] superview];
    UILabel *weightLabel=(UILabel *)[cell.contentView viewWithTag:1022];
    weightLabel.text=[NSString stringWithFormat:@"%0.1f",weight];
}
-(IBAction)createTripPressed:(id)sender
{
   // NSLog(@"%@",self.fromAddressDictioanry);
    if([AppDelegate getAppDelegate].isNetworkReachable)
    {
        NSString *weightType;
        NSString *spaceType;
        
        if(weightOptionSegment.selectedSegmentIndex==0)
            weightType=@"K";
        else if(weightOptionSegment.selectedSegmentIndex==1)
            weightType=@"G";
        else if(weightOptionSegment.selectedSegmentIndex==2)
            weightType=@"L";
        
        if(spaceOptionSegment.selectedSegmentIndex==0)
            spaceType=@"I";
        else
            spaceType=@"C";
        
        if(self.fromAddress.length==0)
            [AppHelper showAlertViewWithTag:1002 title:App_Name message:@"From address should not be blank." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else if (self.toAddress.length==0)
            [AppHelper showAlertViewWithTag:1002 title:App_Name message:@"To address should not be blank." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else if (weight==0.0)
            [AppHelper showAlertViewWithTag:1002 title:App_Name message:@"Weight should not be zero." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else if (width==0.0)
            [AppHelper showAlertViewWithTag:1002 title:App_Name message:@"Width should not be zero." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else if (length==0.0)
            [AppHelper showAlertViewWithTag:1002 title:App_Name message:@"Length should not be zero." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else if (height==0.0)
            [AppHelper showAlertViewWithTag:1002 title:App_Name message:@"Height should not be zero." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else if ([dateButton.titleLabel.text isEqualToString:@"Select Date"])
            [AppHelper showAlertViewWithTag:10101 title:App_Name message:@"Date should not be blank" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else if ([timeButton.titleLabel.text isEqualToString:@"Select Time"])
            [AppHelper showAlertViewWithTag:10101 title:App_Name message:@"Time should not be blank" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        else
        {

            
            NSMutableDictionary *dict=[NSMutableDictionary dictionary];
            
            [dict setObject:UserID forKey:@"userId"];
            [dict setObject:self.fromAddressDictioanry[@"Country"] forKey:@"fromCountry"];
            
            [[self.fromAddressDictioanry objectForKey:@"City"] length]>0?[dict setObject:self.fromAddressDictioanry[@"City"] forKey:@"fromCity"]:[dict setObject:self.fromAddressDictioanry[@"SubAdministrativeArea"] forKey:@"fromCity"];
            [dict setObject:self.fromAddressDictioanry[@"ZIP"] forKey:@"fromZip"];
            [dict setObject:self.fromAddress forKey:@"fromAddress"];
            [dict setObject:self.toAddressDictioanry[@"Country"] forKey:@"toCountry"];
            
            [[self.toAddressDictioanry objectForKey:@"City"] length]>0?[dict setObject:self.toAddressDictioanry[@"City"] forKey:@"toCity"]:[dict setObject:self.toAddressDictioanry[@"SubAdministrativeArea"] forKey:@"toCity"];
            [dict setObject:self.toAddressDictioanry[@"ZIP"] forKey:@"toZip"];
            [dict setObject:self.toAddress forKey:@"toAddress"];
            [dict setObject:weightType forKey:@"weightType"];
            [dict setObject:[NSString stringWithFormat:@"%f",weight] forKey:@"weightValue"];
            [dict setObject:spaceType forKey:@"spaceType"];
            [dict setObject:[NSString stringWithFormat:@"%f",width] forKey:@"width"];
            [dict setObject:[NSString stringWithFormat:@"%f",length] forKey:@"length"];
            [dict setObject:[NSString stringWithFormat:@"%f",height] forKey:@"height"];
            [dict setObject:self.parcelTypeName forKey:@"parcelType"];
            [dict setObject:[NSString stringWithFormat:@"%f",self.fromAddressLocation.latitude] forKey:@"fromLat"];
            [dict setObject:[NSString stringWithFormat:@"%f",self.fromAddressLocation.longitude] forKey:@"fromLong"];
            [dict setObject:[NSString stringWithFormat:@"%f",self.toAddressLocation.latitude] forKey:@"toLat"];
            [dict setObject:[NSString stringWithFormat:@"%f",self.fromAddressLocation.longitude] forKey:@"toLong"];
            
            if(!self.itemInfo)
            {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemCreatedResponse:) name:Item_Created_Notification object:nil];
                NSString *date=[[dateButton.titleLabel.text stringByAppendingString:@" "] stringByAppendingString:timeButton.titleLabel.text];
                [dict setObject:[AppHelper getUTCFormateDate:[AppHelper convertdate:[self formatDateForService:date] andtime:@""]] forKey:@"delieveryDate"];
                [[ServiceClass sharedServiceClass] createItemDictionary:dict];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemCreatedResponse:) name:Item_Updated_Notification object:nil];
                NSString *date=[[dateButton.titleLabel.text stringByAppendingString:@" "] stringByAppendingString:timeButton.titleLabel.text];
                [dict setObject:[AppHelper getUTCFormateDate:[AppHelper convertdate:[self formatDateForService:date] andtime:@""]] forKey:@"delieveryDate"];
                [dict setObject:self.itemInfo[@"id"] forKey:@"itemId"];
                [[ServiceClass sharedServiceClass] editItemDictionary:dict];
            }
        }
    }
    else
    {
        [AppHelper showAlertViewWithTag:10114566 title:App_Name message:@"Please check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
}
-(void)itemCreatedResponse:(NSNotification *)notif
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Item_Created_Notification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Item_Updated_Notification object:nil];

    NSString *msg;
    if(self.itemInfo)
        msg=@"Item updated successfully";
    else
        msg=@"Item successfully created";
    [AppHelper showAlertViewWithTag:101145 title:App_Name message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
}
-(IBAction)createDatePickerwithModedDateOnly:(id)sender
{
    [self doneButtonPressed:nil];
    UIButton *button=(UIButton *)sender;
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
        pickerView.minimumDate=[NSDate date];
        [dateAndTimeSlectorView addSubview:pickerView];
        [self.view addSubview:dateAndTimeSlectorView];
    }
    if(self.itemInfo)
    {
        
        [pickerView setDate:[AppHelper convertdate:[self formatDateForService:[self formatDateFromService:self.itemInfo[@"delieveryDate"]]] andtime:@""]];
    }

    if(button.tag==12222)
        pickerView.datePickerMode = UIDatePickerModeDate;
    else
        pickerView.datePickerMode = UIDatePickerModeTime;
    pickerView.hidden = NO;

    [tableview setContentOffset:CGPointMake(tableview.contentOffset.x, 450) animated:YES];
}
- (void)datePickerDateChanged:(UIDatePicker *)paramDatePicker
{
    //BOOL isValidEntry;
    NSDateFormatter *FormatDate = [[NSDateFormatter alloc] init];
    [FormatDate setLocale: [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    if( paramDatePicker.datePickerMode==UIDatePickerModeDate)
    {
       [FormatDate setDateFormat:@"yyyy-MM-dd"];
        [dateButton setTitle:[FormatDate stringFromDate:[paramDatePicker date]] forState:UIControlStateNormal];
    }
    else
    {
        [FormatDate setDateFormat:@"HH:mm"];
        [timeButton setTitle:[FormatDate stringFromDate:[paramDatePicker date]] forState:UIControlStateNormal];

    }
}

-(void)doneButtonPressed:(id)sender
{
    dateAndTimeSlectorView.frame=CGRectMake(0, -260, [[AppDelegate getAppDelegate] widthOfDevice],260);
    [tableview setContentOffset:CGPointMake(tableview.contentOffset.x, 250) animated:YES];

}

-(void)cancelButtonPressed:(id)sender{
    dateAndTimeSlectorView.frame=CGRectMake(0, -260, [[AppDelegate getAppDelegate] widthOfDevice],260);
    [tableview setContentOffset:CGPointMake(tableview.contentOffset.x, 250) animated:YES];

}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"Enter Notes"])
        textView.text=@"";
    [tableview setContentOffset:CGPointMake(tableview.contentOffset.x, 480) animated:YES];
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [tableview setContentOffset:CGPointMake(tableview.contentOffset.x, 300) animated:YES];
    if(textView.text.length==0)
        textView.text=@"Enter Notes";
    return YES;

}
@end
