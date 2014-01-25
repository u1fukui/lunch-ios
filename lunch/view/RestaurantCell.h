//
//  RestaurantCell.h
//  lunch
//
//  Created by u1 on 2014/01/25.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Restaurant;

@interface RestaurantCell : UITableViewCell

+ (CGFloat)cellHeight;
- (void)setRestaurant:(Restaurant *)restaurant;

@end
