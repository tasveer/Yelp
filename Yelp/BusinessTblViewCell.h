//
//  BusinessTblViewCell.h
//  Yelp
//
//  Created by Hunaid Hussain on 6/17/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"

@interface BusinessTblViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *businessImageView;

@property (weak, nonatomic) IBOutlet UIImageView *ratingsImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (strong, nonatomic) Business * buisness;

- (void) loadTableCell: (NSUInteger) index;
- (void) loadStubTableCell: (NSUInteger) index;

@end
