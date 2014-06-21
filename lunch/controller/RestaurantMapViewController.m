//
//  RestaurantMapViewController.m
//  lunch
//
//  Created by u1 on 2014/06/17.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import "RestaurantMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "InfoPlistProperty.h"
#import "Restaurant.h"

@interface RestaurantMapViewController ()
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *adView;

@property (strong, nonatomic) NADView *nadView;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) Restaurant *restaurant;

@end

@implementation RestaurantMapViewController

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
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // ナビゲーションバー
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bg"]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = @"お店の場所";
    
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0.0f, 0.0f, 33.0f, 33.0f);
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"navigation_back"]
                               forState:UIControlStateNormal];
    [self.backButton addTarget:self
                        action:@selector(onClickButton:)
              forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.leftBarButtonItem = item;
    
    self.mapView.camera =  [GMSCameraPosition cameraWithLatitude:self.restaurant.lat
                                                       longitude:self.restaurant.lng
                                                            zoom:16];
    self.mapView.myLocationEnabled = YES;

    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(self.restaurant.lat,
                                                                    self.restaurant.lng);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.map = self.mapView;
    [self.mapView reloadInputViews];
    
    
    // 広告
    self.nadView = [[NADView alloc] initWithFrame:CGRectMake(0,0,
                                                             NAD_ADVIEW_SIZE_320x50.width, NAD_ADVIEW_SIZE_320x50.height )];
    [self.nadView setIsOutputLog:NO];
    [self.nadView setNendID:[[[NSBundle mainBundle] infoDictionary] objectForKey:kNendId]
                     spotID:[[[NSBundle mainBundle] infoDictionary] objectForKey:kNendSpotId]];
    [self.nadView setDelegate:self];
    [self.nadView load];
    [self.adView addSubview:self.nadView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.nadView resume];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.nadView pause];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [self.nadView setDelegate:nil];
    self.nadView = nil;
}


#pragma mark -

- (void)showRestaurant:(Restaurant *)r
{
    self.restaurant = r;
}


#pragma mark - UI event

- (void)onClickButton:(UIButton *)button
{
    if (button == self.backButton) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
