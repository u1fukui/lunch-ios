//
//  RestaurantWebViewController.m
//  lunch
//
//  Created by u1 on 2014/03/23.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import "RestaurantWebViewController.h"
#import "InfoPlistProperty.h"
#import "SVProgressHUD.h"
#import "UIView+Utils.h"

@interface RestaurantWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) NADView *nadView;
@property (strong, nonatomic) NSString *url;

@end

@implementation RestaurantWebViewController

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
    self.navigationItem.title = @"食べログ";
    
    
    // ナビゲーションバー
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bg"]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
    [self.closeButton setBackgroundImage:[UIImage imageNamed:@"close"]
                                forState:UIControlStateNormal];
    [self.closeButton addTarget:self
                         action:@selector(onClickButton:)
               forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];
    
    // WebView
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    [self loadUrl:self.url];
    
    // 広告
    self.nadView = [[NADView alloc] initWithFrame:CGRectMake(0,0,
                                                             NAD_ADVIEW_SIZE_320x50.width, NAD_ADVIEW_SIZE_320x50.height )];
    [self.nadView setIsOutputLog:NO];
    [self.nadView setNendID:[[[NSBundle mainBundle] infoDictionary] objectForKey:kNendId]
                     spotID:[[[NSBundle mainBundle] infoDictionary] objectForKey:kNendSpotId]];
    [self.nadView setDelegate:self];
    [self.nadView load];
    [self.adView addSubview:self.nadView];
    [self.adView addShadow:-1.5f];
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
    [SVProgressHUD dismiss];
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


#pragma mark - Public methods

- (void)loadUrl:(NSString *)url
{
    self.url = url;
    if (url == nil) {
        return;
    }
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:req];
}


#pragma mark - UI event

- (void)onClickButton:(UIButton *)button
{
    if (button == self.closeButton) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - UIWebViewDelegate

-(void)webViewDidStartLoad:(UIWebView*)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [SVProgressHUD show];
}

-(void)webViewDidFinishLoad:(UIWebView*)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [SVProgressHUD dismiss];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        RestaurantWebViewController *controller = [[RestaurantWebViewController alloc]
                                                   initWithNibName:@"RestaurantWebViewController" bundle:nil];
        [controller loadUrl:[[request URL] absoluteString]];
        [self.navigationController pushViewController:controller
                                             animated:YES];
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([error code] != NSURLErrorCancelled) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                        message:@"ページの取得に失敗しました"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

@end
