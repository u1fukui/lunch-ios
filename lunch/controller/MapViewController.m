//
//  MapViewController.m
//  lunch
//
//  Created by u1 on 2014/01/25.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import "MapViewController.h"
#import "Restaurant.h"
#import "RestaurantManager.h"
#import "RestaurantSimpleView.h"
#import "RestaurantDetailViewController.h"
#import "LunchTabBarController.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSArray *restaurantArray;
@property (strong, nonatomic) NSMutableArray *markerArray;
@property (strong, nonatomic) Restaurant *restaurant;
@property (strong, nonatomic) RestaurantSimpleView *restaurantView;
@property (strong, nonatomic) RestaurantSimpleView *restaurantPreviousView;
@property (strong, nonatomic) RestaurantSimpleView *restaurantNextView;
@property (assign, nonatomic) int currentIndex;
@property (assign, nonatomic) BOOL isTappingMarker;

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isTappingMarker = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 地図初期化
    self.mapView.delegate = self;
    self.mapView.camera =  [GMSCameraPosition cameraWithLatitude:35.658517
                                                       longitude:139.701334
                                                            zoom:15];
    self.mapView.myLocationEnabled = YES;
    
    // 全お店を表示
    [self showRestaurantList];
    
    // お店情報
    self.scrollView.pagingEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    CGSize size = self.scrollView.frame.size;
    self.restaurantView = [[RestaurantSimpleView alloc] initWithFrame:CGRectMake(0, 0,
                                                                                 size.width, size.height)];
    self.restaurantPreviousView = [[RestaurantSimpleView alloc] initWithFrame:self.restaurantView.frame];
    self.restaurantNextView = [[RestaurantSimpleView alloc] initWithFrame:self.restaurantView.frame];
  
    [self.scrollView addSubview:self.restaurantPreviousView];
    [self.scrollView addSubview:self.restaurantNextView];
    [self.scrollView addSubview:self.restaurantView];
    
    UITapGestureRecognizer *recognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(onClickRestaurantView:)];
    [self.restaurantView addGestureRecognizer:recognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([RestaurantManager sharedManager].needReloadMap) {
        [self showRestaurantList];
        [RestaurantManager sharedManager].needReloadMap = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -

- (void)showRestaurantList
{
    [self.mapView clear];
    
    self.restaurantArray = [RestaurantManager sharedManager].filteredRestaurantArray;
    
    // 地図
    self.markerArray = [NSMutableArray array];
    for (Restaurant *r in self.restaurantArray) {
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(r.lat, r.lng);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.title = r.name;
        marker.userData = r;
        marker.map = self.mapView;
        [self.markerArray addObject:marker];
    }
    
    self.mapView.selectedMarker = [self.markerArray firstObject];
    self.restaurant = [[RestaurantManager sharedManager].filteredRestaurantArray
                       objectAtIndex:0];
    
    // 詳細情報
    NSUInteger pageSize = [self.restaurantArray count];
    CGSize size = self.scrollView.frame.size;
    [self.scrollView setContentSize:CGSizeMake((size.width * pageSize), size.height)];
    [self showRestaurant:0];
}

- (void)showRestaurant:(int)index
{
    self.currentIndex = index;
    
    // 中央
    CGRect frame = self.restaurantView.frame;
    frame.origin.x = self.restaurantView.frame.size.width * index;
    self.restaurantView.frame = frame;
    self.restaurant = [self.restaurantArray objectAtIndex:index];
    [self.restaurantView setRestaurant:self.restaurant];
    
    // 前
    if (index > 0) {
        CGRect frame2 = self.restaurantPreviousView.frame;
        frame2.origin.x = self.restaurantPreviousView.frame.size.width * (index - 1);
        self.restaurantPreviousView.frame = frame2;
        [self.restaurantPreviousView setRestaurant:[self.restaurantArray objectAtIndex:index - 1]];
    }
    
    // 後
    if (index < [self.restaurantArray count] - 1) {
        CGRect frame3 = self.restaurantNextView.frame;
        frame3.origin.x = self.restaurantNextView.frame.size.width * (index + 1);
        self.restaurantNextView.frame = frame3;
        [self.restaurantNextView setRestaurant:[self.restaurantArray objectAtIndex:index + 1]];
    }
}

- (void)onClickRestaurantView:(UITapGestureRecognizer *)recognizer {
    RestaurantDetailViewController *controller = [[RestaurantDetailViewController alloc]
                                                  initWithNibName:@"RestaurantDetailViewController" bundle:nil];
    [controller showRestaurant:self.restaurant];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.navigationController presentViewController:navController
                                            animated:YES
                                          completion:nil];
}


#pragma mark - GMSMapViewDelegate

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    [mapView animateToLocation:marker.position];
    self.restaurant = marker.userData;
    
    int index = (int)[self.restaurantArray indexOfObject:self.restaurant];
    
    self.isTappingMarker = YES;
    self.scrollView.contentOffset = CGPointMake(self.restaurantView.frame.size.width * index, 0);
    self.isTappingMarker = NO;
    
    [self showRestaurant:index];
    
    return NO;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isTappingMarker || self.currentIndex >= [self.restaurantArray count]) {
        return; // マーカータップ時に発生するスクロールは無視
    }
    
    CGFloat position = scrollView.contentOffset.x / scrollView.bounds.size.width;
    CGFloat delta = position - (CGFloat)self.currentIndex;
    
    if (fabs(delta) >= 1.0f) {
        int index = self.currentIndex;
        if (delta > 0) {
            index++;
        } else {
            index--;
        }
        GMSMarker *marker = [self.markerArray objectAtIndex:index];
        self.mapView.selectedMarker = marker;
        [self.mapView animateToLocation:marker.position];
        [self showRestaurant:index];
    }
}

@end
