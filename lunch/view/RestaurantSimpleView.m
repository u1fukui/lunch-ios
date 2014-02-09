//
//  RestaurantSimpleView.m
//  lunch
//
//  Created by u1 on 2014/02/08.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import "RestaurantSimpleView.h"
#import "Restaurant.h"

@interface RestaurantSimpleView()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *holidayLabel;
@property (weak, nonatomic) IBOutlet UILabel *featuredMenuLabel;

@end

@implementation RestaurantSimpleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *topLevelViews = [[NSBundle mainBundle]
                                  loadNibNamed:@"RestaurantSimpleView"
                                  owner:self
                                  options:nil];
        [self addSubview:topLevelViews[0]];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)setRestaurant:(Restaurant *)r
{
    self.nameLabel.text = r.name;
    self.timeLabel.text = [NSString stringWithFormat:@"%@〜%@",
                           r.startLunchTime, r.finishLunchTime];
    self.holidayLabel.text = [NSString stringWithFormat:@"定休:%@", r.holiday];
    self.featuredMenuLabel.text = r.featuredMenu;
}

+ (CGFloat)cellHeight
{
    return 88.0f;
}

@end
