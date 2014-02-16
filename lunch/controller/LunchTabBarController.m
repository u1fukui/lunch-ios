//
//  LunchTabBarController.m
//  lunch
//
//  Created by u1 on 2014/01/25.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import "LunchTabBarController.h"
#import "RestaurantManager.h"

@interface LunchTabBarController ()

@property (nonatomic, strong) UIButton *conditionButton;
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
	// Do any additional setup after loading the view.
    NSLog(@"%s", __func__);
    
    self.pickerDataArray = @[@"11:00", @"11:30", @"12:00", @"12:30",
                             @"13:00", @"13:30", @"14:00", @"14:30",
                             @"15:00", @"15:30", @"16:00"];
    
    // ナビゲーション
    UIImage *navImage = [UIImage imageNamed:@"navigation_bg"];
    [self.navigationController.navigationBar setBackgroundImage:navImage
                                                  forBarMetrics:UIBarMetricsDefault];
    
    // 条件設定ボタン
    self.conditionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.conditionButton.frame = CGRectMake(0.0f, 0.0f, 33.0f, 33.0f);
    [self.conditionButton setBackgroundImage:[UIImage imageNamed:@"navigation_info"]
                                    forState:UIControlStateNormal];
    [self.conditionButton addTarget:self
                             action:@selector(onClickButton:)
                   forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.conditionButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
    //保存
    [RestaurantManager sharedManager].filterTime = self.selectedData;
    [[RestaurantManager sharedManager] filter];
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
    
    int count = self.pickerDataArray.count;
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


@end
