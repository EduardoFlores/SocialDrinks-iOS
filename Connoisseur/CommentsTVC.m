//
//  CommentsTVC.m
//  Connoisseur
//
//  Created by Eduardo Flores on 6/19/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import "CommentsTVC.h"
#import "CommentImageCell.h"
#import "CommentNewCell.h"
#import "CommentListCell.h"
#import <Parse/Parse.h>
#import "Comment.h"
#import "ProgressBarHelper.h"
#import "PostFullImageVC.h"

@interface CommentsTVC ()

@end

@implementation CommentsTVC
@synthesize imageData, post_ownerFirstName, post_ownerLastname, post_objectId, imageSquare, post;
@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    
    textFieldComment.delegate = self;
    arrayOfComments = [NSMutableArray arrayWithArray:[post.comments allObjects]];
    _fetchedResultsController.delegate = self;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAtAsDate" ascending:NO];
    [arrayOfComments sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    self.tableView.tableFooterView = [UIView new]; // to hide empty cells
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrayOfComments count] + 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentImageCell *commentCell;
    CommentNewCell *commentNewCell;
    CommentListCell *commentList;
    Comment *comment;
    
    UIImage *image = [UIImage imageWithData:imageData];
    
    switch (indexPath.row)
    {
        case 0:
            commentCell = [tableView dequeueReusableCellWithIdentifier:@"CellCommentImage" forIndexPath:indexPath];
            commentCell.imageView_commentsMainImage.image = image;
            commentCell.label_postOwnerName.text = [NSString stringWithFormat:@"%@ %@", post_ownerFirstName, post_ownerLastname];
            commentCell.label_yearAndName.text = [NSString stringWithFormat:@"%@ %@", post.wine_year, post.wine_name];
            commentCell.label_typeAndFrom.text = [NSString stringWithFormat:@"%@ from %@", post.wine_type, post.wine_origin];
            return commentCell;
            break;
        case 1:
            commentNewCell = [tableView dequeueReusableCellWithIdentifier:@"CellCommentNew" forIndexPath:indexPath];
            commentNewCell.textField_commentNewText.delegate = self;
            return commentNewCell;
            break;
        default:
            commentList = [tableView dequeueReusableCellWithIdentifier:@"CellCommentList" forIndexPath:indexPath];
            comment = [arrayOfComments objectAtIndex:( indexPath.row - 2)];
            commentList.label_commentOwnerFirstAndLastName.text = [NSString stringWithFormat:@"%@ %@",
                                                                   [comment owner_firstName],
                                                                   [comment owner_lastName]];
            commentList.label_commentDateAndTime.text = [comment createdAt];
            commentList.label_commentText.text = [comment text];
            
            //[commentList.label_commentText sizeToFit];  // this sets the label to start on top left corner
            
            return commentList;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            return 320;
            break;
        case 1:
            return 40;
            break;
        default:
            return 80;
            break;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textFieldComment = textField;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    commentText = textField.text;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        // present view modally to display picture at full screen
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
        PostFullImageVC *pfivc = [storyboard instantiateViewControllerWithIdentifier:@"PostFullImage"];
        pfivc.imageData = imageData;
        
        [self presentViewController:pfivc animated:YES completion:nil];
    }
}

- (IBAction)button_postNewComment:(id)sender
{
    [ProgressBarHelper displayIndeterminateProgressBarWithSelf:self];
    
    [textFieldComment resignFirstResponder];
    
    PFUser *user = [PFUser currentUser];
    
    // Create a PFObject and associate it with the current user
    PFObject *comments = [PFObject objectWithClassName:@"Comments"];
    [comments setObject: commentText forKey:@"comment_text"];
    [comments setObject:[user username] forKey:@"comment_owner"];
    [comments setObject:[PFObject objectWithoutDataWithClassName:@"Posts" objectId:post_objectId] forKey:@"post_parent"];
    [comments setObject:post_objectId forKey:@"post_parent_objectId"];
    
    // set the access controll list to current user for security purposes
    [comments setACL:[PFACL ACLWithUser:[PFUser currentUser]]];
    [comments setObject:[PFUser currentUser] forKey:@"user"];
    
    BOOL succeeded = [comments save];
    
    if (succeeded)
        [self updateListOfComments];
    else
        NSLog(@"couldn't save the comment");
}

- (void)updateListOfComments
{
    NSDate *basicDate;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:01];
    [comps setMonth:01];
    [comps setYear:2000];
    basicDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    UpdateCoreDataWithParseData *update = [[UpdateCoreDataWithParseData alloc]init];
    update.delegate = self;
    [update updateDataWithContext:self.managedObjectContext
         fetchedResultsController:_fetchedResultsController
                   lastObjectDate:basicDate];
}

- (void)updateComplete
{
    arrayOfComments = [NSMutableArray arrayWithArray:[post.comments allObjects]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAtAsDate" ascending:NO];
    [arrayOfComments sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    [ProgressBarHelper hideProgressBar:self];
    [[self tableView]reloadData];
}


- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    switch (type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
        {
            [self tableView:tableView cellForRowAtIndexPath:indexPath];
        }
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
    }
}
@end


















































