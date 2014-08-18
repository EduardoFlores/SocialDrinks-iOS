//
//  CommentListCell.h
//  Connoisseur
//
//  Created by Eduardo Flores on 6/19/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label_commentOwnerFirstAndLastName;
@property (weak, nonatomic) IBOutlet UILabel *label_commentDateAndTime;
@property (weak, nonatomic) IBOutlet UILabel *label_commentText;
@end
