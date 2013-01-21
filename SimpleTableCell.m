//
//  SimpleTableCellCell.m
//  Broccoli
//
//  Created by Kanupriya Singhal on 10/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SimpleTableCell.h"

@implementation SimpleTableCell

@synthesize titleLabel = _titleLabel;
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize theaterLabel = _theaterLabel;
@synthesize audienceRatingLabel = _audienceRatingLabel;
@synthesize audienceRating = _audienceRating;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
