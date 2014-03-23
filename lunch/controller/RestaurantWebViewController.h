//
//  RestaurantWebViewController.h
//  lunch
//
//  Created by u1 on 2014/03/23.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NADView.h"

@interface RestaurantWebViewController : UIViewController<UIWebViewDelegate, NADViewDelegate>

- (void)loadUrl:(NSString *)url;

@end
