//
//  RestaurantSimpleView.h
//  lunch
//
//  Created by u1 on 2014/02/08.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Restaurant;

@interface RestaurantSimpleView : UIView

- (void)setRestaurant:(Restaurant *)r;

+ (CGFloat)cellHeight;

@end
