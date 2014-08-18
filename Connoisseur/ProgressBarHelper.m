//
//  ProgressBarHelper.m
//  Connoisseur
//
//  Created by Eduardo Flores on 6/17/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import "ProgressBarHelper.h"

@implementation ProgressBarHelper

+ (void)displayIndeterminateProgressBarWithSelf:(UIViewController *)param
{
    MBProgressHUD *HUD;

    HUD = [[MBProgressHUD alloc] initWithView:param.view];
    [param.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeIndeterminate;
    //HUD.delegate = param.self;
    [HUD show:YES];
}

+ (void) hideProgressBar:(UIViewController *)param
{
    [MBProgressHUD hideAllHUDsForView:param.view animated:YES];
}
@end
