//
//  MapViewController.m
//  lunch
//
//  Created by u1 on 2014/01/25.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

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
    self.mapView.camera =  [GMSCameraPosition cameraWithLatitude:35.658517
                                                       longitude:139.701334
                                                            zoom:14];
    self.mapView.myLocationEnabled = YES;
    
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

// 位置情報更新時
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    [self.mapView animateToLocation:[newLocation coordinate]];
    
    //緯度・経度を出力
    NSLog(@"didUpdateToLocation latitude=%f, longitude=%f",
          [newLocation coordinate].latitude,
          [newLocation coordinate].longitude);
}

// 測位失敗時や、位置情報の利用をユーザーが「不許可」とした場合などに呼ばれる
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError");
}

@end
