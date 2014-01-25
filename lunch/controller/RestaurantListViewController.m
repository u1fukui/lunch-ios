//
//  RestaurantListViewController.m
//  lunch
//
//  Created by u1 on 2014/01/25.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import "RestaurantListViewController.h"

@interface RestaurantListViewController ()

/** 表示条件ボタン */
@property (weak, nonatomic) IBOutlet UIButton *conditionButton;

/** 表示順ボタン */
@property (weak, nonatomic) IBOutlet UIButton *sortButton;

@end

@implementation RestaurantListViewController

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
    
    [self initButton:self.conditionButton];
    [self initButton:self.sortButton];
}

- (void)initButton:(UIButton *)button
{
    button.layer.borderColor = [UIColor grayColor].CGColor;
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 7.5f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
