//
//  RestaurantDetailViewController.h
//  lunch
//
//  Created by u1 on 2014/02/09.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NADView.h"
#import "RestaurantDetailView.h"

@class Restaurant;

@interface RestaurantDetailViewController : UIViewController<NADViewDelegate, RestaurantDetailViewDelegate>

- (void)showRestaurant:(Restaurant *)r;

@end
