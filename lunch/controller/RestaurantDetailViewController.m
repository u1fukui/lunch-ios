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
    
    // ナビゲーションバー
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bg"]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = CGRectMake(0.0f, 0.0f, 33.0f, 33.0f);
    [self.closeButton setBackgroundImage:[UIImage imageNamed:@"navigation_close_icon"]
                                    forState:UIControlStateNormal];
    [self.closeButton addTarget:self
                         action:@selector(onClickButton:)
               forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];
    
    self.detailView = [[RestaurantDetailView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 667.0f)];
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
    }
}


#pragma mark - RestaurantDetailViewDelegate

- (void)didTabelogButtonClicked
{
    RestaurantWebViewController *controller = [[RestaurantWebViewController alloc]
                                               initWithNibName:@"RestaurantWebViewController" bundle:nil];
    [controller loadUrl:self.restaurant.tabelogUrl];
    [self.navigationController pushViewController:controller
                                         animated:YES];
}

- (void)didMapButtonClicked
{
    RestaurantMapViewController *controller = [[RestaurantMapViewController alloc]
                                               initWithNibName:@"RestaurantMapViewController" bundle:nil];
    [controller showRestaurant:self.restaurant];
    [self.navigationController pushViewController:controller
                                         animated:YES];
}

@end
