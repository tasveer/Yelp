//
//  YelpMainViewController.m
//  Yelp
//
//  Created by Hunaid Hussain on 6/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpMainViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessTblViewCell.h"
//#import "BusinessTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "FilterViewController.h"

NSString * const kYelpConsumerKeyH = @"lgMx6h9_Ft0jG01p96n8JA";
NSString * const kYelpConsumerSecretH = @"rXxrIrJ9HWpsFg8M6oK4iAm6fZE";
NSString * const kYelpTokenH = @"g2xBurZk1jb-WjKWuMai5urwBEQ-97UF";
NSString * const kYelpTokenSecretH = @"fKv1y1hE2W5GNd6ejwCKVsR6AVs";

@interface YelpMainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property(strong, nonatomic) UISearchDisplayController *srchDisplay;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterButton;

@property (strong, nonatomic) NSArray *businesses;

@property (nonatomic) float currentLatitude;
@property (nonatomic) float currentLongitude;

@property (strong, nonatomic) NSString *searchTerm;
@property (strong, nonatomic) UITapGestureRecognizer *tapKeyBoardResignGesture;

@property (nonatomic, strong) YelpClient *client;

@end


@implementation YelpMainViewController

BusinessTblViewCell *_stubCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //[self createViewElements];
        
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKeyH consumerSecret:kYelpConsumerSecretH accessToken:kYelpTokenH accessSecret:kYelpTokenSecretH];
        
        // Check the last search term, if it exists
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"lastSearch"]) {
            self.searchTerm = [ defaults stringForKey:@"lastSearch"];
        } else {
            self.searchTerm = @"Thai";
        }
        [ self queryYelp];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createViewElements];

    UINib *cellNib = [UINib nibWithNibName:@"BusinessTblViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"BusinessTblViewCell"];
    
    _stubCell = [cellNib instantiateWithOwner:nil options:nil][0];
    
    //self.tableView.rowHeight = 140;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

- (void)configureCell:(BusinessTblViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [cell loadStubTableCell: indexPath.row+1 ];
    //[cell loadTableCell:indexPath.row+1];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self configureCell:_stubCell atIndexPath:indexPath];
    [_stubCell layoutSubviews];
    
    CGFloat height = [_stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    //NSLog(@"hieght for cell at row %d ------> %f", indexPath.row, height+1);
    return height + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"total rows %d", [self.businesses count]);
    return [ self.businesses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BusinessTblViewCell *businessCell = [ tableView dequeueReusableCellWithIdentifier:@"BusinessTblViewCell" ];
    
    businessCell.buisness = self.businesses[indexPath.row];
    
    [businessCell loadTableCell: indexPath.row+1 ];
    
    return businessCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
    [tableView  deselectRowAtIndexPath:indexPath  animated:YES];
    
}

- (void) queryYelp
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    //self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKeyH consumerSecret:kYelpConsumerSecretH accessToken:kYelpTokenH accessSecret:kYelpTokenSecretH];
    
    [self.locationManager startUpdatingLocation];
    
    // Remember the last search.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [ defaults setObject:self.searchTerm forKey:@"lastSearch"];
    [ defaults synchronize];


    //NSLog(@"current location %f %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude);
    NSString *location = [ NSString stringWithFormat:@"%f,%f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
    
    [self.client searchWithTerm:self.searchTerm currentLocation:location success:^(AFHTTPRequestOperation *operation, id response) {
        //NSLog(@"response: %@", response);
        self.businesses = [ Business BusinessWithArray:response[@"businesses"] ];
        [self.tableView reloadData];
        [self.locationManager stopUpdatingLocation];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"error: %@", [error description]);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    //NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    self.currentLatitude = newLocation.coordinate.latitude;
    self.currentLongitude = newLocation.coordinate.longitude;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.tableView addGestureRecognizer:self.tapKeyBoardResignGesture];
    
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchTerm = searchBar.text;
    //NSLog(@"Found a new search %@", self.searchTerm);
    [ self.navigationItem.titleView resignFirstResponder ];
    
    [self queryYelp];
}

- (void) hideKeyboard {
    [self.navigationItem.titleView resignFirstResponder];
    [ self.tableView removeGestureRecognizer:self.tapKeyBoardResignGesture];
    //self.tapKeyBoardResignGesture.cancelsTouchesInView = YES;
}

-(IBAction)filterButtonPressed
{
    //NSLog(@"Filter button pressed");
    [ self openFilterView];
}

- (void)openFilterView
{
    //NSLog(@"1. Switching to filter view");
    FilterViewController *fvc = [[ FilterViewController alloc] initWithNibName:@"FilterViewController" bundle:nil];
    fvc.delegate = self;
    [self.navigationController pushViewController:fvc animated:YES];
}

- (void) createViewElements
{
    
    //Create search bar
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    
    searchBar.delegate = self;
    searchBar.tintColor = [UIColor redColor];
    searchBar.placeholder = @"Search";
    //self.srchBar.backgroundColor = [UIColor clearColor];
    //[self.srchBar setSearchBarStyle:UISearchBarStyleMinimal ];
    self.navigationItem.titleView = searchBar;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    //NSLog(@"starting to update locations");

    self.tapKeyBoardResignGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterButtonPressed)];
    [filterButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],  NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = filterButton;
 
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:nil action:nil];
    [cancelButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],  NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.backBarButtonItem = cancelButton;
    
}

- (void) startNewSearch
{
    [self queryYelp];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
