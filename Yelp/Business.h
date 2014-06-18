//
//  Business.h
//  Yelp
//
//  Created by Hunaid Hussain on 6/13/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>


@interface Business : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *neighbourhoods;
@property (strong, nonatomic) NSString *categories;
@property (strong, nonatomic) NSURL    *ratingsUrl;
@property (strong, nonatomic) NSURL    *imageUrl;
@property (nonatomic)         NSUInteger reviewCount;
@property (nonatomic)         float      distance;

+ (NSArray *)BusinessWithArray:(NSArray *)array;

@end
