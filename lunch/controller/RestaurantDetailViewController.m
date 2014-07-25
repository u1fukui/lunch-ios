//
//  RestaurantDetailViewController.m
//  lunch
//
//  Created by u1 on 2014/02/09.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import "RestaurantDetailViewController.h"
#import "Restaurant.h"
#import "InfoPlistProperty.h"
#import "RestaurantDetailView.h"
#import "RestaurantWebViewController.h"
#import "RestaurantMapViewController.h"

@interface RestaurantDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) Restaurant *restaurant;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) NADView *nadView;
@property (strong, nonatomic) RestaurantDetailView *detailView;

@end

@implementation RestaurantDetailViewController

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
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.navigationController.navigationBar.translucent = NO;
    
    // 閉じるボタン
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
    [self.closeButton setBackgroundImage:[UIImage imageNamed:@"close"]
                                    forState:UIControlStateNormal];
    [self.closeButton addTarget:self
                         action:@selector(onClickButton:)
               forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];

    // シェアボタン
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareButton.frame = CGRectMake(0.0f, 10.0f, 20.0f, 20.0f);
    [self.shareButton setBackgroundImage:[UIImage imageNamed:@"share"]
                                forState:UIControlStateNormal];
    [self.shareButton addTarget:self
                         action:@selector(onClickButton:)
               forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
    
    // 詳細情報
    self.detailView = [[RestaurantDetailView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 570.0f)];
    self.detailView.delegate = self;
    if (self.restaurant != nil) {
        [self.detailView showRestaurant:self.restaurant];
    }
    [self.scrollView addSubview:self.detailView];
    [self.scrollView setContentSize:self.detailView.frame.size];
    self.scrollView.showsVerticalScrollIndicator = NO;

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
    self.navigationItem.title = r.name;
    [self.detailView showRestaurant:r];
}


- (void)onClickButton:(UIButton *)button
{
    if (button == self.closeButton) {
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    } else if (button == self.shareButton) {
        // メール件名
        NSString *format = @"%@\n%@\n\n-----------------------------\n渋谷500円ランチ - iPhoneアプリ\n%@";
        NSString *appUrl = @"https://itunes.apple.com/ja/app/se-gu500yuanranchimap/id856723884?l=ja&ls=1&mt=8";
        NSString *text = [[NSString stringWithFormat:format,self.restaurant.name, self.restaurant.tabelogUrl, appUrl]
                             stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        // メーラー起動
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:[NSString stringWithFormat:@"mailto:?body=%@", text]]];
    }
}


#pragma mark - RestaurantDetailViewDelegate

- (void)didTabelogButtonClicked
{
    RestaurantWebViewController *controller = [[RestaurantWebViewController alloc]
                                               initWithNibName:@"RestaurantWebViewController" bundle:nil];
    [controller loadUrl:self.restaurant.tabelogUrl];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.navigationController presentViewController:navController
                                            animated:YES
                                          completion:nil];
}

- (void)didMapButtonClicked
{
    RestaurantMapViewController *controller = [[RestaurantMapViewController alloc]
                                               initWithNibName:@"RestaurantMapViewController" bundle:nil];
    [controller showRestaurant:self.restaurant];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.navigationController presentViewController:navController
                                            animated:YES
                                          completion:nil];
}

@end
