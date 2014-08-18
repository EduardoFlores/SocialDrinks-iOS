//
//  LoginVC.h
//  Connoisseur
//
//  Created by Eduardo Flores on 6/16/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController <UITextFieldDelegate>
{
    NSUserDefaults *defaults;
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (weak, nonatomic) IBOutlet UITextField *textField_email;
@property (weak, nonatomic) IBOutlet UITextField *textField_password;

- (IBAction)button_login:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *button_login;

- (IBAction)button_signUp:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *button_signUp;

- (void) setValuesOfLabelsAndButtons;
- (BOOL) hasTextInTextFields;
- (void) displayAlertWithTitle:(NSString *)title message:(NSString *)message andCancelButton:(NSString *)cancel;
- (void) dismissKeyboard;
- (BOOL) isNewUser;
- (void) saveUsernameAndPassword;
- (void) loginWithUsername:(NSString *)username password:(NSString *)password;

@end
