//
//  CommentObject.h
//  Connoisseur
//
//  Created by Eduardo Flores on 6/19/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface CommentObject : NSObject

@property (nonatomic, copy) NSString *comment_objectId;
@property (nonatomic, copy) NSString *comment_text;
@property (nonatomic, copy) NSString *comment_userOwner;
@property (nonatomic, strong) PFUser *comment_PFUser;

@end
