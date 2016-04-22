//
//  AwardedSenderDetail.h
//  Sendy
//
//  Created by Ishan Shikha on 25/10/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AwardedSenderDetail : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property(nonatomic,strong)NSMutableDictionary *dict;
@property(nonatomic)BOOL isOpenForDeliverer;
@property (strong, nonatomic) QBChatDialog *createdDialog;

@end
