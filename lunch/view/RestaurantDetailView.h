//
//  RestaurantDetailView.h
//  lunch
//
//  Created by u1 on 2014/06/14.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Restaurant;

@protocol RestaurantDetailViewDelegate

- (void)didTabelogButtonClicked;

- (void)didMapButtonClicked;

@end

@interface RestaurantDetailView : UIView<UIScrollViewDelegate>

@property (nonatomic, assign) id<RestaurantDetailViewDelegate> delegate;

- (void)showRestaurant:(Restaurant *) r;

@end
