//
//  PostFullImageVC.m
//  Connoisseur
//
//  Created by Eduardo Flores on 7/1/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import "PostFullImageVC.h"

@interface PostFullImageVC ()

@end

@implementation PostFullImageVC
@synthesize imageView_image, imageData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [imageView_image setImage:[UIImage imageWithData:imageData]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)button_done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
















































