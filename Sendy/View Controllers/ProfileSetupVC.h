//
//  ProfileSetupVC.h
//  Sendy
//
//  Created by Ishan Shikha on 01/06/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CountryPicker.h"
@interface ProfileSetupVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UIAlertViewDelegate,CountryPickerDelegate>
{
    
}
@property(nonatomic,strong)NSDictionary *socailUserInfo;
@property(nonatomic)CLLocationCoordinate2D location1;
@property(nonatomic,strong)NSString *address;
@property(nonatomic)BOOL isComingtoEdit;
@property(nonatomic,weak)IBOutlet UIButton *rightBarButton;
@property(nonatomic,weak)IBOutlet UIButton *backButton;
@property(nonatomic,weak)IBOutlet UILabel *headerLabel;
@end
