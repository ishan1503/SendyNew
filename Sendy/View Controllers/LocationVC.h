//
//  LocationVC.h
//  EventApp
//
//  Created by Ishan Gupta on 14/12/14.
//  Copyright (c) 2014 Ishan Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateItemVC.h"
#import <CoreLocation/CoreLocation.h>
#import "InitialSetupVC.h"
#import "CreateTripVC.h"
#import "create_send_item_2.h"
@interface LocationVC : UIViewController<UISearchBarDelegate,CLLocationManagerDelegate>
{
    
}
@property(nonatomic,strong)CreateItemVC *createItemVC;
@property(nonatomic,strong)InitialSetupVC *intialSetupVC;
@property(nonatomic,strong)CreateTripVC *creteTripVC;
@property(nonatomic,strong)create_send_item_2 *creatsenditem2obj;
@property(nonatomic)BOOL isOPenForTo;
@property(nonatomic) CLLocationCoordinate2D location1;
@property(nonatomic,strong)NSString *address;
@end
