//
//  TimelineTVC.h
//  Connoisseur
//
//  Created by Eduardo Flores on 6/17/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ProgressBarHelper.h"
#import "UpdateCoreDataWithParseData.h"

@interface TimelineTVC : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, NSFetchedResultsControllerDelegate, UpdateCoreDataDelegate>
{
    NSData *imageData;
    NSMutableArray *arrayOfPosts;
    NSMutableArray *arrayOfCommentsTotalPerPost;
    UIImage *imageSquare;
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsControllerForComments;

@property (nonatomic, strong) NSDate *lastObjectDate;

- (IBAction)button_takePicture:(id)sender;
- (void) startCamera;

//- (void) getDataFromParse;
//- (void) saveManagedObjectContext;
//- (BOOL) isCommentInCoreDataWithObjectId:(NSString *)objectId;
//- (BOOL) isPostInCoreDataWithObjectId:(NSString *)objectId;

@end
