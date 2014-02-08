//
//  RestaurantManager.h
//  lunch
//
//  Created by u1 on 2014/01/26.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Restaurant;

@interface RestaurantManager : NSObject

+ (RestaurantManager *)sharedManager;

- (NSArray *) restaurantArray;

- (void) add:(Restaurant *)r;

@end
