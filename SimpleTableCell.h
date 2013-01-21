//
//  SimpleTableCellCell.h
//  Broccoli
//
//  Created by Kanupriya Singhal on 10/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, retain) IBOutlet UILabel *theaterLabel;
@property (nonatomic, retain) IBOutlet UILabel *audienceRatingLabel;
@property (nonatomic, retain) IBOutlet UILabel *audienceRating;

@end
