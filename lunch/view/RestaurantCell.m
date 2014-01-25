//
//  RestaurantCell.m
//  lunch
//
//  Created by u1 on 2014/01/25.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import "RestaurantCell.h"
#import "Restaurant.h"

@interface RestaurantCell()

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation RestaurantCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0f,
                                                                      10.0f,
                                                                      260.0f,
                                                                      50.0f)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.numberOfLines = 2;
        self.nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:self.nameLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRestaurant:(Restaurant *)restaurant
{
    self.nameLabel.text = restaurant.name;
}

+ (CGFloat)cellHeight
{
    return 88.0f;
}

@end
