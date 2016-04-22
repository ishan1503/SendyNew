//
//  InitialSetupVC.h
//  Sendy
//
//  Created by Ishan Shikha on 02/10/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InitialSetupVC : UIViewController
{
    
}
@property(nonatomic,strong)NSString *address;
@property(nonatomic) CLLocationCoordinate2D addressLocation;
@property(nonatomic,strong)NSDictionary *addressDictioanry;
@end
