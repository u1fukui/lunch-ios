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
        _filteredRestaurantArray = [NSMutableArray array];
        _needReloadTable = YES;
        _needReloadMap = YES;
        _isSortedList = NO;
    }
    return self;
}

- (void)add:(Restaurant *)r
{
    [self.restaurantDictionary setObject:r forKey:r.restaurantId];
    if ([self isFilterRange:self.filterTime restaurant:r]) {
        [self.filteredRestaurantArray addObject:r];
    }
}

- (void)filter
{
    self.filteredRestaurantArray = [NSMutableArray array];
    for (Restaurant *r in [self.restaurantDictionary allValues]) {
        if ([self isFilterRange:self.filterTime restaurant:r]) {
            [self.filteredRestaurantArray addObject:r];
        }
    }
}

- (void)sortInOrderOfDistace
{
    if (self.currentLocation == nil) {
        return;
    }
    
    for (Restaurant *r in self.filteredRestaurantArray) {
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:r.lat
                                                     longitude:r.lng];
        r.distance = [loc distanceFromLocation:self.currentLocation];
    }
    
    NSSortDescriptor* sort = [[NSSortDescriptor alloc]
                               initWithKey:@"distance" ascending:YES];
    [self.filteredRestaurantArray sortUsingDescriptors:@[sort]];
    self.isSortedList = YES;
}


// 引数の時間帯が、フィルタの範囲内であればYES
- (BOOL)isFilterRange:(NSString *)filterTime restaurant:(Restaurant *)r
{
    if (filterTime == nil) {
        return YES;
    }
    
    int filter = [self integerFromTimeString:filterTime];
    int start = [self integerFromTimeString:r.startLunchTime];
    int finish = [self integerFromTimeString:r.finishLunchTime];
    
    return filter >= start && filter < finish;
}

- (int)integerFromTimeString:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@":"];
    return [[NSString stringWithFormat:@"%@%@", array[0], array[1]] intValue];
}

@end
