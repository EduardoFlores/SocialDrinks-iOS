//
//  FindUsersTVC.m
//  Connoisseur
//
//  Created by Eduardo Flores on 6/22/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import "FindUsersTVC.h"
#import "EnterUserInfoCell.h"
#import "UserFoundCell.h"
#import <Parse/Parse.h>
#import "HelperMethods.h"
#import "UserObject.h"

@interface FindUsersTVC ()

@end

@implementation FindUsersTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    textField_textEntered.delegate = self;
    
    self.tableView.tableFooterView = [UIView new]; // to hide empty cells
    
    arrayOfUsersFound = [[NSArray alloc]init];
    
    //arrayOfExistingFriendsIDs = [[NSMutableArray alloc]init];
//    arrayOfExistingFriendsPFUser = [[NSMutableArray alloc]init];
//    finalArrayOfFriends = [[NSMutableArray alloc]init];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [arrayOfUsersFound count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        EnterUserInfoCell *cellEnteredInfo = [tableView dequeueReusableCellWithIdentifier:@"CellUserToFind" forIndexPath:indexPath];
        cellEnteredInfo.textField_nameUserToFind.delegate = self;
        
        return cellEnteredInfo;
    }
    else
    {
        UserFoundCell *cellUserFound = [tableView dequeueReusableCellWithIdentifier:@"CellUserFound" forIndexPath:indexPath];
        if ([arrayOfUsersFound count] > 0)
        {
            PFUser *user = [arrayOfUsersFound objectAtIndex:indexPath.row - 1];
            cellUserFound.label_userFoundName.text = [user objectForKey:@"name_first"];
            
            PFFile *imageFile = [user objectForKey:@"profile_picture"];
            NSData *imageData = [imageFile getData];
            [cellUserFound.imageView_userFoundProfilePicture setImage:[UIImage imageWithData:imageData]];
            
            UIButton *followButton = [cellUserFound button_followUser];
            [followButton setTag:indexPath.row - 1];
            [followButton addTarget:self
                             action:@selector(buttonFollowUser:)
                   forControlEvents:UIControlEventTouchUpInside];
            
        }
        return cellUserFound;
    }
}

// if we encounter a newline character return
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // enter closes the keyboard
    if ([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField_textEntered = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textEnteredUserToBeFound = textField.text;
}

- (IBAction)button_findUser:(id)sender
{
    [textField_textEntered resignFirstResponder];

    if ( ![textEnteredUserToBeFound isEqualToString:@""] && textEnteredUserToBeFound != nil)
    {
        PFQuery *queryForUsername = [PFUser query];
        [queryForUsername whereKey:@"lc_email" containsString:[textEnteredUserToBeFound lowercaseString]];
        
        PFQuery *queryForFirstName = [PFUser query];
        [queryForFirstName whereKey:@"lc_name_first" containsString:[textEnteredUserToBeFound lowercaseString]];
        
        PFQuery *queryForLastName = [PFUser query];
        [queryForLastName whereKey:@"lc_name_last" containsString:[textEnteredUserToBeFound lowercaseString]];
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[queryForUsername, queryForFirstName, queryForLastName]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             if (!error)
             {
                 //NSLog(@"objects found = %@", objects);
                 arrayOfUsersFound = objects;
                 [[self tableView]reloadData];
             }
         }];
    }
}

- (void)buttonFollowUser:(id) sender
{
    NSMutableArray *arrayOfFriendsToAdd = [[NSMutableArray alloc]init];
    //arrayOfExistingFriendsAsPFUser = [[NSMutableArray alloc]init];
    arrayFriendIds = [[NSMutableArray alloc]init];
    [arrayOfExistingFriendsAsUserObject removeAllObjects];

    arrayOfExistingFriendsAsUserObject = [NSMutableArray arrayWithArray:[HelperMethods getListOfFriends]];
    UIButton *button = (UIButton *)sender;
    
    PFUser *userToBeAdded = [arrayOfUsersFound objectAtIndex:button.tag];
    NSLog(@"user id = %@", [userToBeAdded objectId]);
    NSLog(@"userToBeAdded = %@", userToBeAdded);
    
    if ([arrayOfExistingFriendsAsUserObject count] > 0)
    {
        for (UserObject *userObject in arrayOfExistingFriendsAsUserObject)
        {
            if ( ![[userToBeAdded objectId]isEqual:[userObject object_id]] )
            {
                NSLog(@"we have a mismatch! (%@ != %@)", [userToBeAdded objectId], [userObject object_id]);
                
                // Convert userToBeAdded from PFUser to UserObject
                UserObject *user = [[UserObject alloc]init];
                
                user.name_first = [userToBeAdded objectForKey:@"name_first"];
                user.name_last = [userToBeAdded objectForKey:@"name_last"];
                user.email = [userToBeAdded objectForKey:@"email"];
                user.object_id = [userToBeAdded objectId];
                PFFile *profilePicture_file = [userToBeAdded objectForKey:@"profile_picture"];
                user.profile_picture = [profilePicture_file getData];
                
                [arrayOfFriendsToAdd addObject:user];
            }
        }
    }
    else    // no friends yet
    {
        // Convert userToBeAdded from PFUser to UserObject
        UserObject *user = [[UserObject alloc]init];
        
        user.name_first = [userToBeAdded objectForKey:@"name_first"];
        user.name_last = [userToBeAdded objectForKey:@"name_last"];
        user.email = [userToBeAdded objectForKey:@"email"];
        user.object_id = [userToBeAdded objectId];
        PFFile *profilePicture_file = [userToBeAdded objectForKey:@"profile_picture"];
        user.profile_picture = [profilePicture_file getData];
        
        [arrayOfFriendsToAdd addObject:user];
    }

    if ([arrayOfFriendsToAdd count] > 0)
        [arrayOfExistingFriendsAsUserObject addObjectsFromArray:arrayOfFriendsToAdd];
    
    // Convert array of UserObjects to array of PFUser objects
    for (UserObject *user in arrayOfExistingFriendsAsUserObject)
    {
        [arrayFriendIds addObject:[user object_id] ];
    }
    
    NSLog(@"arrayFriendIds = %@", arrayFriendIds);
    
    // Now save the array with all of the previous friends + the new friend
    PFUser *currentUser = [PFUser currentUser];
    [currentUser setObject:arrayFriendIds forKey:@"array_friends"];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (!error)
         {
             NSLog(@"friends saved!");
             [self button_findUser:nil];
         }
         else
         {
             NSLog(@"error saving friends. Error = %@ %@", error, [error userInfo]);
         }
     }];

    
    
//    NSMutableArray *arrayOfExistingFriends = [NSMutableArray arrayWithArray:[HelperMethods getListOfFriends]];
//    [arrayOfExistingFriends addObject:user];
//    NSLog(@"arrayOfExistingFriends = %@", arrayOfExistingFriends);
//    
//    for (UserObject *userObject in arrayOfExistingFriends)
//    {
//        NSLog(@"userObject = %@", userObject);
//        
//        if ([[userObject object_id]isEqual:[userToBeAdded objectId]])
//            NSLog(@"found a match!");
//    }

//    [finalArrayOfFriends removeAllObjects];
//    [finalArrayOfFriends addObjectsFromArray:arrayOfExistingFriendsPFUser];
//    
//    for (int i = 0; i < [arrayOfUsersFound count]; i++)
//    {
//        PFUser *singleUser = [arrayOfUsersFound objectAtIndex:i];
//        
//        NSLog(@"singUser = %@", [singleUser objectId]);
//        NSLog(@"userToBeAdded = %@", [userToBeAdded objectId]);
//        
//        if ( ![[singleUser objectId]isEqual:[userToBeAdded objectId]] )
//            [finalArrayOfFriends addObject:userToBeAdded];
//    }
//    
//    NSLog(@"finalArrayOfFriends = %@", finalArrayOfFriends);
//
//    // Now save the array with all of the previous friends + the new friend
//    PFUser *currentUser = [PFUser currentUser];
//    [currentUser setObject:finalArrayOfFriends forKey:@"array_friends"];
//    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
//     {
//         if (!error)
//         {
//             NSLog(@"friends saved!");
//             [self button_findUser:nil];
//         }
//         else
//         {
//             NSLog(@"error saving friends. Error = %@ %@", error, [error userInfo]);
//         }
//     }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 44;
    else
        return 70;
}

@end

















































