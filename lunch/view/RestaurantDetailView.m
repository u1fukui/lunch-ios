//
//  RestaurantDetailView.m
//  lunch
//
//  Created by u1 on 2014/06/14.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import "RestaurantDetailView.h"
#import "RestaurantDetailItemView.h"
#import "Restaurant.h"
#import "UIColor+Hex.h"

@interface RestaurantDetailView()

@property (weak, nonatomic) IBOutlet UIButton *tabelogButton;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet RestaurantDetailItemView *addressItem;
@property (weak, nonatomic) IBOutlet RestaurantDetailItemView *lunchTimeItem;
@property (weak, nonatomic) IBOutlet RestaurantDetailItemView *holidayItem;
@property (weak, nonatomic) IBOutlet RestaurantDetailItemView *menuItem;
@property (weak, nonatomic) IBOutlet RestaurantDetailItemView *commentItem;

@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end


@implementation RestaurantDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *topLevelViews = [[NSBundle mainBundle]
                                  loadNibNamed:@"RestaurantDetailView"
                                  owner:self
                                  options:nil];
        UIView *mainView = topLevelViews[0];
        [self addSubview:mainView];
        
        mainView.backgroundColor = [UIColor colorWithHex:@"#fef9ea"];;
        
        self.photoScrollView.pagingEnabled = YES;
        self.photoScrollView.userInteractionEnabled = YES;
        self.photoScrollView.showsHorizontalScrollIndicator = NO;
        self.photoScrollView.delegate = self;
        self.photoScrollView.bounces = NO;
        
        
        self.pageControl.currentPage = 0;
        
        [self.tabelogButton addTarget:self
                            action:@selector(onClickButton:)
                  forControlEvents:UIControlEventTouchUpInside];
        [self.mapButton addTarget:self
                            action:@selector(onClickButton:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)showRestaurant:(Restaurant *) r
{
    [self.addressItem showItem:@"住所" value:r.address];
    [self.lunchTimeItem showItem:@"ランチ\nタイム"
                           value:[NSString stringWithFormat:@"%@〜%@",
                                  r.startLunchTime,
                                  r.finishLunchTime]];
    [self.holidayItem showItem:@"定休日" value:r.holiday];
    [self.menuItem showItem:@"メニュー" value:r.featuredMenu];
    [self.commentItem showItem:@"補足" value:r.comment];
    
    CGSize size = self.photoScrollView.frame.size;
    int pageSize = r.thumbnailCount;
    self.pageControl.numberOfPages = pageSize;
    [self.photoScrollView setContentSize:CGSizeMake((size.width * pageSize), size.height)];
    for (int i = 0; i < pageSize; i++) {
        // 画像
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320 * i, 0.0f,
                                                                               320.0f, 240.0f)];
        [imageView setImage:[UIImage imageNamed:[r getThumbnailName:i]]];
        [self.photoScrollView addSubview:imageView];
    }
}

- (void)onClickButton:(UIButton *)button
{
    if (button == self.tabelogButton) {
        [self.delegate didTabelogButtonClicked];
    } else if (button == self.mapButton) {
        [self.delegate didMapButtonClicked];
    }
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    if ((NSInteger)fmod(scrollView.contentOffset.x , pageWidth) == 0) {
        self.pageControl.currentPage = scrollView.contentOffset.x / pageWidth;
    }
}


@end
