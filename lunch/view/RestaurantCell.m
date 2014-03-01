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
//        // 店名
//        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0f,
//                                                                   10.0f,
//                                                                   300.0f,
//                                                                   15.0f)];
//        self.nameLabel.backgroundColor = [UIColor clearColor];
//        self.nameLabel.textColor = [UIColor blackColor];
//        self.nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
//        self.nameLabel.numberOfLines = 1;
//        [self addSubview:self.nameLabel];
//        
//        // 開店時間
//        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0f,
//                                                                   30.0f,
//                                                                   120.0f,
//                                                                   15.0f)];
//        self.timeLabel.backgroundColor = [UIColor clearColor];
//        self.timeLabel.textColor = [UIColor grayColor];
//        self.timeLabel.font = [UIFont systemFontOfSize:12.0f];
//        self.timeLabel.numberOfLines = 1;
//        [self addSubview:self.timeLabel];
//        
//        // 定休日
//        self.holidayLabel = [[UILabel alloc] initWithFrame:CGRectMake(150.0f,
//                                                                   30.0f,
//                                                                   160.0f,
//                                                                   15.0f)];
//        self.holidayLabel.backgroundColor = [UIColor clearColor];
//        self.holidayLabel.textColor = [UIColor grayColor];
//        self.holidayLabel.font = [UIFont systemFontOfSize:12.0f];
//        self.holidayLabel.numberOfLines = 1;
//        [self addSubview:self.holidayLabel];
//        
//        // おすすめメニュー
//        self.featuredMenuLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.0f,
//                                                                           50.0f,
//                                                                           300.0f,
//                                                                           15.0f)];
//        self.featuredMenuLabel.backgroundColor = [UIColor clearColor];
//        self.featuredMenuLabel.textColor = [UIColor blackColor];
//        self.featuredMenuLabel.font = [UIFont systemFontOfSize:12.0f];
//        self.featuredMenuLabel.numberOfLines = 1;
//        [self addSubview:self.featuredMenuLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRestaurant:(Restaurant *)r
{
    self.nameLabel.text = r.name;
    self.timeLabel.text = [NSString stringWithFormat:@"%@〜%@",
                           r.startLunchTime, r.finishLunchTime];
    self.holidayLabel.text = r.holiday;
    self.featuredMenuLabel.text = r.featuredMenu;
    NSLog(@"%@", r.thumbnailName);
    [self.thumbnailView setImage:[UIImage imageNamed:r.thumbnailName]];
}

+ (CGFloat)cellHeight
{
    return 100.0f;
}

@end
