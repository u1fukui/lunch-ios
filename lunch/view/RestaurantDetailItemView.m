//
//  RestaurantDetailItemView.m
//  lunch
//
//  Created by u1 on 2014/06/14.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import "RestaurantDetailItemView.h"

@interface RestaurantDetailItemView()

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemValueLabel;

@end

@implementation RestaurantDetailItemView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSArray *topLevelViews = [[NSBundle mainBundle]
                                  loadNibNamed:@"RestaurantDetailItemView"
                                  owner:self
                                  options:nil];
        [self addSubview:topLevelViews[0]];
    }
    return self;
}

- (void) showItem:(NSString *)name value:(NSString *)value
{
    NSLog(@"%s", __func__);
    self.itemNameLabel.text = name;
    self.itemValueLabel.text = value;
}

@end
