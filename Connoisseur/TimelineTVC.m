//
//  TimelineTVC.m
//  Connoisseur
//
//  Created by Eduardo Flores on 6/17/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import "TimelineTVC.h"
#import "TimelinePostPreviewVC.h"
#import "PostPreviewTVC.h"
#import "TimelineCell.h"
#import <Parse/Parse.h>
#import "PostObject.h"
#import "DefinitionHelper.h"
#import "CommentsTVC.h"
#import "CommentObject.h"
#import "HelperMethods.h"
#import "Post.h"
#import "Comment.h"

@interface TimelineTVC ()

@end

@implementation TimelineTVC
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)updateComplete
{
    NSLog(@"in update complete");
    [self stopRefresh];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
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
    
    self.tableView.tableFooterView = [UIView new]; // to hide empty cells
        
    
    _fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if ( ![[self fetchedResultsController]performFetch:&error])
    {
        NSLog(@"error fetching results. Error = %@", error);
    }
    
    [self getDataFromParse];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self
                action:@selector(getDataFromParse)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
}

- (void)stopRefresh
{
    NSLog(@"in stoprefresh");
    [self.refreshControl endRefreshing];
    [ProgressBarHelper hideProgressBar:self];
    [[self tableView]reloadData];
    
    //[self saveManagedObjectContext];
}

- (void)getDataFromParse
{
    [ProgressBarHelper displayIndeterminateProgressBarWithSelf:self];

    UpdateCoreDataWithParseData *update = [[UpdateCoreDataWithParseData alloc]init];
    update.delegate = self;
    [update updateDataWithContext:self.managedObjectContext
         fetchedResultsController:_fetchedResultsController
                   lastObjectDate:self.lastObjectDate];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[[self fetchedResultsController]sections]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> secInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [secInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimelineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellTimeline" forIndexPath:indexPath];
    
    // Configure the cell...
    Post *post = [[self fetchedResultsController]objectAtIndexPath:indexPath];
    
    //[cell.label_postTitle sizeToFit];
    cell.label_postTitle.text = post.title;
    
    UIImage *imageNormal = [UIImage imageWithData:[post owner_profilePicture]];
    
    cell.imageView_userProfilePicture.image = [HelperMethods squareImageWithImage:imageNormal scaledToSize:CGSizeMake(125, 125)];
    
    // convert imageview to circle
    cell.imageView_userProfilePicture.layer.cornerRadius = cell.imageView_userProfilePicture.frame.size.width / 2;
    cell.imageView_userProfilePicture.clipsToBounds = YES;
    
    cell.label_userName.text = [NSString stringWithFormat:@"%@ %@", [post owner_firstName], [post owner_lastName]];
    
    cell.label_postTimestamp.text = post.createdTimestamp;
    cell.label_postComments.text = [NSString stringWithFormat:@"%d comments", post.comments.count];
    cell.label_postRating.text = [NSString stringWithFormat:@"%@", post.rating];
    
    UIImage *image = [UIImage imageWithData:[post image]];
    cell.imageView_postImage.image = image;
    
    if ([post.rating intValue] < 50)
    {
        UIImage *ratingBackground = [UIImage imageNamed:@"circle-red"];
        cell.imageView_ratingBackground.image = ratingBackground;
    }
    if ([post.rating intValue] > 49  && [post.rating intValue] < 86)
    {
        UIImage *ratingBackground = [UIImage imageNamed:@"circle-blue"];
        cell.imageView_ratingBackground.image = ratingBackground;
    }
    if ([post.rating intValue] > 85)
    {
        UIImage *ratingBackground = [UIImage imageNamed:@"circle-green"];
        cell.imageView_ratingBackground.image = ratingBackground;
    }
    
    return cell;
}

- (IBAction)button_takePicture:(id)sender
{
    [self startCamera];
}

- (void) startCamera
{
    // check if the device has a camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES)
    {
        // ORIGINAL CODE - WORKS BUT ITS RECTANGULAR
        // Create image picker controller
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        
        // set source to the camera
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        // Delegate is self
        imagePicker.delegate = self;
        
        imagePicker.allowsEditing = YES;
        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        
        // show image picker
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else    // device doesn't have a camera!
    {
        // something for devices that don't have a camera.
        // for now, those devices are screwed
        NSLog(@"Umm, your device doesn't have a camera");
    }
    
    // resize image
    UIGraphicsBeginImageContext(CGSizeMake(PICTURE_WIDTH, PICTURE_HEIGTH));
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSLog(@"image size width = %f", image.size.width);
    NSLog(@"image size height = %f", image.size.height);
    
//    // dismiss the controller
//    [picker dismissViewControllerAnimated:YES completion:^{
//        [self presentPostTimelinePreview];
//    }];
//    
    // resize the image
    UIGraphicsBeginImageContext(CGSizeMake(PICTURE_WIDTH, PICTURE_HEIGTH));
    [image drawInRect:CGRectMake(0, 0, PICTURE_WIDTH, PICTURE_HEIGTH)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    // convert image to square
    CGSize sizeSquare = CGSizeMake(PICTURE_SQUARE_WIDTH, PICTURE_SQUARE_HEIGTH);
    imageSquare = [self squareImageWithImage:smallImage scaledToSize:sizeSquare];
    
    // get resized image
    imageData = UIImageJPEGRepresentation(imageSquare, 0.05f);

    
    // dismiss the controller
    [picker dismissViewControllerAnimated:YES completion:^{
        [self presentPostTimelinePreview];
    }];
    
}

- (void) presentPostTimelinePreview
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    TimelinePostPreviewVC *tlppvc = [storyboard instantiateViewControllerWithIdentifier:@"postVC"];
    
    tlppvc.imageData = imageData; //UIImageJPEGRepresentation(imageSquare, 1.0f) ;
    
    [self presentViewController:tlppvc animated:YES completion:nil];
    
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
//    UINavigationController *nav = [storyboard instantiateViewControllerWithIdentifier:@"postPreviewTVC"];
//    PostPreviewTVC *postPreviewTVC = [[nav viewControllers]firstObject];
//    postPreviewTVC.imageData = imageData;
//    [self presentViewController:nav animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if ([[segue identifier]isEqualToString:@"segueToComments"])
    {
        Post *post = [[self fetchedResultsController]objectAtIndexPath:indexPath];
        CommentsTVC *ctvc = [segue destinationViewController];

//        NSArray *comments = [post post_arrayOfComments];
        
        ctvc.post = post;
        ctvc.imageData = [post image];
        ctvc.post_ownerFirstName = [post owner_firstName];
        ctvc.post_ownerLastname = [post owner_lastName];
        ctvc.post_objectId = [post object_id];
        
        ctvc.managedObjectContext = self.managedObjectContext;
        ctvc.fetchedResultsController = self.fetchedResultsController;
        
        //NSArray *allCommentsInArray = [post.comments allObjects];
        
//        for (Comment *comment in post.comments)
//        {
//            NSLog(@"comment text = %@", comment.text);
//        }
        //NSLog(@"allCommentsInArray = %@", allCommentsInArray);
        //ctvc.arrayOfComments = allCommentsInArray;
    }
}

#pragma mark - Crop Image to square
- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height)
    {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Core Data
//- (void) saveManagedObjectContext
//{
//    // Save
//    NSError *error = nil;
//    NSManagedObjectContext *context = [self managedObjectContext];
//    if (![context save:&error])
//    {
//        NSLog(@"Error in JobListTVC saveManagedObjectContext = %@", error);
//    }
//}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
        return _fetchedResultsController;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Post" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdTimestampAsDate"
                                                                   ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:self.managedObjectContext
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
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
            TimelineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellTimeline" forIndexPath:indexPath];
            Post *post = [[self fetchedResultsController]objectAtIndexPath:indexPath];
            UIImage *imageNormal = [UIImage imageWithData:[post owner_profilePicture]];
            cell.imageView_userProfilePicture.image = [HelperMethods squareImageWithImage:imageNormal scaledToSize:CGSizeMake(125, 125)];
            // convert imageview to circle
            cell.imageView_userProfilePicture.layer.cornerRadius = cell.imageView_userProfilePicture.frame.size.width / 2;
            cell.imageView_userProfilePicture.clipsToBounds = YES;
            cell.label_userName.text = [NSString stringWithFormat:@"%@ %@", [post owner_firstName], [post owner_lastName]];
            cell.label_postTitle.text = post.title;
            [cell.label_postTitle sizeToFit];
            cell.label_postTimestamp.text = post.createdTimestamp;
            cell.label_postComments.text = [NSString stringWithFormat:@"%d comments", post.comments.count];
            UIImage *image = [UIImage imageWithData:[post image]];
            cell.imageView_postImage.image = image;
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

//- (BOOL)isCommentInCoreDataWithObjectId:(NSString *)objectId
//{
//    BOOL answer = NO;
//    
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Comment"];
//    [request setPredicate:[NSPredicate predicateWithFormat:@"object_id = %@", objectId]];
//    [request setFetchLimit:1];
//    
//    NSError *error = nil;
//    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];
//    
//    if (count == 1)
//    {
//        answer = YES;
//        return answer;
//    }
//    else
//        return answer;
//}
//
//- (BOOL)isPostInCoreDataWithObjectId:(NSString *)objectId
//{
//    BOOL answer = NO;
//    
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
//    [request setPredicate:[NSPredicate predicateWithFormat:@"object_id = %@", objectId]];
//    [request setFetchLimit:1];
//    
//    NSError *error = nil;
//    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];
//    
//    if (count == 1)
//    {
//        answer = YES;
//        return answer;
//    }
//    else
//        return answer;
//}

@end


















































