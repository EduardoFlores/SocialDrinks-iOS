//
//  ExistingFriendCell.h
//  Connoisseur
//
//  Created by Eduardo Flores on 7/30/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExistingFriendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView_profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *label_friendName;
@property (weak, nonatomic) IBOutlet UILabel *label_friendEmail;
@end
