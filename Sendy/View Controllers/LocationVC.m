//
//  LocationVC.m
//  EventApp
//
//  Created by Ishan Gupta on 14/12/14.
//  Copyright (c) 2014 Ishan Gupta. All rights reserved.
//

#import "LocationVC.h"
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "AppHelper.h"
#import "Define.h"
#import <CoreLocation/CoreLocation.h>
@interface LocationVC ()


@end

@implementation LocationVC
{
    IBOutlet MKMapView *mapview;
    MKPointAnnotation *point ;
    IBOutlet UISearchBar *searchBar;
    MKAnnotationView *MyPin;
    CLLocationManager *locationManager;
}

@synthesize createItemVC,location1,address,creatsenditem2obj;
-(void)viewWillDisappear:(BOOL)animated
{
    locationManager=nil;
    locationManager.delegate=nil;
}
-(IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if(self.address.length>0)
    {
        searchBar.text=self.address;
        [self geoCodeUsingAddress:self.address];
    }
    else
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
    [[AppDelegate getAppDelegate] showLoadingView:@"Fetching Address..."];
    CLLocationCoordinate2D droppedAt = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:droppedAt.latitude longitude:droppedAt.longitude];
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error)
     {
         [[AppDelegate getAppDelegate] hideLoadingView];
         
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
       
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         
         if(point)
             [mapview removeAnnotation:point];
         location1.latitude = location.coordinate.latitude;
         location1.longitude = location.coordinate.longitude;
         
         point = [[MKPointAnnotation alloc] init];
         
         
         [point setCoordinate:(location1)];
         
         MKCoordinateRegion region = {location1,{.7,.7}};
         region.center.latitude = location.coordinate.latitude;; //user defined
         region.center.longitude = location.coordinate.longitude;//user defined
         [mapview setRegion:region animated:YES];
         [mapview addAnnotation:point];
         
         searchBar.text=locatedAt;
         self.address=locatedAt;
         location1.latitude = droppedAt.latitude;
         location1.longitude = droppedAt.longitude;
         if(self.createItemVC)
         {
             if(self.isOPenForTo)
             {
                 self.createItemVC.toAddressLocation=location1;
                 self.createItemVC.toAddress=self.address;
                 self.createItemVC.toAddressDictioanry=placemark.addressDictionary;
             }
             else
             {
                 self.createItemVC.fromAddressLocation=location1;
                 self.createItemVC.fromAddress=self.address;
                 self.createItemVC.fromAddressDictioanry=placemark.addressDictionary;

             }
         }
         else if(self.intialSetupVC&& self.isOPenForTo)
         {
            self.intialSetupVC.addressLocation=location1;
            self.intialSetupVC.address=self.address;
             CLLocationCoordinate2D droppedAt = location1;
             CLGeocoder *ceo = [[CLGeocoder alloc]init];
             CLLocation *loc = [[CLLocation alloc]initWithLatitude:droppedAt.latitude longitude:droppedAt.longitude];
             
             [ceo reverseGeocodeLocation: loc completionHandler:
              ^(NSArray *placemarks, NSError *error)
              {
                  CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  self.intialSetupVC.addressDictioanry=placemark.addressDictionary;
                  
              }];
         }
         else
         {
             if(self.isOPenForTo)
             {
                 self.creteTripVC.toLocation=location1;
                 self.creteTripVC.toAddress=self.address;

             }
             else
             {
                 self.creteTripVC.fromLocation=location1;
                 self.creteTripVC.fromAddress=self.address;

             }
             CLLocationCoordinate2D droppedAt = location1;
             CLGeocoder *ceo = [[CLGeocoder alloc]init];
             CLLocation *loc = [[CLLocation alloc]initWithLatitude:droppedAt.latitude longitude:droppedAt.longitude];
             
             [ceo reverseGeocodeLocation: loc completionHandler:
              ^(NSArray *placemarks, NSError *error)
              {
                  CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  if(self.isOPenForTo)
                      self.creteTripVC.toAddressDictionary=placemark.addressDictionary;
                  else
                      self.creteTripVC.fromAddressDictioanry=placemark.addressDictionary;

              }];
         }
         
     }];
    MyPin.dragState = MKAnnotationViewDragStateNone;
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
    [searchBar1 resignFirstResponder];
    if([AppDelegate getAppDelegate].isNetworkReachable)
    {
        [[AppDelegate getAppDelegate] showLoadingView:@"Fetching Address On Map..."];
        [self geoCodeUsingAddress:searchBar1.text];
    }
    else
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Please check your intenet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }

}
- (void)geoCodeUsingAddress:(NSString *)address1
{
        double latitude = 0, longitude = 0;
        NSString *esc_addr =  [address1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
        NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
        if (result)
        {
            NSScanner *scanner = [NSScanner scannerWithString:result];
            if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil])
            {
                [scanner scanDouble:&latitude];
                if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil])
                {
                    if(point)
                        [mapview removeAnnotation:point];
    
    
                    [scanner scanDouble:&longitude];
                    [[AppDelegate getAppDelegate] hideLoadingView];
    
                    location1.latitude = latitude;
                    location1.longitude = longitude;
    
                    point = [[MKPointAnnotation alloc] init];

                    location1.latitude = latitude;
                    location1.longitude = longitude;
                    
                    [point setCoordinate:(location1)];
    
                    MKCoordinateRegion region = {location1,{.7,.7}};
                    region.center.latitude = latitude; //user defined
                    region.center.longitude = longitude;//user defined
                    [mapview setRegion:region animated:YES];
                    if(self.creatsenditem2obj)
                    {
                        if(self.isOPenForTo)
                        {
                            self.creatsenditem2obj.fromAddressLocation=location1;
                            self.creatsenditem2obj.fromAddress=address1;
                            CLLocationCoordinate2D droppedAt = location1;
                            CLGeocoder *ceo = [[CLGeocoder alloc]init];
                            CLLocation *loc = [[CLLocation alloc]initWithLatitude:droppedAt.latitude longitude:droppedAt.longitude];
                            [ceo reverseGeocodeLocation: loc completionHandler:
                             ^(NSArray *placemarks, NSError *error)
                             {
                                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                                 //self.creatsenditem2obj.fromAddressDictioanry=placemark.addressDictionary;
                                 self.creatsenditem2obj.fromAddress=[[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                                 searchBar.text=self.creatsenditem2obj.fromAddress;
                             }];
                        }
                        else
                        {
                                self.creatsenditem2obj.toAddressLocation=location1;
                                self.creatsenditem2obj.toAddress=address1;
                                
                                CLLocationCoordinate2D droppedAt = location1;
                                CLGeocoder *ceo = [[CLGeocoder alloc]init];
                                CLLocation *loc = [[CLLocation alloc]initWithLatitude:droppedAt.latitude longitude:droppedAt.longitude];
                                
                                [ceo reverseGeocodeLocation: loc completionHandler:
                                 ^(NSArray *placemarks, NSError *error)
                                 {
                                     CLPlacemark *placemark = [placemarks objectAtIndex:0];
                                     self.creatsenditem2obj.toAddress=[[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                                     searchBar.text=self.createItemVC.toAddress;
                                     //elf.creatsenditem2obj.toAddressDictioanry=placemark.addressDictionary;
                                     
                                 }];
                            }
                        
                    }
                    
                    
                   else if(self.createItemVC)
                    {
                        if(self.isOPenForTo)
                        {
                            self.createItemVC.toAddressLocation=location1;
                            self.createItemVC.toAddress=address1;
                            
                            CLLocationCoordinate2D droppedAt = location1;
                            CLGeocoder *ceo = [[CLGeocoder alloc]init];
                            CLLocation *loc = [[CLLocation alloc]initWithLatitude:droppedAt.latitude longitude:droppedAt.longitude];
                            
                            [ceo reverseGeocodeLocation: loc completionHandler:
                             ^(NSArray *placemarks, NSError *error)
                             {
                                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                                 self.createItemVC.toAddress=[[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                                 searchBar.text=self.createItemVC.toAddress;
                                 self.createItemVC.toAddressDictioanry=placemark.addressDictionary;

                             }];
                        
                        }
                        else
                        {
                            self.createItemVC.fromAddressLocation=location1;
                            self.createItemVC.fromAddress=address1;
                            CLLocationCoordinate2D droppedAt = location1;
                            CLGeocoder *ceo = [[CLGeocoder alloc]init];
                            CLLocation *loc = [[CLLocation alloc]initWithLatitude:droppedAt.latitude longitude:droppedAt.longitude];
                            [ceo reverseGeocodeLocation: loc completionHandler:
                             ^(NSArray *placemarks, NSError *error)
                             {
                                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                                 self.createItemVC.fromAddressDictioanry=placemark.addressDictionary;
                                 self.createItemVC.fromAddress=[[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                                 searchBar.text=self.createItemVC.fromAddress;
                                 
                             }];
                        }
                      
                    }

                    else if(self.intialSetupVC&& self.isOPenForTo)
                    {
                        
                        self.intialSetupVC.addressLocation=location1;
                        self.intialSetupVC.address=address1;
                        CLLocationCoordinate2D droppedAt = location1;
                        CLGeocoder *ceo = [[CLGeocoder alloc]init];
                        CLLocation *loc = [[CLLocation alloc]initWithLatitude:droppedAt.latitude longitude:droppedAt.longitude];
                        
                        [ceo reverseGeocodeLocation: loc completionHandler:
                         ^(NSArray *placemarks, NSError *error)
                         {
                             CLPlacemark *placemark = [placemarks objectAtIndex:0];
                             self.intialSetupVC.addressDictioanry=placemark.addressDictionary;
                             self.intialSetupVC.address=[[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                             searchBar.text=[[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];

                         }];
                    }
                    else
                    {
                        if(self.isOPenForTo)
                        {
                            self.creteTripVC.toLocation=location1;
                            self.creteTripVC.toAddress=address1;
                            
                        }
                        else
                        {
                            self.creteTripVC.fromLocation=location1;
                            self.creteTripVC.fromAddress=address1;
                            
                        }
                        CLLocationCoordinate2D droppedAt = location1;
                        CLGeocoder *ceo = [[CLGeocoder alloc]init];
                        CLLocation *loc = [[CLLocation alloc]initWithLatitude:droppedAt.latitude longitude:droppedAt.longitude];
                        
                        [ceo reverseGeocodeLocation: loc completionHandler:
                         ^(NSArray *placemarks, NSError *error)
                         {
                             CLPlacemark *placemark = [placemarks objectAtIndex:0];
                             if(self.isOPenForTo)
                             {
                                 self.creteTripVC.toAddressDictionary=placemark.addressDictionary;
                                 
                                 self.creteTripVC.toAddress=[[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                                 searchBar.text=self.creteTripVC.toAddress;
                             }
                             else
                             {
                                 self.creteTripVC.fromAddressDictioanry=placemark.addressDictionary;
                                 
                                 self.creteTripVC.fromAddress=[[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                                 searchBar.text=self.creteTripVC.fromAddress;
                             }
                             
                         }];
                    }


                }
                else
                {
                    [[AppDelegate getAppDelegate] hideLoadingView];
                    [AppHelper showAlertViewWithTag:1010 title:App_Name message:@"Unable to fetch address on map" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                }
            }
            else
            {
                [[AppDelegate getAppDelegate] hideLoadingView];
                [AppHelper showAlertViewWithTag:1010 title:App_Name message:@"Unable to fetch address on map" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];

            }
            [mapview addAnnotation:point];

        }
    else
    {
        [[AppDelegate getAppDelegate] hideLoadingView];
        [AppHelper showAlertViewWithTag:1010 title:App_Name message:@"Some error occured" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];

    }
    
    
    
}
-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MyPin=[[MKAnnotationView alloc] initWithAnnotation:point reuseIdentifier:@"current"];
    MyPin.draggable = YES;
    point = annotation;
    MyPin.image = [UIImage imageNamed:@"Pin.png"];
    return MyPin;
}
- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding) // you can check out some more states by looking at the docs
    {
        [[AppDelegate getAppDelegate] showLoadingView:@"Fetching Address..."];
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
       // NSLog(@"dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
        
        
        CLGeocoder *ceo = [[CLGeocoder alloc]init];
        CLLocation *loc = [[CLLocation alloc]initWithLatitude:droppedAt.latitude longitude:droppedAt.longitude];
        
        [ceo reverseGeocodeLocation: loc completionHandler:
         ^(NSArray *placemarks, NSError *error)
        {
             [[AppDelegate getAppDelegate] hideLoadingView];
            
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
//             NSLog(@"placemark %@",placemark);
             //String to hold address
            //NSLog(@"%@",placemark.addressDictionary);
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
          //  NSString *add=[[[placemark.addressDictionary objectForKey:@"SubLocality"] stringByAppendingString:@","] stringByAppendingString:[[[placemark.addressDictionary objectForKey:@"City"] stringByAppendingString:@","] stringByAppendingString:[placemark.addressDictionary objectForKey:@"Country"]]];
//             NSLog(@"addressDictionary %@", placemark.addressDictionary);
//             
//             NSLog(@"placemark %@",placemark.region);
//             NSLog(@"placemark %@",placemark.country);  // Give Country Name
//             NSLog(@"placemark %@",placemark.locality); // Extract the city name
//             NSLog(@"location %@",placemark.name);
//             NSLog(@"location %@",placemark.ocean);
//             NSLog(@"location %@",placemark.postalCode);
//             NSLog(@"location %@",placemark.subLocality);
//             
//             NSLog(@"location %@",placemark.location);
//             //Print the location to console
//             NSLog(@"I am currently at %@",locatedAt);
            searchBar.text=locatedAt;
            address=locatedAt;
            location1.latitude = droppedAt.latitude;
            location1.longitude = droppedAt.longitude;
            

//            self.profileSetupVC.location1=location1;
//            self.profileSetupVC.address=address;

            if(self.creatsenditem2obj)
            {
                if(self.isOPenForTo)
                {
                    self.creatsenditem2obj.fromAddress = address;
                    self.creatsenditem2obj.fromAddressLocation = location1;
                }
                else
                {
                    self.creatsenditem2obj.toAddress = address;
                    self.creatsenditem2obj.toAddressLocation = location1;
                }
            }
            if(self.createItemVC)
            {
                if(self.isOPenForTo)
                {
                    self.createItemVC.toAddressLocation=location1;
                    self.createItemVC.toAddress=address;
                    //  self.createDeliveryVC.toAddressDictioanry=placemark.addressDictionary;
                    
                }
                else
                {
                    self.createItemVC.fromAddressLocation=location1;
                    self.createItemVC.fromAddress=address;
                    //   self.createDeliveryVC.fromAddressDictioanry=placemark.addressDictionary;
                    
                }
            }
            else if(self.intialSetupVC&& self.isOPenForTo)
            {
                
                self.intialSetupVC.addressLocation=location1;
                self.intialSetupVC.address=address;
                self.intialSetupVC.addressDictioanry=placemark.addressDictionary;
            }
            else
            {
                if(self.isOPenForTo)
                {
                    self.creteTripVC.toLocation=location1;
                    self.creteTripVC.toAddress=address;
                    self.creteTripVC.toAddressDictionary=placemark.addressDictionary;
                }
                else
                {
                    self.creteTripVC.fromLocation=location1;
                    self.creteTripVC.fromAddress=address;
                    self.creteTripVC.toAddressDictionary=placemark.addressDictionary;

                }
            }

            
         }];
        MyPin.dragState = MKAnnotationViewDragStateNone;

    }
}

@end
