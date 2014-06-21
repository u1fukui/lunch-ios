//
//  RestaurantMapViewController.h
//  lunch
//
//  Created by u1 on 2014/06/17.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NADView.h"

@class Restaurant;

@interface RestaurantMapViewController : UIViewController<NADViewDelegate>

- (void)showRestaurant:(Restaurant *)r;

@end
