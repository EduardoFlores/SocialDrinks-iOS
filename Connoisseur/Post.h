//
//  Post.h
//  Connoisseur
//
//  Created by Eduardo Flores on 8/5/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment;

@interface Post : NSManagedObject

@property (nonatomic, retain) NSString * createdTimestamp;
@property (nonatomic, retain) NSDate * createdTimestampAsDate;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * object_id;
@property (nonatomic, retain) NSString * owner_firstName;
@property (nonatomic, retain) NSString * owner_lastName;
@property (nonatomic, retain) NSData * owner_profilePicture;
@property (nonatomic, retain) NSData * owner_profilePictureSquare;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * wine_name;
@property (nonatomic, retain) NSString * wine_origin;
@property (nonatomic, retain) NSString * wine_type;
@property (nonatomic, retain) NSNumber * wine_year;
@property (nonatomic, retain) NSSet *comments;
@end

@interface Post (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

@end
