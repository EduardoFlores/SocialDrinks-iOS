//
//  PostFullImageVC.h
//  Connoisseur
//
//  Created by Eduardo Flores on 7/1/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostFullImageVC : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView_image;
@property (nonatomic, weak) NSData *imageData;

- (IBAction)button_done:(id)sender;

@end
