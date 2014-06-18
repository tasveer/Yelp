//
//  FilterViewController.m
//  Yelp
//
//  Created by Hunaid Hussain on 6/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()

@property (weak, nonatomic) IBOutlet UITableView *filterTableView;

@property (strong, nonatomic) NSArray               *sections;           // Stores all sections with Titles
@property (strong, nonatomic) NSDictionary          *sectionContents;    // Stores all contents within each sections
@property (strong, nonatomic) NSMutableDictionary   *collapsed;          // Tells if the sections are in collapsed state
@property (strong, nonatomic) NSMutableDictionary   *selectedOptions;    // Selected options
@property (strong, nonatomic) NSMutableDictionary   *selectedCategories; // Selected categories
@property (strong, nonatomic) NSDictionary          *categoryMappings;   // category mapping as specified in http://www.yelp.com/developers/documentation/category_list

@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[self initializeView];
        [self initializeTableData];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.filterTableView.delegate = self;
    self.filterTableView.dataSource = self;
    [self initializeView];

    //self.navigationItem.title = @"Filter";
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionStr = self.sections[section];
    if (![sectionStr isEqualToString:@"Most Popular"]) {
        return [self.collapsed[@(section)] boolValue] ? 1 : [self.sectionContents[self.sections[section]] count];
    }

    return [self.sectionContents[self.sections[section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sections[section];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
        return [ self.sections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [ tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" ];

    if (cell == nil) {
        cell = [ [UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }

    cell.accessoryView = nil;
    
    //cell.textLabel.text = [ NSString stringWithFormat:@"%ld -- %ld", (long)indexPath.section, (long)indexPath.row];
    
    NSString *sectionStr = self.sections[indexPath.section];
    NSString *rowStr = self.sectionContents[sectionStr][indexPath.row];

    cell.textLabel.text = self.sectionContents[sectionStr][indexPath.row];
    
    if ([sectionStr isEqualToString:@"Most Popular"])
    {
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        switchView.onTintColor = [UIColor redColor];
        //switchView.offImage = [UIImage imageNamed:@"miniMapLogo"];
        //NSLog(@"minimaplogo image %@", switchView.offImage);
        cell.accessoryView = switchView;
        if (self.selectedOptions[rowStr] != nil) {
            [switchView setOn:[self.selectedOptions[rowStr]  isEqual: @"1"] ? YES : NO animated:NO];
        }
        //[switchView setOn:NO animated:NO];
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    } else {
        if ([self.collapsed[@(indexPath.section)] boolValue]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            //NSString *rowStr = self.sectionContents[sectionStr][indexPath.row];
            if ([sectionStr isEqualToString:@"Categories"]) {
                // Only mark the categories as selected if one or more
                // have been selected
                if ([self.selectedCategories count]) {
                    cell.textLabel.text = @"Selected";
                } else {
                    // Mark the categories as unselected
                    cell.textLabel.text = rowStr;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            } else {
                cell.textLabel.text = self.selectedOptions[sectionStr];
            }
        } else {
            if ([sectionStr isEqualToString:@"Categories"]) {
                //NSLog(@"expanding on categories for row: %@", rowStr);
                //NSLog(@"selected category: %@", self.selectedCategories[rowStr]);
                if ([self.selectedCategories[rowStr] isEqualToString:rowStr]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    //NSLog(@"Adding check mark for row: %@", rowStr);
                } else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            } else {
                if ([self.selectedOptions[sectionStr] isEqualToString:rowStr]) {
                    //NSLog(@"Found expanded section %@ : rowStr %@ == %@", sectionStr, rowStr, self.selectedOptions[sectionStr]);
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                } else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }

        }
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *sectionStr = self.sections[indexPath.section];
    NSString *rowStr = self.sectionContents[sectionStr][indexPath.row];
    
    //NSLog(@"Selected Section: %@ row %@", sectionStr, rowStr);
    
    if (![sectionStr isEqualToString:@"Most Popular"]) {
        
        NSString *selectedStr = self.selectedOptions[sectionStr];
        if (self.selectedOptions[sectionStr] != nil &&  [self.collapsed[@(indexPath.section)] boolValue]) {
            rowStr = selectedStr;
        }

        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        if ([sectionStr isEqualToString:@"Categories"]) {
            rowStr = cell.textLabel.text;
            if ([rowStr isEqualToString:@"Select"]) {
                self.collapsed[@(indexPath.section)] = @(![self.collapsed[@(indexPath.section)] boolValue]);
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic ];
            } else if ([rowStr isEqualToString:@"Selected"]) {
                self.collapsed[@(indexPath.section)] = @(![self.collapsed[@(indexPath.section)] boolValue]);
                //NSLog(@"Reloading on Selected for rowStr: %@", rowStr);
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic ];
            } else {
                cell.textLabel.text = rowStr;
                if (self.selectedCategories[rowStr] == nil) {
                    //NSLog(@"Selecting category for rowStr %@ --> %@", rowStr, self.selectedCategories[rowStr]);
                    self.selectedCategories[rowStr] = rowStr;
                    //NSLog(@"selected category: %@", self.selectedCategories[rowStr]);
                    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
                } else {
                    [self.selectedCategories removeObjectForKey:rowStr ];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    //NSLog(@"Deselcting category %@", rowStr);
                }
            }
        } else {
            self.collapsed[@(indexPath.section)] = @(![self.collapsed[@(indexPath.section)] boolValue]);
            
            // Reset accessory for all other rows in this section, before collapsing them.
            
            [self resetRemainingSelectionForTableView:tableView forIndexPath:indexPath];
            
            /*
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.text = rowStr;
             */
            self.selectedOptions[sectionStr] = rowStr;
            
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic ];
        }
    }
    
    [tableView  deselectRowAtIndexPath:indexPath  animated:YES];

    return;
}

- (void)resetRemainingSelectionForTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger sectionSize = [self.sectionContents count];
    
    for (NSInteger row = 0; row < sectionSize; ++row) {
        NSIndexPath *aIndexPath = [ NSIndexPath indexPathForRow:row inSection:indexPath.section];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:aIndexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void) initializeView
{
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleDone target:self action:@selector(searchButtonPressed)];
    [searchButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],  NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = searchButton;
    
    UILabel *customLabel = [[UILabel alloc] initWithFrame:self.navigationController.navigationBar.frame];
    customLabel.text = @"Filters";
    customLabel.textColor = [UIColor whiteColor];
    customLabel.textAlignment = NSTextAlignmentCenter;
    customLabel.font = [UIFont boldSystemFontOfSize:19 ];
    self.navigationItem.titleView = customLabel;

}

- (void) initializeTableData
{
    self.collapsed =          [NSMutableDictionary dictionary];
    self.selectedOptions =    [NSMutableDictionary dictionary];
    self.selectedCategories = [NSMutableDictionary dictionary];
    
    self.sections = [NSArray arrayWithObjects:@"Most Popular", @"Distance", @"Sort by", @"Categories", nil ];
    self.sectionContents = @{@"Most Popular": [NSArray arrayWithObjects:@"Offering a Deal", @"Delivery", nil],
                             @"Distance": [NSArray arrayWithObjects:@"Auto", @"0.3", @"1", @"5", @"20", nil],
                             @"Sort by": [NSArray arrayWithObjects:@"Best Match", @"Distance", @"Rating", @"Most Reviewed", nil],
                             @"Categories": [NSArray arrayWithObjects:@"Select", @"Afghan", @"African", @"American", @"Arabian", @"Chinese", @"Indian", @"Mediterranean", @"Mexican", @"Pizza", @"Thai", nil]};
    
    self.categoryMappings   = @{@"Afghan": @"afghani", @"African": @"african", @"American": @"newamerican", @"Arabian": @"arabian",
                                @"Chinese": @"chinese", @"Indian": @"indpak", @"Mediterranean": @"mediterranean", @"Mexican": @"mexican",
                                @"Pizza": @"pizza", @"Thai": @"thai"};

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Distance"]) {
        self.selectedOptions[@"Distance"] = [ defaults stringForKey:@"Distance"];
    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Sort by"]) {
        self.selectedOptions[@"Sort by"] = [ defaults stringForKey:@"Sort by"];
    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Offering a Deal"]) {
        self.selectedOptions[@"Offering a Deal"] = [ defaults stringForKey:@"Offering a Deal"];
        //NSLog(@"Offering a Deal %@", self.selectedOptions[@"Offering a Deal"]);
    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Delivery"]) {
        self.selectedOptions[@"Delivery"] = [ defaults stringForKey:@"Delivery"];
        //NSLog(@"delivery %@", self.selectedOptions[@"Delivery"]);
    }
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"categories"]) {
        for (NSString *category in [ defaults arrayForKey:@"categories"]) {
            self.selectedCategories[category] = category;
        }
    }
}

- (void) searchButtonPressed
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    //NSLog(@"search button pressed");
    
    for (NSString *options in self.selectedOptions) {
        //NSLog(@"selected options %@ --> %@", options, self.selectedOptions[options]);
        [ defaults setObject:self.selectedOptions[options] forKey:options];
    }
    
    // Look for selected categories if any
    if ([self.selectedCategories count]) {
        [defaults setObject:[self.selectedCategories allKeys] forKey:@"categories" ];

    }
    [ defaults synchronize];
    
    if ([self.delegate respondsToSelector:@selector(startNewSearch)]) {
        [self.delegate startNewSearch ];
    }
    [self.navigationController popViewControllerAnimated:YES];


}

- (void) switchChanged:(id)sender  {
    UISwitch* switchControl = sender;
    //NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    
    CGPoint switchOriginInTableView = [sender convertPoint:CGPointZero toView:self.filterTableView];
    NSIndexPath *indexPath = [self.filterTableView indexPathForRowAtPoint:switchOriginInTableView];
    NSString *sectionStr = self.sections[indexPath.section];
    NSString *rowStr = self.sectionContents[sectionStr][indexPath.row];
    
    
    self.selectedOptions[rowStr] = switchControl.on ? @"1" : @"0";
    
    //NSLog(@"switch pressed for section %@ --> %@", sectionStr, rowStr);
}

@end
