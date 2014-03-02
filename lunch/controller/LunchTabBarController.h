//
//  LunchTabBarController.h
//  lunch
//
//  Created by u1 on 2014/01/25.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ModalPickerViewController.h"

@interface LunchTabBarController : UITabBarController<ModalPickerViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end
