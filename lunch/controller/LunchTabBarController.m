//
//  LunchTabBarController.m
//  lunch
//
//  Created by u1 on 2014/01/25.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import "LunchTabBarController.h"
#import "RestaurantManager.h"
#import "InfoPlistProperty.h"
#import "UIColor+Hex.h"

@interface LunchTabBarController ()

@property (nonatomic, strong) NADView *nadView;
@property (nonatomic, strong) UILabel *conditionLabel;
@property (nonatomic, strong) UIButton *conditionButton;
@property (nonatomic, strong) UIButton *infoButton;
@property (nonatomic, strong) NSArray *pickerDataArray;
@property (nonatomic, strong) ModalPickerViewController *pickerViewController;
@property (nonatomic, strong) NSString *selectedData;

@end

@implementation LunchTabBarController

int const kPickerViewTag = 1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pickerDataArray = @[@"全て", @"11:00", @"11:30", @"12:00", @"12:30",
                             @"13:00", @"13:30", @"14:00", @"14:30",
                             @"15:00", @"15:30", @"16:00"];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // タブアイコン
    UIViewController *vc1 = [self.viewControllers objectAtIndex:0];
    UIImage *image1 = [[UIImage imageNamed:@"tab_list_disable"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage1 = [[UIImage imageNamed:@"tab_list"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc1.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:image1 selectedImage:selectedImage1];

    UIEdgeInsets insets;
    insets.top = 5.0;
    insets.bottom = -5.0;
    vc1.tabBarItem.imageInsets = insets;
    
    UIViewController *vc2 = [self.viewControllers objectAtIndex:1];
    UIImage *image2 = [[UIImage imageNamed:@"tab_map_disable"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage2 = [[UIImage imageNamed:@"tab_map"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:image2 selectedImage:selectedImage2];
    vc2.tabBarItem.imageInsets = insets;

    // 広告
    int contentHeight = self.view.frame.size.height -
    self.navigationController.navigationBar.frame.size.height - 20; // screen - navigationBar - statusBar
    self.nadView = [[NADView alloc] initWithFrame:
                    CGRectMake(0, contentHeight - NAD_ADVIEW_SIZE_320x50.height,
                               NAD_ADVIEW_SIZE_320x50.width, NAD_ADVIEW_SIZE_320x50.height)];
    [self.nadView setIsOutputLog:NO];
    [self.nadView setNendID:[[[NSBundle mainBundle] infoDictionary] objectForKey:kNendId]
                     spotID:[[[NSBundle mainBundle] infoDictionary] objectForKey:kNendSpotId]];
    [self.nadView setDelegate:self];
    [self.nadView load];
    [self.view addSubview:self.nadView];

    // 広告枠分だけTabBarを空ける
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.origin.y -= NAD_ADVIEW_SIZE_320x50.height;
    self.tabBar.frame = tabFrame;
    
    // 影を付ける
    UIImageView *topShadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tabFrame.size.width, 1)];
    [topShadow setImage:[UIImage imageNamed:@"shadow_btm"]];
    UIImageView *bottomShadow = [[UIImageView alloc] initWithFrame:
                                 CGRectMake(0, tabFrame.size.height - 1, tabFrame.size.width, 1)];
    [bottomShadow setImage:[UIImage imageNamed:@"shadow_up"]];
    [self.tabBar addSubview:topShadow];
    [self.tabBar addSubview:bottomShadow];
    
    // タブの背景色
    self.tabBar.barTintColor = [UIColor colorWithHex:@"#f7f3e9"];

    // ナビゲーション
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bg"]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = @"渋谷500円ランチ";
    
    // メールボタン
    self.infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.infoButton.frame = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
    [self.infoButton setImage:[UIImage imageNamed:@"misc"]
                     forState:UIControlStateNormal];
    [self.infoButton addTarget:self
                        action:@selector(onClickButton:)
              forControlEvents:UIControlEventTouchUpInside];
    self.infoButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.infoButton];
    
    // 条件設定ボタン
    self.conditionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.conditionButton.frame = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
    [self.conditionButton setBackgroundImage:[UIImage imageNamed:@"clock"]
                                    forState:UIControlStateNormal];
    [self.conditionButton addTarget:self
                             action:@selector(onClickButton:)
                   forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.conditionButton];
    
    // 条件表示
    self.conditionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    [self.conditionLabel setBackgroundColor:[UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1.0]];
    [self.conditionLabel setTextColor:[UIColor whiteColor]];
    [self.conditionLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [self.conditionLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.conditionLabel];
    
    // 位置情報
    self.locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager.delegate = self;
        [self updateLocation];
    } else {
        NSLog(@"Location services not available.");
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.nadView resume];
    [self updateConditionLabel];
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

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)updateConditionLabel
{
    NSString *filter = [RestaurantManager sharedManager].filterTime;
    NSMutableString *message;
    if (filter) {
        message = [NSMutableString stringWithFormat:@"%@に営業しているお店を", filter];
    } else {
        message = [NSMutableString stringWithFormat:@"全てのお店を"];
    }
    
    if ([RestaurantManager sharedManager].currentLocation) {
        [message appendString:@"近い順に"];
    }
    [message appendString:@"表示"];
    self.conditionLabel.text = message;
}

-(void)updateLocation
{
    [self.locationManager startUpdatingLocation];
}


#pragma mark -

- (void)onClickButton:(UIButton *)button
{
    if (button == self.conditionButton) {
        if (self.pickerViewController != nil) {
            // picker表示中の場合は何もしない
            return;
        }
        
        self.pickerViewController = [[ModalPickerViewController alloc]
                                     initWithNibName:@"ModalPickerViewController" bundle:nil];
        self.pickerViewController.delegate = self;
        self.pickerViewController.view.tag = kPickerViewTag;
        CGRect frame = self.view.frame;
        frame.origin.y -= self.navigationController.navigationBar.frame.size.height + 20; // navigationBar + statusBar
        self.pickerViewController.view.frame = frame;
        [self.view addSubview:self.pickerViewController.view];
        
        // アニメーション
        CGPoint pickerViewCenter = self.pickerViewController.view.center;
        CGSize offSize = [UIScreen mainScreen].bounds.size;
        CGPoint startCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
        self.pickerViewController.view.center = startCenter;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        self.pickerViewController.view.center = pickerViewCenter;
        [UIView commitAnimations];
    } else if (button == self.infoButton) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"開発者に教える" message:@"情報の間違いや、他にオススメのお店があったら教えて下さいm(_ _)m"
                                  delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"メールする", nil];
        alert.delegate = self;
        [alert show];
    }
}

- (void)closeAnimationPickerView
{
    // アニメーション
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint startCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
    self.pickerViewController.view.center = startCenter;
    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID
                finished:(NSNumber *)finished
                 context:(void *)context
{
    // 削除
    UIView *view = [self.view viewWithTag:kPickerViewTag];
    [view removeFromSuperview];
    self.pickerViewController.delegate = nil;
    self.pickerViewController = nil;
}


#pragma mark - ModalPickerViewController

- (void)didOkButtonClicked:(ModalPickerViewController *)controller
                       tag:(NSString *)tag
{
    if ([self.pickerDataArray[0] isEqualToString:self.selectedData]) {
        self.selectedData = nil;
    }
    
    //保存
    [RestaurantManager sharedManager].filterTime = self.selectedData;
    [[RestaurantManager sharedManager] filter];
    [[RestaurantManager sharedManager] sortInOrderOfDistace];
    [self closeAnimationPickerView];
    
    [RestaurantManager sharedManager].needReloadTable = YES;
    [RestaurantManager sharedManager].needReloadMap = YES;
    [self viewWillAppear:NO];
}

- (void)didCancelButtonClicked:(ModalPickerViewController *)controller
                           tag:(NSString *)tag
{
    [self closeAnimationPickerView];
}

- (int)initialPickerRow
{
    NSString *filterTime = [RestaurantManager sharedManager].filterTime;
    if (filterTime == nil) {
        return 0;
    }
    
    NSUInteger count = self.pickerDataArray.count;
    for (int i = 0; i < count; i++) {
        if ([filterTime isEqualToString:self.pickerDataArray[i]]) {
            return i;
        }
    }
        
    return 0;
}


#pragma mark - UIPickerViewDataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerDataArray.count;
}


#pragma mark - UIPickerViewDelegate

-(NSString*)pickerView:(UIPickerView*)pickerView
           titleForRow:(NSInteger)row
          forComponent:(NSInteger)component
{
    return self.pickerDataArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedData = self.pickerDataArray[row];
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"update location");
	[RestaurantManager sharedManager].currentLocation =
        [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude
                                   longitude:newLocation.coordinate.longitude];
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
}


#pragma mark - UIAlertViewDelegate

// アラートのボタンが押された時に呼ばれるデリゲート例文
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *subject = [@"渋谷500円ランチお問い合わせ"
                             stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        // メーラー起動
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@?Subject=%@",
                               [[[NSBundle mainBundle] infoDictionary] objectForKey:kSupportEmailAddress], subject]]];
    }
}

@end
