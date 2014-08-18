//
//  User.h
//  Connoisseur
//
//  Created by Eduardo Flores on 7/30/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * object_id;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * name_first;
@property (nonatomic, retain) NSString * name_last;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * createdAtAsString;
@property (nonatomic, retain) NSData * profile_picture;
@property (nonatomic, retain) NSString * email;

@end
