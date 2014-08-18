//
//  PostPreviewTVC.m
//  Connoisseur
//
//  Created by Eduardo Flores on 6/17/14.
//  Copyright (c) 2014 Eduardo Flores. All rights reserved.
//

#import "PostPreviewTVC.h"
#import "PostPreviewPictureCell.h"
#import "PostPreviewRatingCell.h"
#import "PostPreviewFieldsCell.h"

@interface PostPreviewTVC ()

@end

@implementation PostPreviewTVC
@synthesize imageData;

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
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
        
    switch (indexPath.row)
    {
        case 0:
        {
            PostPreviewPictureCell *cellPicture = [tableView dequeueReusableCellWithIdentifier:@"CellImage" forIndexPath:indexPath];
            UIImage *picture = [UIImage imageWithData:imageData];
            cellPicture.imageView_image.image = picture;
            return cellPicture;
        }
            break;
        case 1:
        {
            PostPreviewRatingCell *cellRating = [tableView dequeueReusableCellWithIdentifier:@"CellRating" forIndexPath:indexPath];
            return cellRating;
        }
            break;
        case 2:
        {
            PostPreviewFieldsCell *cellFields = [tableView dequeueReusableCellWithIdentifier:@"CellFields" forIndexPath:indexPath];
            return cellFields;
        }
            break;
        default:
            return cell;
    }
    
    // Configure the cell...
    
    //return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            return 190;
            break;
        case 1:
            return 66;
            break;
        case 2:
            return 270;
            break;
        default:
            return 0;
            break;
    }
}

- (IBAction)button_cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)button_upload:(id)sender {
}
@end












































