//
//  MyProfileVC.m
//  Connoisseur
//
//  Created by Eduardo Flores on 6/17/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import "MyProfileVC.h"
#import <Parse/Parse.h>
#import "ProgressBarHelper.h"
#include "DefinitionHelper.h"
#import "HelperMethods.h"

@interface MyProfileVC ()

@end

@implementation MyProfileVC
@synthesize button_changeProfilePicture, imageView_profilePicture;
@synthesize textField_firstName, textField_lastName;

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
    // Do any additional setup after loading the view.
    
    imageView_profilePicture.image = [UIImage imageNamed:@"man_silhouette"];
    
    [self setValuesForElementsInView];
}

- (void)setValuesForElementsInView
{
    [ProgressBarHelper displayIndeterminateProgressBarWithSelf:self];
    
    button_changeProfilePicture.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button_changeProfilePicture.titleLabel.textAlignment = NSTextAlignmentCenter; // if you want to
    [button_changeProfilePicture setTitle: @"Change Your\nProfile Picture" forState: UIControlStateNormal];
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:[[PFUser currentUser] objectId]];
    // this query should only find 1 object anyways
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            PFUser *user = [objects firstObject];
            textField_firstName.text = [user objectForKey:@"name_first"];
            textField_lastName.text = [user objectForKey:@"name_last"];
            
            PFFile *image = [user objectForKey:@"profile_picture"];
            [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
            {
                if (!error)
                {
                    data_profilePicture = data;
                    UIImage *picture = [UIImage imageWithData:data_profilePicture];
                    //imageView_profilePicture.image = picture;
                    
                    // crop image to square
                    UIImage *pictureSquare = [HelperMethods squareImageWithImage:picture scaledToSize:CGSizeMake(125, 125)];
                    
                    // convert imageview to circle
                    imageView_profilePicture.layer.cornerRadius = self.imageView_profilePicture.frame.size.width / 2;
                    imageView_profilePicture.clipsToBounds = YES;
                    
                    // add border to circular image
                    //imageView_profilePicture.layer.borderWidth = 3.0f;
                    //imageView_profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
                    
                    // add picture
                    imageView_profilePicture.image = pictureSquare;
                }
            }];
            
            [ProgressBarHelper hideProgressBar:self];
        }
        else
        {
            NSLog(@"error finding user. Error = %@ %@", error, [error userInfo]);
        }
    }];
    
    
}

- (void) startCamera
{
    // check if the device has a camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES)
    {
        // Create image picker controller
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        
        // set source to the camera
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        // Delegate is self
        imagePicker.delegate = self;
        
        // show image picker
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else    // device doesn't have a camera!
    {
        // something for devices that don't have a camera.
        // for now, those devices are screwed
        // seriously, WTF?
    }
    
    // resize image
    UIGraphicsBeginImageContext(CGSizeMake(PICTURE_WIDTH, PICTURE_HEIGTH));
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // dismiss the controller
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // resize the image
    UIGraphicsBeginImageContext(CGSizeMake(PICTURE_WIDTH, PICTURE_HEIGTH));
    [image drawInRect:CGRectMake(0, 0, PICTURE_WIDTH, PICTURE_HEIGTH)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // get resized image
    data_profilePicture = UIImageJPEGRepresentation(smallImage, 0.05f);
    
    UIImage *picture = [UIImage imageWithData:data_profilePicture];
    imageView_profilePicture.image = picture;
}

- (IBAction)button_changeProfilePicture:(id)sender
{
    [self startCamera];
}

- (IBAction)button_saveChanges:(id)sender
{
    [ProgressBarHelper displayIndeterminateProgressBarWithSelf:self];
    
    PFFile *imageFile = [PFFile fileWithName:@"profile_picture.jpg" data:data_profilePicture];
    //newUserParseObject[@"profile_picture"] = imageFile;
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (!error)
         {
             NSLog(@"profile image saved!");
             
             // After the imageFile has been uploaded, update the PFUser
             PFUser *user = [PFUser currentUser];
             user[@"name_first"] = [textField_firstName text];
             user[@"name_last"] = [textField_lastName text];
             [user setObject:imageFile forKey:@"profile_picture"];
             
             [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
             {
                 [ProgressBarHelper hideProgressBar:self];
                 if (!error)
                 {
                     NSLog(@"should've saved the object");
                 }
                 else
                 {
                     NSLog(@"error updating user");
                 }
             }];
         }
         else
         {
             NSLog(@"error saving imageFile");
             [ProgressBarHelper hideProgressBar:self];
         }
     }];
}

@end

















































