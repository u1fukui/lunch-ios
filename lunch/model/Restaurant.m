//
//  Restaurant.m
//  lunch
//
//  Created by u1 on 2014/01/25.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant

+(id)initWithCsvArray:(NSArray *)array
{
    Restaurant *r = [[Restaurant alloc] init];
    r.restaurantId = array[0];
    r.name = array[1];
    r.address = array[2];
    r.lat = [array[3] doubleValue];
    r.lng = [array[4] doubleValue];
    r.featuredMenu = array[5];
    r.startLunchTime = array[6];
    r.finishLunchTime = array[7];
    r.holiday = array[8];
    r.tabelogUrl = array[9];
    return r;
}

@end
