//
//  CommentImageCell.m
//  Connoisseur
//
//  Created by Eduardo Flores on 6/19/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import "CommentImageCell.h"

@implementation CommentImageCell
@synthesize imageView_commentsMainImage, label_postOwnerName, label_typeAndFrom, label_yearAndName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
