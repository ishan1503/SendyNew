//
//  ServiceClass.m
//  Infinea
//
//  Created by Ritu Dalal on 6/27/14.
//  Copyright (c) 2014 Ritu Dalal. All rights reserved.
//

#import "ServiceClass.h"
#import "AFNetworking.h"
#import "Define.h"
#import "AppDelegate.h"
#import "AppHelper.h"
#import "NMBottomTabBarController.h"
@implementation ServiceClass

+(ServiceClass *) sharedServiceClass
{
    static ServiceClass *singolton;
    if(!singolton)
    {
        singolton=[[ServiceClass alloc] init];
    }
    if([AppDelegate getAppDelegate].isNetworkReachable)
    {
        [[AppDelegate getAppDelegate] showLoadingView:@"Please Wait..."];
        return singolton;
    }
    else
    {
        [AppHelper showAlertViewWithTag:101 title:App_Name message:@"No internet connection available.Please check and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        return nil;
    }
}
-(void)signupWithDictionary:(NSMutableDictionary *)dictionary
{
    [dictionary setObject:@"we" forKey:parm_deviceId];
    [dictionary setObject:@"i" forKey:parm_deviceType];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:Register] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
         }
         else
         {
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             [[AppDelegate getAppDelegate] hideLoadingView];

         }
         [[NSNotificationCenter defaultCenter] postNotificationName:Registeration_Notification object:[parsedData objectForKey:@"Payload"]];

     }
     failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];

}
-(void)verifyOTP:(NSDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:VerifyOTP] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:VerifyOTP_Notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             [[AppDelegate getAppDelegate] hideLoadingView];
             
         }
     }
     failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];

}
-(void)initialSetupWithDictionary:(NSDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:offerLocalDelivery] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:InitialSetup_Done_Notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             [[AppDelegate getAppDelegate] hideLoadingView];
             
         }
     }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];
    
}
-(void)awardeAsDelivererWithDictionary:(NSMutableDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:awardedAsDeliverer] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:Awarded_Deliveries_As_Deliverer_Notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         }
     }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];

    
}
-(void)loginUser:(NSMutableDictionary *)dictionary
{

    [dictionary setObject:@"we" forKey:parm_deviceId];
    [dictionary setObject:@"i" forKey:parm_deviceType];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:@"login"] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         [[AppDelegate getAppDelegate] hideLoadingView];
         if([[parsedData objectForKey:@"Status"] intValue]==1||[[[parsedData objectForKey:@"Payload"] objectForKey:@"email"] length]>0)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:Login_Notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         }
     }
        failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];
    
}
-(void)resendOTPOfUser:(NSDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:resendOTP] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
              [AppHelper showAlertViewWithTag:101 title:App_Name message:@"You will recieve an OTP shortly." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         }
         else
         {
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             
         }
         [[AppDelegate getAppDelegate] hideLoadingView];

     }
    failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];

}
-(void)profileSetupWithDictionary:(NSMutableDictionary *)dictionary WihImageUrl:(UIImage *)userimage isForUpdate:(BOOL)update
{
    //create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    //Set Params
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
    //Create boundary, it can be anything
    NSString *boundary = @"------VohpleBoundary4QuqLuM1cE5lMwCy";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    //Populate a dictionary with all the regular values you would like to send.
    
    
    
    // add params (all params are strings)
    for (NSString *param in dictionary)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dictionary objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSString *FileParamConstant = @"image";
    
    NSData *imageData = UIImageJPEGRepresentation(userimage, 1);
    
    //Assuming data is not nil we add this to the multipart form
    if (imageData)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.png\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type:image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //Close off the request with the boundary
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the request
    [request setHTTPBody:body];
    
    // set URL
    if(!update)
    {
        [request setURL:[NSURL URLWithString:[BaseUrl stringByAppendingString:Register]]];
    }
    else
    {
        [request setURL:[NSURL URLWithString:[BaseUrl stringByAppendingString:updateProfile]]];
    }

    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if(!error)
                               {
                                   id parsedData   = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                   [[AppDelegate getAppDelegate] hideLoadingView];
                                   if([[parsedData objectForKey:@"Code"] isEqualToString:@"OK"])
                                   {
                                       [[NSNotificationCenter defaultCenter] postNotificationName:Profile_Setup__Notification_Rvcd object:[parsedData objectForKey:@"Payload"]];
                                       
                                   }
                                   else
                                   {
                                       [AppHelper showAlertViewWithTag:10010103 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                   }
                                   
                               }
                               
                               else
                               {
                                   [[AppDelegate getAppDelegate] hideLoadingView];

                                   //NSLog(@"%@",error.localizedDescription);
                                   [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Some error occured at server" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                               }
                               
                           }];
}
-(void)updateProfileWithDictionary:(NSMutableDictionary *)dictionary WihImageUrl:(UIImage *)userimage
{
    NSString *str=[NSString stringWithFormat:@"http://52.89.119.20/Api/updateProfile"];
    NSString *urlString = [NSString stringWithFormat:@"%@",str];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"a.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:UIImagePNGRepresentation(userimage)]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //  parameter username
    
    for (NSString *param in dictionary)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *str=[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",param];
        [body appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dictionary objectForKey:param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        // setting the body of the post to the reqeust
    [request setHTTPBody:body];    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if(!error)
                               {
                                   id parsedData   = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                   [[AppDelegate getAppDelegate] hideLoadingView];
                                   if([[parsedData objectForKey:@"Code"] isEqualToString:@"OK"])
                                   {
                                       [[NSNotificationCenter defaultCenter] postNotificationName:Profile_Setup__Notification_Rvcd object:[parsedData objectForKey:@"Payload"]];
                                       
                                   }
                                   else
                                   {
                                       [AppHelper showAlertViewWithTag:10010103 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                   }
                                   
                               }
                               
                               else
                               {
                                   [[AppDelegate getAppDelegate] hideLoadingView];
                                   
                                   //NSLog(@"%@",error.localizedDescription);
                                   [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Some error occured at server" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                               }
                               
                           }];
    //
}
-(void)forgotPasswordMethod:(NSDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:forgotPassword] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [AppHelper showAlertViewWithTag:101 title:App_Name message:@"Email recovery Link has been sent on your email." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         }
         else
         {
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             
         }
         [[AppDelegate getAppDelegate] hideLoadingView];
         
     }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];
    
}
-(void)changePasswordMethod:(NSDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:changePassword] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        [AppHelper showAlertViewWithTag:10010103 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             
         [[AppDelegate getAppDelegate] hideLoadingView];
         
     }
    failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];
    
}
-(void)checkUserMethod:(NSMutableDictionary *)dictionary
{
    [dictionary setObject:@"we" forKey:parm_deviceId];
    [dictionary setObject:@"i" forKey:parm_deviceType];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:socialLogin1] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Payload"] count]>0)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:Login_Notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:Login_Notification object:nil];
             [[AppDelegate getAppDelegate] hideLoadingView];

         }
     }
    failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];
    
}
-(void)editItemDictionary:(NSDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:editItem] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:Item_Updated_Notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         }
     }
    failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];

}
-(void)editTripWithDictionary:(NSDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:editTrip] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:CreateTrip_Notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         }
     }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];
    
}
-(void)createTripWithDictionary:(NSDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:createTrip] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:CreateTrip_Notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         }
     }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];
    
}
-(void)findTripWithDictionary:(NSDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:findTrip] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:SearchTrip_Notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         }
     }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];
    
}
-(void)awardTripWithDictionary:(NSDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:awardJob] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:12121212 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         }
     }
    failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];
    
}

#pragma mark-AlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==10010103)
    {
        NMBottomTabBarController *tabBarController=(NMBottomTabBarController *)[AppDelegate getAppDelegate].window.rootViewController;
        UINavigationController *moreNavigationController=(UINavigationController *)[tabBarController.controllers objectAtIndex:3];
        [moreNavigationController popViewControllerAnimated:YES];
    }
    else if(alertView.tag==12121212)
    {
        NMBottomTabBarController *tabBarController=(NMBottomTabBarController *)[AppDelegate getAppDelegate].window.rootViewController;
        UINavigationController *moreNavigationController=(UINavigationController *)[tabBarController.controllers objectAtIndex:0];
        [moreNavigationController popToViewController:[[moreNavigationController viewControllers] objectAtIndex:moreNavigationController.viewControllers.count-2] animated:YES];
    }
}
-(void)getMyTrip
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:myTrip] parameters:[NSDictionary dictionaryWithObject:UserID forKey:@"userId"] success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:MyTrip_Notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             [[NSNotificationCenter defaultCenter] postNotificationName:MyTrip_Notification object:[parsedData objectForKey:@"Payload"]];

         }
     }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[NSNotificationCenter defaultCenter] postNotificationName:MyTrip_Notification object:nil];

         [[AppDelegate getAppDelegate] hideLoadingView];
     }];

}
-(void)getMyDeliveries
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:myDeliveries] parameters:[NSDictionary dictionaryWithObject:UserID forKey:@"userId"] success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:MyDeliveries_Notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:MyDeliveries_Notification object:[parsedData objectForKey:@"Payload"]];

             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         }
     }
     failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[NSNotificationCenter defaultCenter] postNotificationName:MyDeliveries_Notification object:nil];

         [[AppDelegate getAppDelegate] hideLoadingView];
     }];

}
-(void)cancelTripWithDictionary:(NSDictionary *)dictionary{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:cancelTrip1] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:CancelTrip_Notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         }
     }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {         
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];

}
-(void)cancelItemWithDictionary:(NSDictionary *)dictionary{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:cancelItem] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:CancelItem_Notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         }
     }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];
    
}

-(void)createItemDictionary:(NSDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:CreateItemForDelivery] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:Item_Created_Notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         }
     }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];

}
-(void)findSenderNearByYouWithDictionary:(NSMutableDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:sender_near_by_you] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:Sender_Near_By_You_Notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         }
     }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];

}
-(void)postBidWithDictionary:(NSMutableDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:postBid] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:Post_Bid_Notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         }
     }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];
    
}
-(void)fetchDelivererTripWithDictionary:(NSMutableDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:tripsAsDeliverer] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:Delivere_Trip_RCVD_Notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         }
     }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];

}
-(void)getCurrentOffersWithDictionary:(NSMutableDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:currentOfferAsSender] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:Current_Offers_RCVD_Notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         }
     }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];

}
-(void)awardJobWithDictionary:(NSMutableDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:awardJob] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:Job_Awarded_Notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         }
     }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];

}
-(void)awardeAsSenderWithDictionary:(NSMutableDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:awardedAsSender] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:Awarded_Deliveries_As_Sender_Notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         }
     }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];
}
-(void)completedAsSenderWithDictionary:(NSMutableDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:completedDeliveryAsSender] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:Completed_Deliveries_As_Sender_Notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];

         }
     }
    failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];
}
-(void)completedAsDelivererWithDictionary:(NSMutableDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:completedAsDeliverer] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:Completed_Deliveries_As_Deliverer_Notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             
         }
     }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];
}
-(void)bidsAsDelivererWithDictionary:(NSMutableDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:bidsAsDeliverer] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:Bids_Deliverer_Rcvd_Notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         }
     }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];
}

-(void)activityPressed:(NSMutableDictionary *)dictionary andMethodName:(NSString *)methodName
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:methodName] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:Activity_Notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             
         }
     }
    failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];

}


-(void)postdeliverysender:(NSMutableDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:createItem] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSLog(@"%@",parsedData);
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:create_item_notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             
         }
     }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];
    
}

-(void)getPostedjobListing:(NSMutableDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:postedJobs] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSLog(@"%@",parsedData);
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:Posted_job_Listing object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             
         }
     }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];
}

-(void)getinProgressJobsListing:(NSMutableDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:postedJobs] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSLog(@"%@",parsedData);
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:Posted_job_Listing object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
             
         }
     }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];
}


-(void)deletepost:(NSMutableDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:deletePostedJobs] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSLog(@"%@",parsedData);
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:delete_postedjob_notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        }
     }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];
}


-(void)modifyPost:(NSMutableDictionary *)dictionary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    manager.requestSerializer.timeoutInterval = 40;
    [manager POST:[BaseUrl stringByAppendingString:modifyPostedJobs] parameters:dictionary success: ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id parsedData   = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSLog(@"%@",parsedData);
         if([[parsedData objectForKey:@"Status"] intValue]==1)
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [[NSNotificationCenter defaultCenter] postNotificationName:modify_postedjob_notification object:[parsedData objectForKey:@"Payload"]];
         }
         else
         {
             [[AppDelegate getAppDelegate] hideLoadingView];
             [AppHelper showAlertViewWithTag:101 title:App_Name message:[parsedData objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         }
     }
          failure: ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppDelegate getAppDelegate] hideLoadingView];
     }];
}




@end
