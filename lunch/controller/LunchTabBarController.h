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
#import "NADView.h"

@interface LunchTabBarController : UITabBarController<ModalPickerViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate, NADViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

- (void)updateLocation;

- (void)updateConditionLabel;

@end
