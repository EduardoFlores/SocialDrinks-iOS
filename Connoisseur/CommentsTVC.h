//
//  CommentsTVC.h
//  Connoisseur
//
//  Created by Eduardo Flores on 6/19/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "UpdateCoreDataWithParseData.h"

@interface CommentsTVC : UITableViewController <UITextFieldDelegate, UpdateCoreDataDelegate, NSFetchedResultsControllerDelegate>
{
    NSString *commentText;
    UITextField *textFieldComment;
    NSMutableArray *arrayOfComments;
}
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, weak) Post *post;
@property (nonatomic, weak) NSData *imageData;
@property (nonatomic, weak) UIImage *imageSquare;
@property (nonatomic, copy) NSString *post_ownerFirstName;
@property (nonatomic, copy) NSString *post_ownerLastname;
@property (nonatomic, copy) NSString *post_objectId;


- (IBAction)button_postNewComment:(id)sender;
- (void) updateListOfComments;
@end
