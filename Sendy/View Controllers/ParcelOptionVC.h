//
//  MakeADeliveryVC.h
//  Sendy
//
//  Created by Ishan Shikha on 14/07/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CreateItemVC.h"
@interface ParcelOptionVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property(nonatomic,retain)CreateItemVC *createItemVC;
@end
