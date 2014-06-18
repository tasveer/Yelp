//
//  YelpClient.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpClient.h"

@interface YelpClient()

@property (strong, nonatomic) NSDictionary          *categoryMappings;   // category mapping as specified in http://www.yelp.com/developers/documentation/category_list

@end

@implementation YelpClient

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken accessSecret:(NSString *)accessSecret {
    NSURL *baseURL = [NSURL URLWithString:@"http://api.yelp.com/v2/"];
    self = [super initWithBaseURL:baseURL consumerKey:consumerKey consumerSecret:consumerSecret];
    if (self) {
        BDBOAuthToken *token = [BDBOAuthToken tokenWithToken:accessToken secret:accessSecret expiration:nil];
        [self.requestSerializer saveAccessToken:token];
    }
    
    self.categoryMappings   = @{@"Afghan": @"afghani", @"African": @"african", @"American": @"newamerican", @"Arabian": @"arabian",
                                @"Chinese": @"chinese", @"Indian": @"indpak", @"Mediterranean": @"mediterranean", @"Mexican": @"mexican",
                                @"Pizza": @"pizza", @"Thai": @"thai"};
    return self;
}

/*
- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    //NSDictionary *parameters = @{@"term": term, @"location" : @"Milpitas", @"ll": @"37.449275,-121.895696"};
    NSDictionary *parameters = @{@"term": term, @"ll": @"37.449275,-121.895696"};

    return [self GET:@"search" parameters:parameters success:success failure:failure];
}
 */

- (AFHTTPRequestOperation *)searchWithTerm:(NSString *)term currentLocation:(NSString*)location success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    //NSDictionary *parameters = @{@"term": @"Thai", @"location" : @"Milpitas"};
    //NSDictionary *parameters = @{@"term": term, @"ll": @"37.449275,-121.895696"};
    
    float      radius = 0.0;
    NSUInteger sortBy = 0;
    BOOL       offeringDeal = NO;
    
    //NSDictionary *standardParameters = @{@"term": term, @"ll": location};
    NSDictionary *standardParameters = @{@"term": term};
    NSMutableDictionary *parameters = [ NSMutableDictionary dictionaryWithDictionary:standardParameters];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Distance"]) {
        NSString *distanceValue = [ defaults stringForKey:@"Distance"];
        if (distanceValue != nil) {
            radius = [ distanceValue floatValue];
        }
    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Sort by"]) {
        NSString *sortByString = [ defaults stringForKey:@"Sort by"];
        if ([sortByString isEqualToString:@"Best Match"]) {
            sortBy = 0;
        } else if ([sortByString isEqualToString:@"Distance"]) {
            sortBy = 1;
        } else if ([sortByString isEqualToString:@"Rating"]) {
            sortBy = 2;
        } else if ([sortByString isEqualToString:@"Most Reviewed"]) {
            sortBy = 3;
        }
        
    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Offering a Deal"]) {
        NSString *dealStr = [ defaults stringForKey:@"Offering a Deal"];
        offeringDeal = [ dealStr boolValue];
    }
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"categories"]) {
        //parameters[@"category_filter"] = [ defaults stringForKey:@"category_filter"];
        NSArray *selectedCategories = [ defaults arrayForKey:@"categories"];
        
        NSMutableDictionary *selectedMappedCategories = [ NSMutableDictionary dictionary];
        
        for (NSString *category in selectedCategories) {
            if (self.categoryMappings[category] != nil) {
                selectedMappedCategories[self.categoryMappings[category]] = @(1);
            }
        }
        NSArray *allMappedCategories = [ selectedMappedCategories allKeys];
        NSString *categoryList = [[allMappedCategories valueForKey:@"description"] componentsJoinedByString:@","];
        //NSLog(@"final selected categories: %@", categoryList);
        parameters[@"category_filter"] = categoryList;
    }
    
    

    if (radius) {
        parameters[@"radius_filter"] = [NSString stringWithFormat:@"%g",  radius / 0.000621371 ];
    }
    if (sortBy) {
        parameters[@"sort"] = [NSString stringWithFormat:@"%d",  sortBy ];
    }
    if (offeringDeal) {
        parameters[@"deals_filter"] = [NSString stringWithFormat:@"%d",  offeringDeal ];
    }

    
    if ([location isEqualToString:@"0.000000,0.000000"]) {
        parameters[@"location"] = @"San Francisco";
    } else {
        parameters[@"ll"] = location;
    }

    //NSLog(@"Parameters %@", parameters);
    return [self GET:@"search" parameters:parameters success:success failure:failure];
}

@end
