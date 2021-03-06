//
//  RestaurantCell.m
//  lunch
//
//  Created by u1 on 2014/01/25.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import "RestaurantCell.h"
#import "Restaurant.h"
#import "RestaurantSimpleView.h"
#import "UIColor+Hex.h"

@interface RestaurantCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *holidayLabel;
@property (weak, nonatomic) IBOutlet UILabel *featuredMenuLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;

@end

@implementation RestaurantCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithHex:@"#fff1eb"];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
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
    return 90.0f;
}

@end
