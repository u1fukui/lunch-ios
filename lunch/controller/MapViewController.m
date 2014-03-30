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
@property (weak, nonatomic) IBOutlet RestaurantSimpleView *restaurantView;
@property (strong, nonatomic) NSArray *restaurantArray;
@property (strong, nonatomic) NSMutableArray *markerArray;
@property (strong, nonatomic) Restaurant *restaurant;

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    // お店情報
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickFooterView:)];
    [self.restaurantView addGestureRecognizer:tapGesture];
    
    // スワイプ
    UISwipeGestureRecognizer* swipeRightGesture = [[UISwipeGestureRecognizer alloc]
                                                   initWithTarget:self action:@selector(selSwipeRightGesture:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.restaurantView addGestureRecognizer:swipeRightGesture];
    
    UISwipeGestureRecognizer* swipeLeftGesture = [[UISwipeGestureRecognizer alloc]
                                                   initWithTarget:self action:@selector(selSwipeLeftGesture:)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.restaurantView addGestureRecognizer:swipeLeftGesture];
    
    // 全お店を表示
    [self setRestaurantList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([RestaurantManager sharedManager].needReloadMap) {
        [self setRestaurantList];
        [RestaurantManager sharedManager].needReloadMap = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -

- (void)setRestaurantList
{
    [self.mapView clear];
    
    self.restaurantArray = [RestaurantManager sharedManager].filteredRestaurantArray;
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
    [self.restaurantView setRestaurant:self.restaurant];
}


#pragma mark - UI event

- (void)selSwipeRightGesture:(UISwipeGestureRecognizer *)sender {
    NSInteger index = [self.restaurantArray indexOfObject:self.restaurant];
    NSInteger nextIndex;
    if (index == [self.restaurantArray count] - 1) {
        nextIndex = 0;
    } else {
        nextIndex = index + 1;
    }
    self.restaurant = [self.restaurantArray objectAtIndex:nextIndex];
    self.mapView.selectedMarker = [self.markerArray objectAtIndex:nextIndex];
    [self.mapView animateToLocation:self.mapView.selectedMarker.position];
    
    CGRect defaultFrame = self.restaurantView.frame;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         CGRect frame = self.restaurantView.frame;
                         frame.origin.x += frame.size.width;
                         self.restaurantView.frame = frame;
                     }
                     completion:^(BOOL finished){
                         self.restaurantView.frame = defaultFrame;
                         [self.restaurantView setRestaurant:self.restaurant];
                     }];
}

- (void)selSwipeLeftGesture:(UISwipeGestureRecognizer *)sender {
    NSInteger index = [self.restaurantArray indexOfObject:self.restaurant];
    NSInteger nextIndex;
    if (index == 0) {
        nextIndex = [self.restaurantArray count] - 1;
    } else {
        nextIndex = index - 1;
    }
    self.restaurant = [self.restaurantArray objectAtIndex:nextIndex];
    self.mapView.selectedMarker = [self.markerArray objectAtIndex:nextIndex];
    [self.mapView animateToLocation:self.mapView.selectedMarker.position];

    CGRect defaultFrame = self.restaurantView.frame;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         CGRect frame = self.restaurantView.frame;
                         frame.origin.x -= frame.size.width;
                         self.restaurantView.frame = frame;
                     }
                     completion:^(BOOL finished){
                         self.restaurantView.frame = defaultFrame;
                         [self.restaurantView setRestaurant:self.restaurant];
                     }];
}


#pragma mark - GMSMapViewDelegate

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    self.restaurant = marker.userData;
    [self.restaurantView setRestaurant:self.restaurant];
    return NO;
}


- (void)onClickFooterView:(UITapGestureRecognizer *)sender {
    RestaurantDetailViewController *controller = [[RestaurantDetailViewController alloc]
                                                  initWithNibName:@"RestaurantDetailViewController" bundle:nil];
    [controller showRestaurant:self.restaurant];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.navigationController presentViewController:navController
                                            animated:YES
                                          completion:nil];
}


@end
