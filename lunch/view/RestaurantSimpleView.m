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
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;

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

- (void)setRestaurant:(Restaurant *)r
{
    self.nameLabel.text = r.name;
    self.timeLabel.text = [NSString stringWithFormat:@"%@〜%@",
                           r.startLunchTime, r.finishLunchTime];
    self.holidayLabel.text = r.holiday;
    self.featuredMenuLabel.text = r.featuredMenu;
    
    UIImage *image = [UIImage imageNamed:[r getThumbnailName:0]];
    [self.thumbnailView setImage:image];
    self.thumbnailView.contentMode = UIViewContentModeScaleAspectFill;
    self.thumbnailView.clipsToBounds = YES;
}

+ (CGFloat)cellHeight
{
    return 100.0f;
}

@end
