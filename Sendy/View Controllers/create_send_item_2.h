//
//  create_send_item_2.h
//  Sendy
//
//  Created by Prankur on 16/03/16.
//  Copyright (c) 2016 Ishan Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface create_send_item_2 : UIViewController<CLLocationManagerDelegate>
{

}
@property(nonatomic,strong)NSString *fromAddress;
@property(nonatomic) CLLocationCoordinate2D fromAddressLocation;
@property(nonatomic,strong)NSString *toAddress;
@property(nonatomic) CLLocationCoordinate2D toAddressLocation;

@end
