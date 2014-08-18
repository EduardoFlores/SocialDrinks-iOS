//
//  PostPreviewTVC.h
//  Connoisseur
//
//  Created by Eduardo Flores on 6/17/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostPreviewTVC : UITableViewController

@property (nonatomic, weak) NSData *imageData;

- (IBAction)button_cancel:(id)sender;
- (IBAction)button_upload:(id)sender;

@end
