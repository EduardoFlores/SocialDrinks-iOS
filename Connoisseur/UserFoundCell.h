//
//  UserFoundCell.h
//  Connoisseur
//
//  Created by Eduardo Flores on 6/22/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserFoundCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView_userFoundProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *label_userFoundName;
@property (weak, nonatomic) IBOutlet UIButton *button_followUser;

@end
