//
//  PostObject.h
//  Connoisseur
//
//  Created by Eduardo Flores on 6/19/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostObject : NSObject

@property (nonatomic, copy) NSString *post_objectId;
@property (nonatomic, copy) NSString *post_title;
@property (nonatomic, copy) NSString *post_createdTimestamp;
@property (nonatomic, strong) NSDate *post_createdTimestampAsDate;
@property (nonatomic, strong) NSArray *post_rating;
@property (nonatomic, strong) NSData *post_image;
@property (nonatomic, copy) NSString *post_ownerFirstName;
@property (nonatomic, copy) NSString *post_ownerLastName;
@property (nonatomic, strong) NSData *post_ownerProfilePicture;
@property (nonatomic, strong) NSMutableArray *post_arrayOfComments;
@property (nonatomic, strong) UIImage *post_imageSquare;
@property (nonatomic, strong) NSNumber *post_ratingAverage;
@property (nonatomic, copy) NSString *post_wineOrigin;
@property (nonatomic, copy) NSString *post_wineName;
@property (nonatomic, copy) NSString *post_wineType;
@property (nonatomic, strong) NSNumber *post_wineYear;

@end
