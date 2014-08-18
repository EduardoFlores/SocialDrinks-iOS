//
//  Comment.h
//  Connoisseur
//
//  Created by Eduardo Flores on 7/28/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Post;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * createdAt;
@property (nonatomic, retain) NSDate * createdAtAsDate;
@property (nonatomic, retain) NSString * object_id;
@property (nonatomic, retain) NSString * owner_firstName;
@property (nonatomic, retain) NSString * owner_lastName;
@property (nonatomic, retain) NSData * owner_profilePicture;
@property (nonatomic, retain) NSData * owner_profilePictureSquare;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Post *post;

@end
