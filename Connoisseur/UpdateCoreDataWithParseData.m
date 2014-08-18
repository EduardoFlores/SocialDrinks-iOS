//
//  UpdateCoreDataWithParseData.m
//  Connoisseur
//
//  Created by Eduardo Flores on 7/31/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import "UpdateCoreDataWithParseData.h"
#import <Parse/Parse.h>
#import "Post.h"
#import "Comment.h"

@implementation UpdateCoreDataWithParseData
@synthesize delegate;

-(void)updateDataWithContext:(NSManagedObjectContext *)managedObjectContext
    fetchedResultsController:(NSFetchedResultsController *)resultsController
              lastObjectDate:(NSDate *)lastObjectDate
{
    NSError *error = nil;
    if ( ![[self fetchedResultsControllerWithContext:managedObjectContext
                            fetchedResultsController:resultsController]performFetch:&error])
    {
        NSLog(@"error fetching results. Error = %@", error);
    }
    
    // Get Posts from all friends
    PFQuery *query = [PFUser query];
    [query includeKey:@"array_friends"];
    [query getObjectInBackgroundWithId:[[PFUser currentUser] objectId]
                                 block:^(PFObject *userWithFriends, NSError *error)
     {
         NSArray *friendsArray = userWithFriends[@"array_friends"];
         //NSLog(@"allFriendsObjects = %@", allFriendsObjects);
         
         NSMutableArray *allFriendsObjects = [[NSMutableArray alloc]init];
         for (PFUser *friend in friendsArray)
         {
             [allFriendsObjects addObject:friend];
         }
         [allFriendsObjects addObject:[PFUser currentUser]];
         
         PFQuery *postsQuery = [PFQuery queryWithClassName:@"Posts"];
         [postsQuery whereKey:@"user" containedIn:allFriendsObjects];
         [postsQuery whereKey:@"createdAt" greaterThan:lastObjectDate];
         
         NSArray *postObjects = [postsQuery findObjects];
         
//         [postsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
//          {
//              if (!error)
//              {
                  for (PFObject *eachObject in postObjects)
                  {
                      if ( ![self isPostInCoreDataWithObjectId:[eachObject objectId] managedObjectContext:managedObjectContext])
                      {
                          // Create a new namaged object each time
                          Post *newPost = (Post *) [NSEntityDescription insertNewObjectForEntityForName:@"Post"
                                                                                 inManagedObjectContext:managedObjectContext];
                          
                          NSLog(@"new post object added to core data");
                          
                          PFFile *imageFile = [eachObject objectForKey:@"imageFile"];
                          PFUser *owner = [eachObject objectForKey:@"user"];
                          [owner fetchIfNeeded];
                          PFFile *profilePictureFile = [owner objectForKey:@"profile_picture"];
                          NSData *profilePictureData = [profilePictureFile getData];
                          
                          [newPost setObject_id:[eachObject objectId]];
                          [newPost setImage:[imageFile getData]];
                          [newPost setOwner_firstName:[owner objectForKey:@"name_first"]];
                          [newPost setOwner_lastName:[owner objectForKey:@"name_last"]];
                          [newPost setOwner_profilePicture:profilePictureData];
                          [newPost setCreatedTimestampAsDate:[eachObject createdAt]];
                          [newPost setCreatedTimestamp:[self convertDateToLocalDate:[eachObject createdAt]]];
                          [newPost setTitle:[eachObject objectForKey:@"post_title"]];
                          
                          [newPost setWine_name:[eachObject objectForKey:@"wine_name"]];
                          [newPost setWine_origin:[eachObject objectForKey:@"wine_origin"]];
                          [newPost setWine_type:[eachObject objectForKey:@"wine_type"]];
                          [newPost setWine_year:[eachObject objectForKey:@"wine_year"]];
                          [newPost setRating:[eachObject objectForKey:@"wine_rating"]];
                      }
                  }
//              }
//          }];
         
         
         // Get comments
         NSArray *allPosts = [[self fetchedResultsControllerWithContext:managedObjectContext
                                               fetchedResultsController:resultsController]fetchedObjects];
         for (Post *singlePost in allPosts)
         {
             NSDate *timestampNewestComment;
             NSDateComponents *comps = [[NSDateComponents alloc] init];
             [comps setDay:01];
             [comps setMonth:01];
             [comps setYear:2000];
             timestampNewestComment = [[NSCalendar currentCalendar] dateFromComponents:comps];
             
             NSArray *allComments = [singlePost.comments allObjects];
             for (Comment *singleComment in allComments)
             {
                 if (singleComment.createdAtAsDate > timestampNewestComment)
                     timestampNewestComment = singleComment.createdAtAsDate;
             }
             
             NSLog(@"newest comment timestamp = %@", timestampNewestComment);
             
             PFQuery *queryComments = [PFQuery queryWithClassName:@"Comments"];
             [queryComments whereKey:@"post_parent_objectId" equalTo:[singlePost object_id]];
             [queryComments whereKey:@"createdAt" greaterThan:timestampNewestComment];
             
             [queryComments orderByAscending:@"createdAt"];
             [queryComments includeKey:@"user"];
             
             NSArray *commentObjects = [queryComments findObjects];
//             [queryComments findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
//              {
//                  if (!error)
//                  {
                      for (PFObject *commentPFObject in commentObjects)
                      {
                          if ( ![self isCommentInCoreDataWithObjectId:[commentPFObject objectId] managedObjectContext:managedObjectContext])
                          {
                              Comment *newComment = (Comment *) [NSEntityDescription insertNewObjectForEntityForName:@"Comment"
                                                                                              inManagedObjectContext:managedObjectContext];
                              
                              [newComment setText:[commentPFObject objectForKey:@"comment_text"]];
                              [newComment setObject_id:[commentPFObject objectId]];
                              [newComment setCreatedAtAsDate:[commentPFObject createdAt]];
                              [newComment setCreatedAt:[self convertDateToLocalDate:[commentPFObject createdAt]]];
                              
                              PFUser *commentUser = [commentPFObject objectForKey:@"user"];
                              [commentUser fetchIfNeeded];
                              [newComment setOwner_firstName:[commentUser objectForKey:@"name_first"]];
                              [newComment setOwner_lastName:[commentUser objectForKey:@"name_last"]];
                              
                              newComment.post = singlePost;
                          }
                      }
                      
                      [self saveManagedObjectContextWithContext:managedObjectContext];
//                      [delegate updateComplete];
//                  }
//              }];

         }
         [delegate updateComplete];

     }];

}// end method updateDataWithContext

- (NSFetchedResultsController *)fetchedResultsControllerWithContext:(NSManagedObjectContext *)managedObjectContext
                                           fetchedResultsController:(NSFetchedResultsController *)resultsController
{
    if (resultsController != nil)
        return resultsController;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Post" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdTimestampAsDate"
                                                                   ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:managedObjectContext
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];
    
    //_fetchedResultsController.delegate = self;
    return resultsController;
}


- (void) saveManagedObjectContextWithContext:(NSManagedObjectContext *)managedObjectContext
{
    // Save
    NSError *error = nil;
    NSManagedObjectContext *context = managedObjectContext;
    if (![context save:&error])
    {
        NSLog(@"Error in JobListTVC saveManagedObjectContext = %@", error);
    }
}


- (BOOL)isCommentInCoreDataWithObjectId:(NSString *)objectId managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    BOOL answer = NO;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Comment"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"object_id = %@", objectId]];
    [request setFetchLimit:1];
    
    NSError *error = nil;
    NSUInteger count = [managedObjectContext countForFetchRequest:request error:&error];
    
    if (count == 1)
    {
        answer = YES;
        return answer;
    }
    else
        return answer;
}

- (BOOL)isPostInCoreDataWithObjectId:(NSString *)objectId managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    BOOL answer = NO;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"object_id = %@", objectId]];
    [request setFetchLimit:1];
    
    NSError *error = nil;
    NSUInteger count = [managedObjectContext countForFetchRequest:request error:&error];
    
    if (count == 1)
    {
        answer = YES;
        return answer;
    }
    else
        return answer;
}



















#pragma mark - Extra helper methods
- (NSString *) convertDateToLocalDate:(NSDate *)date_timestamp
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone: [NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss -0000"];
    
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"M/d/yy', 'h:mma"];
    NSString *finalDateTimestamp = [dateFormatter stringFromDate:date_timestamp];
    
    return finalDateTimestamp;
}

@end



















































