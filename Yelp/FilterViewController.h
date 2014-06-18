//
//  FilterViewController.h
//  Yelp
//
//  Created by Hunaid Hussain on 6/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchYelp.h"
@interface FilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic)   id                    delegate;

@end
