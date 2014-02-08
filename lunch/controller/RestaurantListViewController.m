//
//  RestaurantListViewController.m
//  lunch
//
//  Created by u1 on 2014/01/25.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import "RestaurantListViewController.h"
#import "Restaurant.h"
#import "RestaurantCell.h"
#import "RestaurantManager.h"

@interface RestaurantListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *restaurantTableView;

@end

@implementation RestaurantListViewController

NSString * const kCellIdentifier = @"launch_app";

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"%s", __func__);
    
    self.restaurantTableView.delegate = self;
    self.restaurantTableView.dataSource = self;
    [self.restaurantTableView
                registerNib:[UINib nibWithNibName:@"RestaurantCell" bundle:nil]
     forCellReuseIdentifier:kCellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [RestaurantManager sharedManager].restaurantArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[RestaurantCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                  reuseIdentifier:kCellIdentifier];
    }
    
    Restaurant *restaurant = [[RestaurantManager sharedManager].restaurantArray
                              objectAtIndex:indexPath.row];
    [cell setRestaurant:restaurant];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RestaurantCell cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 何もしない
}


@end
