//
//  MapViewController.h
//  lunch
//
//  Created by u1 on 2014/01/25.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController : UIViewController<CLLocationManagerDelegate, GMSMapViewDelegate, UIScrollViewDelegate>

@end
