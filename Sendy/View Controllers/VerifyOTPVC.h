//
//  VerifyOTPVC.h
//  Sendy
//
//  Created by Ishan Shikha on 25/05/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyOTPVC : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>
{
    
}
@property(nonatomic,strong)NSString *mobileNumber;
@property(nonatomic,strong)NSString *emailID;
@property(nonatomic,weak)IBOutlet UILabel *headerLabel;
@property(nonatomic,weak)IBOutlet UITextField *mobilleOTP;
@property(nonatomic,weak)IBOutlet UITextField *emailOTP;
@end
