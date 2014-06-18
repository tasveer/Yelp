//
//  Business.m
//  Yelp
//
//  Created by Hunaid Hussain on 6/13/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "Business.h"

@implementation Business

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name": @"name",
             @"address": @"location.address",
             @"neighbourhoods": @"location.neighborhoods",
             @"categories": @"categories",
             @"ratingsUrl": @"rating_img_url_small",
             @"imageUrl": @"image_url",
             @"reviewCount": @"review_count",
             @"distance": @"distance",
             };
}

+ (NSValueTransformer *)ratingsUrlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)imageUrlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)addressJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^(NSArray *address) {
        
        NSString* cleanedAddress = address[0];

        //NSLog(@"cleanedAddress : '%@'", cleanedAddress);
        return cleanedAddress;
    }];
}

+ (NSValueTransformer *)neighbourhoodsJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^(NSArray *neighbourArray) {
        
        NSString* neighbourhood = neighbourArray[0];
        
        //NSLog(@"neighbourhood : '%@'", neighbourhood);
        return neighbourhood;
    }];
}

+ (NSValueTransformer *)categoriesJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^(NSArray *categoryArray) {
        
        
        NSString *categories = @"";
        
        NSUInteger numOfCategory = [ categoryArray count];
        for (NSArray *aCategory in categoryArray) {
            if (numOfCategory > 1) {
                categories = [ categories stringByAppendingFormat:@"%@, ", aCategory[0]];
            } else {
                categories = [ categories stringByAppendingFormat:@"%@", aCategory[0]];
            }
            --numOfCategory;
        }
        
        //NSLog(@"categories : '%@'", categories);
        return categories;
    }];
}


+ (NSArray *)BusinessWithArray:(NSArray *)array {
    NSMutableArray *Businesses = [[NSMutableArray alloc] init];
    NSError *error = nil;
    for (NSDictionary *dictionary in array) {
        Business *aBusiness = [MTLJSONAdapter modelOfClass: Business.class fromJSONDictionary: dictionary error: &error];

        //NSLog(@"name: %@ , address: %@ , neighbourhood: %@ , ratingUrl: %@ , reviewCount %d , categories: %@", aBusiness.name, aBusiness.address, aBusiness.neighbourhoods, aBusiness.ratingsUrl, aBusiness.reviewCount, aBusiness.categories);
        
        //[aBusiness dumpBusinessDetails];
        [Businesses addObject:aBusiness];
    }
    
    return Businesses;
}

- (void) dumpBusinessDetails {
    NSLog(@"Name: %@", self.name);
    NSLog(@"Categories: %@", self.categories);
    NSLog(@"address: %@, %@", self.address, self.neighbourhoods);
    NSLog(@"Reviews: %d", self.reviewCount);
    NSLog(@"Ratings: %@", self.ratingsUrl);
    NSLog(@"distance: %0.2g", self.distance*0.000621371);
}

@end
