//
//  SignUpVC.h
//  Connoisseur
//
//  Created by Eduardo Flores on 6/16/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SignUpVC : UIViewController <MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

@property (weak, nonatomic) IBOutlet UITextField *textField_firstName;
@property (weak, nonatomic) IBOutlet UITextField *textField_lastName;
@property (weak, nonatomic) IBOutlet UITextField *textField_email;
@property (weak, nonatomic) IBOutlet UITextField *textField_password;

- (IBAction)button_createAccount:(id)sender;
- (IBAction)button_cancel:(id)sender;

- (void) displayAlertWithTitle:(NSString *)title message:(NSString *)message andCancelButton:(NSString *)cancel;

@end
