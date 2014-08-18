//
//  MyProfileVC.h
//  Connoisseur
//
//  Created by Eduardo Flores on 6/17/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfileVC : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSData *data_profilePicture;
}

@property (weak, nonatomic) IBOutlet UIButton *button_changeProfilePicture;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_profilePicture;
@property (weak, nonatomic) IBOutlet UITextField *textField_firstName;
@property (weak, nonatomic) IBOutlet UITextField *textField_lastName;


- (IBAction)button_changeProfilePicture:(id)sender;
- (IBAction)button_saveChanges:(id)sender;

- (void) setValuesForElementsInView;
- (void) startCamera;

@end
