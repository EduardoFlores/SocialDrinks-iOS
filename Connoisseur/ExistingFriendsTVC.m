//
//  ExistingFriendsTVC.m
//  Connoisseur
//
//  Created by Eduardo Flores on 7/30/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import "ExistingFriendsTVC.h"
#import "ProgressBarHelper.h"
#import <Parse/Parse.h>
#import "UserObject.h"
#import "ExistingFriendCell.h"
#import "HelperMethods.h"

@interface ExistingFriendsTVC ()

@end

@implementation ExistingFriendsTVC

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
    
    self.tableView.tableFooterView = [UIView new]; // to hide empty cells
    
    [ProgressBarHelper displayIndeterminateProgressBarWithSelf:self];
    
    dispatch_queue_t loadQ = dispatch_queue_create("FriendsQueue", NULL);
    dispatch_async(loadQ,
       ^{
           arrayOfUsers = [HelperMethods getListOfFriends];
           
           dispatch_async(dispatch_get_main_queue(),
              ^{
                  [[self tableView]reloadData];
                  [ProgressBarHelper hideProgressBar:self];
              });
       });
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
    return [arrayOfUsers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExistingFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellFriend" forIndexPath:indexPath];
    
    // Configure the cell...
    UserObject *user = [arrayOfUsers objectAtIndex:indexPath.row];
    
    cell.label_friendName.text = [NSString stringWithFormat:@"%@ %@", user.name_first, user.name_last];
    cell.label_friendEmail.text = user.email;
    
    UIImage *profilePic = [UIImage imageWithData:user.profile_picture];
    cell.imageView_profilePicture.image = [HelperMethods squareImageWithImage:profilePic scaledToSize:CGSizeMake(125, 125)];
    // convert imageview to circle
    cell.imageView_profilePicture.layer.cornerRadius = cell.imageView_profilePicture.frame.size.width / 2;
    cell.imageView_profilePicture.clipsToBounds = YES;
    
    return cell;
}

@end

















































