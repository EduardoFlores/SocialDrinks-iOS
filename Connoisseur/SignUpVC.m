//
//  SignUpVC.m
//  Connoisseur
//
//  Created by Eduardo Flores on 6/16/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import "SignUpVC.h"
#import <Parse/Parse.h>
#import "ProgressBarHelper.h"

#define TEXTFIELD_EMAIL         1
#define TEXTFIELD_PASSWORD      2
#define TEXTFIELD_FIRST_NAME    3
#define TEXTFIELD_LAST_NAME     4

@interface SignUpVC ()

@end

@implementation SignUpVC
@synthesize textField_password, textField_email, textField_firstName, textField_lastName;

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int) getTextFieldWithoutData
{
    if ([textField_firstName.text isEqualToString:@""])
        return TEXTFIELD_FIRST_NAME;
    else if ([textField_lastName.text isEqualToString:@""])
        return TEXTFIELD_LAST_NAME;
    else if ([textField_email.text isEqualToString:@""])
        return TEXTFIELD_EMAIL;
    else if ([textField_password.text isEqualToString:@""])
        return TEXTFIELD_PASSWORD;
    
    else
        return 0;
}

- (IBAction)button_createAccount:(id)sender
{
    if ( [self getTextFieldWithoutData] == 0)
    {
        [ProgressBarHelper displayIndeterminateProgressBarWithSelf:self];
        
        // create account
        PFUser *user = [PFUser user];
        user.username = [textField_email text];
        user.password = [textField_password text];
        user[@"name_first"] = [textField_firstName text];
        user[@"name_last"] = [textField_lastName text];
        user.email = [textField_email text];
        
        user[@"lc_name_first"] = [[textField_firstName text]lowercaseString];
        user[@"lc_name_last"] = [[textField_lastName text]lowercaseString];
        user[@"lc_email"] = [[textField_email text]lowercaseString];
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            [ProgressBarHelper hideProgressBar:self];
            if (!error)
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                NSString *errorMessage = [NSString stringWithFormat:@"Error = %@", error];
                [self displayAlertWithTitle:@"Can't sign up"
                                    message: errorMessage
                            andCancelButton:@"OK"];
            }
        }];
    }
    else
    {
        // get the text field that its empty
        // display alert view showing which field is empty
        [self displayAlertWithTitle:@"Missing Fields"
                            message:[NSString stringWithFormat:@"Missing field %d", [self getTextFieldWithoutData]]
                    andCancelButton:@"OK"];
    }
}

- (void) displayAlertWithTitle:(NSString *)title message:(NSString *)message andCancelButton:(NSString *)cancel
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:cancel
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)button_cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

















































