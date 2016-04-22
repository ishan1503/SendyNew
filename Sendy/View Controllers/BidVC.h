//
//  BidVC.h
//  Sendy
//
//  Created by Ishan Shikha on 11/10/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BidVC : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    
}
@property(nonatomic,retain)NSDictionary *infoDict;
@property(nonatomic)BOOL isComingToEdit;
@end
