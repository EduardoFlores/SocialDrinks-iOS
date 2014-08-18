//
//  TimelinePostPreviewVC.m
//  Connoisseur
//
//  Created by Eduardo Flores on 6/17/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import "TimelinePostPreviewVC.h"
#import "ProgressBarHelper.h"
#import <Parse/Parse.h>

@interface TimelinePostPreviewVC ()

@end

@implementation TimelinePostPreviewVC
@synthesize imageView_postThumbnail, imageData;
@synthesize label_rateThisWine, label_valueOfRating, slider_ratingSlider;
@synthesize textField_comments, textField_nameOfWine, textField_originOfWine, textField_typeOfWine, textField_yearOfBottle;

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

- (void)addKeyboardObservers
{
    textField_yearOfBottle.delegate = self;
    textField_typeOfWine.delegate = self;
    textField_originOfWine.delegate = self;
    textField_nameOfWine.delegate = self;
    textField_comments.delegate = self;
    
    // Keyboard notifications so things can move up when the keyboard shows up
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addKeyboardObservers];
    
    imageView_postThumbnail.image = [UIImage imageWithData:imageData];
    
    [self setArrayValues];
    [self setPickerViews];
    
    // set the initial value of the rating to the initial value of the slider
    // also set up the slider to have a selector for continuous updates
    valueOfRating = (int) slider_ratingSlider.value;
    label_valueOfRating.text = [NSString stringWithFormat:@"%d", valueOfRating];
    slider_ratingSlider.continuous = YES;
    [slider_ratingSlider addTarget:self
                            action:@selector(sliderValueChanged:)
                  forControlEvents:UIControlEventValueChanged];
    
    NSLog(@"imageData = %@", imageData);
}

- (void)setArrayValues
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:[NSDate date]];
    currentYear = (int) [components year];
    arrayOfYears = [[NSMutableArray alloc]init];
    for (int i = currentYear; i >= 1800; i--)
    {
        [arrayOfYears addObject:[NSNumber numberWithInt:i]];
    }
    
    arrayTypeOfWines = [NSArray arrayWithObjects:@"Red", @"White", @"Rosé", @"Sparkling", @"Fortified", @"Desert", nil];
}

- (void)setPickerViews
{
    textField_typeOfWine.delegate = self;
    textField_typeOfWine.text = [arrayTypeOfWines firstObject];
    
    textField_yearOfBottle.delegate = self;
    textField_yearOfBottle.text = [NSString stringWithFormat:@"%@", [arrayOfYears firstObject]];

    
    pickerView_typesOfWine = [[UIPickerView alloc]init];
    pickerView_typesOfWine.dataSource = self;
    pickerView_typesOfWine.delegate = self;
    pickerView_typesOfWine.showsSelectionIndicator = YES;
    [pickerView_typesOfWine setBackgroundColor:[UIColor whiteColor]];
    pickerView_typesOfWine.tag = 1;
    
    pickerView_yearsOfWine = [[UIPickerView alloc]init];
    pickerView_yearsOfWine.dataSource = self;
    pickerView_yearsOfWine.delegate = self;
    pickerView_yearsOfWine.showsSelectionIndicator = YES;
    [pickerView_yearsOfWine setBackgroundColor:[UIColor whiteColor]];
    pickerView_yearsOfWine.tag = 2;
    
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(dismissKeyboard)];
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-pickerView_typesOfWine.frame.size.height-50, 320, 50)];
    
    [toolBar setBarStyle:UIBarStyleDefault];
    NSArray *toolBarItems = [NSArray arrayWithObjects:doneButton, nil];
    [toolBar setItems:toolBarItems];
    
    textField_typeOfWine.inputView = pickerView_typesOfWine;
    textField_typeOfWine.inputAccessoryView = toolBar;
    
    textField_yearOfBottle.inputView = pickerView_yearsOfWine;
    textField_yearOfBottle.inputAccessoryView = toolBar;
}

#pragma mark - Picker View Data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (pickerView.tag)
    {
        case 1:
            return [arrayTypeOfWines count];
            break;
        case 2:
            return [arrayOfYears count];
            break;
        default:
            return 0;
            
    }
}

#pragma mark- Picker View Delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (pickerView.tag)
    {
        case 1:
            return [textField_typeOfWine setText:[arrayTypeOfWines objectAtIndex:row]];
            break;
        case 2:
            return [textField_yearOfBottle setText:[NSString stringWithFormat:@"%@", [arrayOfYears objectAtIndex:row]]];
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (pickerView.tag)
    {
        case 1:
            return [arrayTypeOfWines objectAtIndex:row];
            break;
        case 2:
            return [NSString stringWithFormat:@"%@", [arrayOfYears objectAtIndex:row]];
            break;
        default:
            return @"";
            
    }
}

- (void)sliderValueChanged:(UISlider *)slider
{
    valueOfRating = (int) slider.value;
    label_valueOfRating.text = [NSString stringWithFormat:@"%d", valueOfRating];
}

- (IBAction)button_uploadPicture:(id)sender
{
    if ( ![textField_comments.text isEqualToString:@""])
    {
        [self dismissKeyboard];
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Who should see this?"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Everyone", @"Only Me", nil];
        
        actionSheet.delegate = self;
        [actionSheet showInView:self.view];
    }
    else
    {
        NSLog(@"missing fields");
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self submitPostVisibleToFriends:YES];
    }
    else if (buttonIndex == 1)
    {
        [self submitPostVisibleToFriends:NO];
    }
}



- (void)submitPostVisibleToFriends:(BOOL)isVisible
{
    [ProgressBarHelper displayIndeterminateProgressBarWithSelf:self];
    
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
    NSNumber *yearOfBottle = [formatter numberFromString:textField_yearOfBottle.text];
    
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (!error)
         {
             // Create a PFObject around PFFile and associate it with the current user
             PFObject *userPhoto = [PFObject objectWithClassName:@"Posts"];
             [userPhoto setObject:imageFile forKey:@"imageFile"];
             [userPhoto setObject:textField_typeOfWine.text forKey:@"wine_type"];
             [userPhoto setObject:textField_nameOfWine.text forKey:@"wine_name"];
             [userPhoto setObject:textField_originOfWine.text forKey:@"wine_origin"];
             [userPhoto setObject:yearOfBottle forKey:@"wine_year"];
             
             NSNumber *rating = [NSNumber numberWithInt:valueOfRating];
             [userPhoto setObject:rating forKey:@"wine_rating"];
             [userPhoto setObject:textField_comments.text forKey:@"post_title"];
             
             // set the access controll list to current user for security purposes
             [userPhoto setACL:[PFACL ACLWithUser:[PFUser currentUser]]];
             [userPhoto.ACL setPublicReadAccess:isVisible];      // <--- this line makes the post be visible to other users!
             
             [userPhoto setObject:[PFUser currentUser] forKey:@"user"];
             
             [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
              {
                  [ProgressBarHelper hideProgressBar:self];
                  if (!error)
                  {
                      NSLog(@"userPhoto saved!");
                      [self dismissViewControllerAnimated:YES completion:nil];
                  }
                  else
                  {
                      NSLog(@"error saving userPhoto. Error = %@ %@", error, [error userInfo]);
                  }
              }];
         }
         else
         {
             NSLog(@"error saving imageFile. Error = %@ %@", error, [error userInfo]);
             [ProgressBarHelper hideProgressBar:self];
         }
     }];
}

- (IBAction)button_cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Keyboard Stuff
// Call this to make the keyboard move everything up
- (void) keyboardWillShow: (NSNotification*) aNotification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    //CGRect rect = [[self view] frame];
    CGRect rect = [[self view] bounds];
    rect.origin.y -= 150;
    [[self view] setFrame: rect];
    [UIView commitAnimations];
}

// Call this to make the keyboard move everything down
- (void) keyboardWillHide: (NSNotification*) aNotification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect rect = [[self view] frame];
    //CGRect rect = [[self view] bounds];
    //NSLog(@"origin.y = %f", rect.origin.y);
    if (rect.origin.y == -150)   // for return after sign out
    {
        rect.origin.y += 150;
    }
    [[self view] setFrame: rect];
    [UIView commitAnimations];
}

- (void)dismissKeyboard
{
    [textField_comments resignFirstResponder];
    [textField_nameOfWine resignFirstResponder];
    [textField_originOfWine resignFirstResponder];
    [textField_typeOfWine resignFirstResponder];
    [textField_yearOfBottle resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismissKeyboard];
    [self button_uploadPicture:nil];
    
    return YES;
}

@end

#pragma mark - MyView
@implementation MyView

@synthesize controller;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (controller)
    {
        [controller dismissKeyboard];
    }
    [super touchesBegan:touches withEvent:event];
    
}


@end















































