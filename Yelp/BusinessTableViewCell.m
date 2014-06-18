//
//  BusinessTableViewCell.m
//  Yelp
//
//  Created by Hunaid Hussain on 6/14/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "BusinessTableViewCell.h"
#import "UIImageView+AFNetworking.h"


@implementation BusinessTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) loadTableCell: (NSUInteger) index
{
    /*
    self.nameLabel.text = [ NSString stringWithFormat:@"%d. %@", index, self.buisness.name];
    if (self.buisness.neighbourhoods != nil) {
        self.addressLabel.text = [ NSString stringWithFormat:@"%@, %@", self.buisness.address, self.buisness.neighbourhoods ];
    } else {
        self.addressLabel.text = self.buisness.address;
    }
    self.categoryLabel.text = self.buisness.categories;
    self.reviewLabel.text = [NSString stringWithFormat:@"%d reviews", self.buisness.reviewCount ];
    self.distanceLabel.text = [NSString stringWithFormat:@"%0.2g mi", self.buisness.distance*0.000621371];
    //[self.addressLabel sizeToFit ];
    //[self.categoryLabel sizeToFit];
     */
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.buisness.ratingsUrl];

    __weak BusinessTableViewCell *weakCell = self;
    
    [self.ratingsImageView setImageWithURLRequest:request
                                         placeholderImage:nil
                                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                      
                                                      [UIView transitionWithView:weakCell.ratingsImageView
                                                                        duration:0.3
                                                                         options:UIViewAnimationOptionTransitionCrossDissolve
                                                                      animations:^{
                                                                          weakCell.ratingsImageView.image = image;
                                                                      }
                                                                      completion:NULL];
                                                      
                                                      [weakCell setNeedsLayout];
                                                      
                                                  } failure:nil];
    
    request = [NSURLRequest requestWithURL:self.buisness.imageUrl];
    
    [self.businessImageView setImageWithURLRequest:request
                                          placeholderImage:nil
                                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                       
                                                       [UIView transitionWithView:weakCell.businessImageView
                                                                         duration:0.3
                                                                          options:UIViewAnimationOptionTransitionCrossDissolve
                                                                       animations:^{
                                                                           weakCell.businessImageView.image = image;
                                                                       }
                                                                       completion:NULL];
                                                       
                                                       // Begin a new image that will be the new image with the rounded corners
                                                       // (here with the size of an UIImageView)
                                                       UIGraphicsBeginImageContextWithOptions(weakCell.businessImageView.bounds.size, NO, 1.0);
                                                       
                                                       // Add a clip before drawing anything, in the shape of an rounded rect
                                                       [[UIBezierPath bezierPathWithRoundedRect:weakCell.businessImageView.bounds
                                                                                   cornerRadius:10.0] addClip];
                                                       // Draw your image
                                                       [weakCell.businessImageView.image drawInRect:weakCell.businessImageView.bounds];
                                                       
                                                       // Get the image, here setting the UIImageView image
                                                       weakCell.businessImageView.image = UIGraphicsGetImageFromCurrentImageContext();
                                                       
                                                       // Lets forget about that we were drawing
                                                       UIGraphicsEndImageContext();
                                                       
                                                       [weakCell setNeedsLayout];
                                                       
                                                       self.nameLabel.text = [ NSString stringWithFormat:@"%d. %@", index, self.buisness.name];
                                                       if (self.buisness.neighbourhoods != nil) {
                                                           self.addressLabel.text = [ NSString stringWithFormat:@"%@, %@", self.buisness.address, self.buisness.neighbourhoods ];
                                                       } else {
                                                           self.addressLabel.text = self.buisness.address;
                                                       }
                                                       self.categoryLabel.text = self.buisness.categories;
                                                       self.reviewLabel.text = [NSString stringWithFormat:@"%d reviews", self.buisness.reviewCount ];
                                                       self.distanceLabel.text = [NSString stringWithFormat:@"%0.2g mi", self.buisness.distance*0.000621371];
                                                       //[self.addressLabel sizeToFit ];
                                                       //[self.categoryLabel sizeToFit];
                                                       
                                                   } failure:nil];
}

- (void) loadStubTableCell: (NSUInteger) index
{
    self.nameLabel.text = [ NSString stringWithFormat:@"%d. %@", index, self.buisness.name];
    if (self.buisness.neighbourhoods != nil) {
        self.addressLabel.text = [ NSString stringWithFormat:@"%@, %@", self.buisness.address, self.buisness.neighbourhoods ];
    } else {
        self.addressLabel.text = self.buisness.address;
    }
    self.categoryLabel.text = self.buisness.categories;
    self.reviewLabel.text = [NSString stringWithFormat:@"%d reviews", self.buisness.reviewCount ];
    self.distanceLabel.text = [NSString stringWithFormat:@"%0.2g mi", self.buisness.distance*0.000621371];
}
@end
