//
//  ProgressBarHelper.h
//  Connoisseur
//
//  Created by Eduardo Flores on 6/17/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface ProgressBarHelper : NSObject

+ (void)displayIndeterminateProgressBarWithSelf:(UIViewController *)param;
+ (void) hideProgressBar:(UIViewController *)param;

@end
