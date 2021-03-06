//
//  AppDelegate.m
//  lunch
//
//  Created by u1 on 2014/01/25.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Restaurant.h"
#import "RestaurantManager.h"
#import "UIColor+Hex.h"

@implementation AppDelegate

// デバッグ出力
void uncaughtExceptionHandler(NSException *exception)
{
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.themeColor = [UIColor colorWithHex:@"#ed1c24"];
    self.baseColor = [UIColor colorWithHex:@"#fef9eaf"];
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    [GMSServices provideAPIKey:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"GoogleMapsApiKey"]];
    [self loadRestaurantFile:[[NSBundle mainBundle] pathForResource:@"lunch" ofType:@"csv"]];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        [UINavigationBar appearance].barTintColor = self.themeColor;
    } else {
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBackgroundColor:self.themeColor];
        [[UINavigationBar appearance] setTintColor:self.themeColor];
    }
    
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"shadow_btm"]];
    
    return YES;
}

- (void)loadRestaurantFile:(NSString *)path
{
    // UTF8 エンコードされた CSV ファイル
    NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    // 改行文字で区切って配列に格納する
    NSArray *lines = [text componentsSeparatedByString:@"\n"];
    
    for (NSString *row in lines) {
        // コンマで区切って配列に格納する
        NSArray *items = [row componentsSeparatedByString:@","];
        Restaurant *r = [Restaurant initWithCsvArray:items];
        [[RestaurantManager sharedManager] add:r];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
