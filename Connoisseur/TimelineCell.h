//
//  TimelineCell.h
//  Connoisseur
//
//  Created by Eduardo Flores on 6/19/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView_userProfilePicture;
@property (weak, nonatomic) IBOutlet UILabel *label_userName;
@property (weak, nonatomic) IBOutlet UILabel *label_postTimestamp;
@property (weak, nonatomic) IBOutlet UILabel *label_postTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_postImage;
@property (weak, nonatomic) IBOutlet UILabel *label_postComments;
@property (weak, nonatomic) IBOutlet UILabel *label_postRating;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_ratingBackground;


@end
