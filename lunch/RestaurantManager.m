//
//  RestaurantManager.m
//  lunch
//
//  Created by u1 on 2014/01/26.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import "RestaurantManager.h"
#import "Restaurant.h"

@interface RestaurantManager()

@property (strong, nonatomic) NSMutableDictionary *restaurantDictionary;

@end

@implementation RestaurantManager

static RestaurantManager *_sharedInstance = nil;

+ (RestaurantManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[RestaurantManager alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _restaurantDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSArray *) restaurantArray
{
    return [self.restaurantDictionary allValues];
}

- (void) add:(Restaurant *)r
{
    [self.restaurantDictionary setObject:r forKey:r.restaurantId];
}

@end
