//
//  UILabel+Extra.m
//  Sendy
//
//  Created by harish lakhwani on 7/13/15.
//  Copyright (c) 2015 Ishan Gupta. All rights reserved.
//

#import "UILabel+Extra.h"

@implementation UILabel (Extra)

- (void)setAttributeText:(NSRange)range
{
    UIColor *labelColor;

    labelColor = [UIColor colorWithRed:(41/255.0) green:(168/255.0) blue:(147/255.0) alpha:1];

    
    UIColor *blackColor;
    
    blackColor = [UIColor blackColor];

    
    NSDictionary *subAttrs = @{
                            NSFontAttributeName:self.font,
                            NSForegroundColorAttributeName:labelColor
                            };
    NSDictionary *attrs = @{
                                NSFontAttributeName:self.font,
                                NSForegroundColorAttributeName:blackColor
                               };
    
    
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:self.text
                                           attributes:attrs];
    [attributedText setAttributes:subAttrs range:range];
    [self setAttributedText:attributedText];
}

@end
