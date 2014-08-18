//
//  TimelinePostPreviewVC.h
//  Connoisseur
//
//  Created by Eduardo Flores on 6/17/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelinePostPreviewVC : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate>
{
    int valueOfRating;
    UIPickerView *pickerView_typesOfWine;
    UIPickerView *pickerView_yearsOfWine;
    NSArray *arrayTypeOfWines;
    NSMutableArray *arrayOfYears;
    int currentYear;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView_postThumbnail;
@property (nonatomic, weak) NSData *imageData;

@property (weak, nonatomic) IBOutlet UILabel *label_rateThisWine;
@property (weak, nonatomic) IBOutlet UILabel *label_valueOfRating;
@property (weak, nonatomic) IBOutlet UISlider *slider_ratingSlider;
@property (weak, nonatomic) IBOutlet UITextField *textField_typeOfWine;
@property (weak, nonatomic) IBOutlet UITextField *textField_nameOfWine;
@property (weak, nonatomic) IBOutlet UITextField *textField_yearOfBottle;
@property (weak, nonatomic) IBOutlet UITextField *textField_originOfWine;
@property (weak, nonatomic) IBOutlet UITextField *textField_comments;

- (IBAction)button_uploadPicture:(id)sender;
- (IBAction)button_cancel:(id)sender;

- (void)sliderValueChanged:(UISlider *)slider;
- (void) addKeyboardObservers;
- (void) dismissKeyboard;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void) setPickerViews;
- (void) setArrayValues;
- (void) submitPostVisibleToFriends:(BOOL)isVisible;

@end

@interface MyView : UIView

@property (weak, nonatomic) IBOutlet TimelinePostPreviewVC *controller;

@end