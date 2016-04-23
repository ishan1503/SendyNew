//
//  CourierTimeAddressVC.h
//  Sendy
//
//  Created by Ishan Shikha on 23/04/16.
//  Copyright © 2016 Ishan Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourierTimeAddressVC : UIViewController
{
    IBOutlet NSLayoutConstraint *height;
    IBOutlet UIView *myTripView;
    IBOutlet UIButton *searchJobButton;

}
@property(nonatomic)BOOL isOpenForOnDemand;
@end
