//
//  YelpMainViewController.h
//  Yelp
//
//  Created by Hunaid Hussain on 6/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SearchYelp.h"


@interface YelpMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate,  UISearchBarDelegate, CLLocationManagerDelegate, SearchYelp>

@property (strong, nonatomic) CLLocationManager *locationManager;

-(IBAction)filterButtonPressed:(id)sender;

@end
