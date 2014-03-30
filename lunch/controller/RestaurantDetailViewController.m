//
//  RestaurantDetailViewController.m
//  lunch
//
//  Created by u1 on 2014/02/09.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import "RestaurantDetailViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Restaurant.h"
#import "InfoPlistProperty.h"
#import "RestaurantWebViewController.h"

@interface RestaurantDetailViewController ()
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *featuredMenuLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *holidayLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UIButton *tabelogButton;

@property (strong, nonatomic) Restaurant *restaurant;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) NADView *nadView;

@end

@implementation RestaurantDetailViewController

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
    self.navigationItem.title = @"お店詳細";
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = CGRectMake(0.0f, 0.0f, 33.0f, 33.0f);
    [self.closeButton setBackgroundImage:[UIImage imageNamed:@"navigation_close_icon"]
                                    forState:UIControlStateNormal];
    [self.closeButton addTarget:self
                         action:@selector(onClickButton:)
               forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithCustomView:self.closeButton];
    
    // 地図
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
    
    // データセット
    [self show];
    [self.tabelogButton addTarget:self
                           action:@selector(onClickButton:)
                 forControlEvents:UIControlEventTouchUpInside];
    [[self.tabelogButton layer] setBorderColor:[self.tabelogButton.titleLabel.textColor CGColor]];
    [[self.tabelogButton layer] setBorderWidth:1.0];
    [[self.tabelogButton layer] setCornerRadius:7.0];
    [self.tabelogButton setClipsToBounds:YES];
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
    // Dispose of any resources that can be recreated.
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
    [self show];
}

- (void)show
{
    self.nameLabel.text = self.restaurant.name;
    self.addressLabel.text = self.restaurant.address;
    self.featuredMenuLabel.text = self.restaurant.featuredMenu;
    self.timeLabel.text = [NSString stringWithFormat:@"%@〜%@",
                           self.restaurant.startLunchTime,
                           self.restaurant.finishLunchTime];
    self.holidayLabel.text = self.restaurant.holiday;
    self.commentLabel.text = self.restaurant.comment;
}


- (void)onClickButton:(UIButton *)button
{
    if (button == self.closeButton) {
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    } else if (button == self.tabelogButton) {
        RestaurantWebViewController *controller = [[RestaurantWebViewController alloc]
                                                   initWithNibName:@"RestaurantWebViewController" bundle:nil];
        [controller loadUrl:self.restaurant.tabelogUrl];
        [self.navigationController pushViewController:controller
                                             animated:YES];
    }
}

@end
