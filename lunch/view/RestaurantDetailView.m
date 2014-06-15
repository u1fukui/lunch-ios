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
        [self addSubview:topLevelViews[0]];
        
        self.photoScrollView.pagingEnabled = YES;
        self.photoScrollView.userInteractionEnabled = YES;
        self.photoScrollView.showsHorizontalScrollIndicator = NO;
        self.photoScrollView.delegate = self;
        self.pageControl.currentPage = 0;
    }
    return self;
}


- (void)showRestaurant:(Restaurant *) r
{
    NSLog(@"%s", __func__);
    [self.addressItem showItem:@"住所" value:r.address];
    [self.lunchTimeItem showItem:@"ランチ\nタイム"
                           value:[NSString stringWithFormat:@"%@〜%@",
                                  r.startLunchTime,
                                  r.finishLunchTime]];
    [self.holidayItem showItem:@"定休日" value:r.holiday];
    [self.menuItem showItem:@"メニュー" value:r.featuredMenu];
    [self.commentItem showItem:@"補足" value:r.comment];
    
    CGSize size = self.photoScrollView.frame.size;
    int pageSize = 3;
    self.pageControl.numberOfPages = pageSize;
    [self.photoScrollView setContentSize:CGSizeMake((pageSize * size.width), size.height)];
    for (int i = 0; i < pageSize; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i * size.width, 0,
                                                                  size.width, size.height)];
        label.text = [NSString stringWithFormat:@"%d", i + 1];
        label.font = [UIFont fontWithName:@"Arial" size:92];
        label.backgroundColor = [UIColor yellowColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.photoScrollView addSubview:label];
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    if ((NSInteger)fmod(scrollView.contentOffset.x , pageWidth) == 0) {
        NSLog(@"%f", scrollView.contentOffset.x / pageWidth);
        self.pageControl.currentPage = scrollView.contentOffset.x / pageWidth;
    }
}


@end
