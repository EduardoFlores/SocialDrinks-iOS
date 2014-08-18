//
//  LoginVC.m
//  Connoisseur
//
//  Created by Eduardo Flores on 6/16/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import "LoginVC.h"
#import <Parse/Parse.h>
#import "CheckInternetConnection.h"
#import "SignUpVC.h"
#import "TabBarViewController.h"
#import "ProgressBarHelper.h"
#import "SFHFKeychainUtils.h"
#import "TimelineTVC.h"
#import "Post.h"

#define SERVICE_NAME @"Connoisseur"

@interface LoginVC ()

@end

@implementation LoginVC
@synthesize button_login, button_signUp, textField_email, textField_password;
@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
    NSError *error = nil;
    if ( ![[self fetchedResultsController]performFetch:&error])
    {
        NSLog(@"error fetching results. Error = %@", error);
    }
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    if ( ![self isNewUser])
    {
        NSString *username = [defaults objectForKey:@"username"];
        NSString *password = [SFHFKeychainUtils getPasswordForUsername:username
                                                        andServiceName:SERVICE_NAME
                                                                 error:nil];
        [self loginWithUsername:username password:password];
    }
    
    [self setValuesOfLabelsAndButtons];

    textField_password.delegate = self;
}

- (void)setValuesOfLabelsAndButtons
{
    textField_email.placeholder = @"email";
    textField_password.placeholder = @"password";
    
    [button_login setTitle:@"Login" forState:UIControlStateNormal];
    [button_signUp setTitle:@"Sign Up" forState:UIControlStateNormal];
}

- (BOOL)isNewUser
{
    if (![defaults objectForKey:@"username"])
        return YES;
    else
        return NO;
}

- (BOOL) hasTextInTextFields
{
    if ([textField_email.text isEqualToString:@""] || [textField_password.text isEqualToString:@""])
        return NO;
    else
        return YES;
}

- (void) saveUsernameAndPassword
{
    [defaults setObject:[textField_email text] forKey:@"username"];
    [defaults synchronize];
    
    NSError *keychainError = nil;
    [SFHFKeychainUtils storeUsername:[textField_email text]
                         andPassword:[textField_password text]
                      forServiceName:SERVICE_NAME
                      updateExisting:YES
                               error:&keychainError];
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    [ProgressBarHelper displayIndeterminateProgressBarWithSelf:self];
    
    [PFUser logInWithUsernameInBackground:username
                                 password:password
                                    block:^(PFUser *user, NSError *error)
     {
         [ProgressBarHelper hideProgressBar:self];
         
         if (!error)
         {
             // save the login
             if ( [self isNewUser])
                 [self saveUsernameAndPassword];
             
             // push to next view
             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
             TabBarViewController *tabBarAfterLogin = [storyboard instantiateViewControllerWithIdentifier:@"tabBarAfterLogin"];
             
             UINavigationController *nav = [[tabBarAfterLogin viewControllers]objectAtIndex:0];
             TimelineTVC *ttvc = [[nav viewControllers]objectAtIndex:0];
             ttvc.managedObjectContext = self.managedObjectContext;
             
             NSArray *objectsFetched = [_fetchedResultsController fetchedObjects];
             if ([objectsFetched count] != 0)
             {
                 Post *post = [objectsFetched lastObject];
                 ttvc.lastObjectDate = post.createdTimestampAsDate;
             }
             else
             {
                 NSDate *timestamp;
                 NSDateComponents *comps = [[NSDateComponents alloc] init];
                 [comps setDay:01];
                 [comps setMonth:01];
                 [comps setYear:2000];
                 timestamp = [[NSCalendar currentCalendar] dateFromComponents:comps];
                 ttvc.lastObjectDate = timestamp;
             }

             
             [self.navigationController pushViewController:tabBarAfterLogin animated:YES];
         }
         else
         {
             [self displayAlertWithTitle:@"Can't Log In"
                                 message:[NSString stringWithFormat:@"Error = %@", error]
                         andCancelButton:@"OK"];
         }
     }];
}

- (IBAction)button_login:(id)sender
{
    if ([self hasTextInTextFields])
    {
        [self loginWithUsername:[textField_email text]
                       password:[textField_password text]];
    }
    else
    {
        // empty fields
        [self displayAlertWithTitle:@"Empty Fields"
                            message:@"Please enter a valid email and password"
                    andCancelButton:@"OK"];
    }
}

- (IBAction)button_signUp:(id)sender
{
    // present view modally to sign up
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    SignUpVC *suvc = [storyboard instantiateViewControllerWithIdentifier:@"SignUp"];
    
    [self presentViewController:suvc animated:YES completion:nil];
}

- (void)displayAlertWithTitle:(NSString *)title message:(NSString *)message andCancelButton:(NSString *)cancel
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:cancel
                                          otherButtonTitles:nil];
    [alert show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismissKeyboard];
    [self button_login:nil];
    return YES;
}

- (void)dismissKeyboard
{
    [textField_password resignFirstResponder];
}

#pragma mark - Fetched Results Controller section
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
        return _fetchedResultsController;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Post" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdTimestampAsDate"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:self.managedObjectContext
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];
    
    return _fetchedResultsController;
}

@end
















































