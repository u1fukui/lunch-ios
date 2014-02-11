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
@property (weak, nonatomic) IBOutlet RestaurantSimpleView *footerView;
@property (strong, nonatomic) RestaurantSimpleView *restaurantView;
@property (strong, nonatomic) CLLocationManager *locationManager;
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
    NSLog(@"%s", __func__);
    
    // 地図初期化
    self.mapView.delegate = self;
    self.mapView.camera =  [GMSCameraPosition cameraWithLatitude:35.658517
                                                       longitude:139.701334
                                                            zoom:15];
    self.mapView.myLocationEnabled = YES;
    
    for (Restaurant *r in [RestaurantManager sharedManager].restaurantArray) {
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(r.lat, r.lng);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.title = r.name;
        marker.userData = r;
        marker.map = self.mapView;
    }
    
    // お店情報
    self.restaurant = [[RestaurantManager sharedManager].restaurantArray
                       objectAtIndex:0];
    self.restaurantView = [[RestaurantSimpleView alloc]
                           initWithFrame:self.footerView.bounds];
    [self.restaurantView setRestaurant:self.restaurant];
    [self.footerView addSubview:self.restaurantView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickFooterView:)];
    [self.footerView addGestureRecognizer:tapGesture];
    
    // 位置情報
    self.locationManager = [[CLLocationManager alloc] init];
    
    // 位置情報サービスが利用できるかどうかをチェック
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
    } else {
        NSLog(@"Location services not available.");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CLLocationManagerDelegate

// 測位失敗時や、位置情報の利用をユーザーが「不許可」とした場合などに呼ばれる
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError");
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
    [self.navigationController presentViewController:controller
                                            animated:YES
                                          completion:nil];
}


@end
