//
//  OfferDeliveryVC.h
//  Sendy
//
//  Created by Ishan Shikha on 05/07/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateItemVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextViewDelegate>
{
    
}
@property(nonatomic,strong)NSString *parcelTypeImageName;
@property(nonatomic,strong)NSString *parcelTypeName;
@property(nonatomic,strong)NSString *fromAddress;
@property(nonatomic) CLLocationCoordinate2D fromAddressLocation;
@property(nonatomic,strong)NSDictionary *fromAddressDictioanry;
@property(nonatomic,strong)NSString *toAddress;
@property(nonatomic) CLLocationCoordinate2D toAddressLocation;
@property(nonatomic,strong)NSDictionary * toAddressDictioanry;
@property(nonatomic,strong)NSDictionary *itemInfo;
@end
