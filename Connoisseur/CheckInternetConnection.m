//
//  CheckInternetConnection.m
//  SAi Cloud
//
//  Created by Eduardo Flores on 4/3/14.
//  Copyright (c) 2014 SA International. All rights reserved.
//

#import "CheckInternetConnection.h"

@implementation CheckInternetConnection

+ (BOOL) isConnectedToTheInternet
{
    NSURL *scriptUrl = [NSURL URLWithString:@"http://www.google.com"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data)
    {
        //NSLog(@"Device is connected to the internet");
        return YES;
    }
    else
    {
        //NSLog(@"Device is not connected to the internet");
        return NO;
    }
}

@end
