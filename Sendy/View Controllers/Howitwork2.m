//
//  Howitwork2.m
//  Sendy
//
//  Created by Prankur on 05/03/16.
//  Copyright © 2016 Ishan Gupta. All rights reserved.
//

#import "Howitwork2.h"

@interface Howitwork2 ()

@end

@implementation Howitwork2
{
    IBOutlet UILabel *orlbl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    orlbl.layer.cornerRadius = orlbl.frame.size.height / 2;
    orlbl.layer.masksToBounds = YES;
    orlbl.layer.borderWidth = 1;
    orlbl.layer.borderColor = [UIColor colorWithRed:54.0f/255.0f green:178.0f/255.0f blue:158.0f/255.0f alpha:1.0].CGColor;
}

@end
