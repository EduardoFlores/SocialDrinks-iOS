//
//  FindUsersTVC.h
//  Connoisseur
//
//  Created by Eduardo Flores on 6/22/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindUsersTVC : UITableViewController <UITextFieldDelegate>
{
    NSArray *arrayOfUsersFound;
    NSMutableArray *arrayOfExistingFriendsAsUserObject;
    //NSMutableArray *arrayOfExistingFriendsAsPFUser;
//    NSMutableArray *finalArrayOfFriends;
//    NSMutableArray *arrayOfExistingFriendsPFUser;
    NSMutableArray *arrayFriendIds;
    
    NSString *textEnteredUserToBeFound;
    UITextField *textField_textEntered;
}

- (void)buttonFollowUser:(id) sender;

@end
