//
//  HomeVC.h
//  Sendy
//
//  Created by Ishan Shikha on 21/06/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CreateTripVC : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
}
@property(nonatomic) CLLocationCoordinate2D fromLocation;
@property(nonatomic)CLLocationCoordinate2D toLocation;
@property(nonatomic,strong)NSString *fromAddress;
@property(nonatomic,strong)NSString *toAddress;
@property(nonatomic,strong)NSDictionary *fromAddressDictioanry;
@property(nonatomic,strong)NSDictionary *toAddressDictionary;
@property(nonatomic,strong)NSDictionary *tripInfo;
@end
