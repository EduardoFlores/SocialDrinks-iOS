//
//  HelperMethods.m
//  Connoisseur
//
//  Created by Eduardo Flores on 6/30/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import "HelperMethods.h"
#import <Parse/Parse.h>
#import "UserObject.h"

@implementation HelperMethods

+ (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
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

+ (NSArray *)getListOfFriends
{
    NSArray *arrayOfFriendObjectId = [[NSArray alloc]init];
    NSMutableArray *arrayOfUsers = [[NSMutableArray alloc]init];
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:[[PFUser currentUser] objectId]];
    // this query should only find 1 object
    
    PFUser *currentUser = [[query findObjects]firstObject];
    arrayOfFriendObjectId = [currentUser objectForKey:@"array_friends"];
    
    NSSet *uniqueStates = [NSSet setWithArray:arrayOfFriendObjectId];
    arrayOfFriendObjectId = [uniqueStates allObjects];
    NSLog(@"arrayOfFriendObjectId in helperMethods = %@", arrayOfFriendObjectId);

    for (NSString *singleObjectId in arrayOfFriendObjectId)
    {
        UserObject *user = [[UserObject alloc]init];
        PFQuery *queryUsers = [PFUser query];
        [queryUsers whereKey:@"objectId" equalTo:singleObjectId];
        
        PFUser *singleUser = [[queryUsers findObjects]firstObject]; // this should only return 1 object, which is from the PFUser class
        user.name_first = [singleUser objectForKey:@"name_first"];
        user.name_last = [singleUser objectForKey:@"name_last"];
        user.email = [singleUser objectForKey:@"email"];
        user.object_id = [singleUser objectId];
        PFFile *profilePicture_file = [singleUser objectForKey:@"profile_picture"];
        user.profile_picture = [profilePicture_file getData];
        
        [arrayOfUsers addObject:user];
    }
    NSLog(@"arrayOfUsers in helperMethods = %@", arrayOfUsers);
    return arrayOfUsers;
}

@end
