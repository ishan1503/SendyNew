//
// Created by sbeyers on 3/25/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SharingActivityProvider.h"


@implementation SharingActivityProvider {

}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    // Log out the activity type that we are sharing with
    // Create the default sharing string
    NSString *shareString = @"Download Sendy";

    // customize the sharing string for facebook, twitter, weibo, and google+
    if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
        shareString = [NSString stringWithFormat:@"Share on Facebook: %@", shareString];
    } else if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
        shareString = [NSString stringWithFormat:@"Share on Twitter: %@", shareString];
    } else if ([activityType isEqualToString:UIActivityTypePostToWeibo]) {
        shareString = [NSString stringWithFormat:@"Share on Weibo: %@", shareString];
    }
    if ( [activityType isEqualToString:UIActivityTypeMessage] ) {
        return @"SMS message text";
    }
    if ( [activityType isEqualToString:UIActivityTypeMail] )
        return @"Email text here!";
    return shareString;
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return @"";
}

@end