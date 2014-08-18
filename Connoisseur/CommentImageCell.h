//
//  CommentImageCell.h
//  Connoisseur
//
//  Created by Eduardo Flores on 6/19/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView_commentsMainImage;
@property (weak, nonatomic) IBOutlet UILabel *label_postOwnerName;
@property (weak, nonatomic) IBOutlet UILabel *label_yearAndName;
@property (weak, nonatomic) IBOutlet UILabel *label_typeAndFrom;

@end
