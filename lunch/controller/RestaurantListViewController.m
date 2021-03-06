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
#import "RestaurantDetailViewController.h"
#import "LunchTabBarController.h"

@interface RestaurantListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *restaurantTableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

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
    
    // リスト
    self.restaurantTableView.delegate = self;
    self.restaurantTableView.dataSource = self;
    [self.restaurantTableView
                registerNib:[UINib nibWithNibName:@"RestaurantCell" bundle:nil]
     forCellReuseIdentifier:kCellIdentifier];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.restaurantTableView.backgroundColor = appDelegate.baseColor;
    
    // 引っ張って更新
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"近い順に並び替え"];
    [self.refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.restaurantTableView addSubview:self.refreshControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([RestaurantManager sharedManager].needReloadTable) {
        [self.restaurantTableView reloadData];
        [RestaurantManager sharedManager].needReloadTable = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onRefresh:(id)sender
{
    [self.refreshControl beginRefreshing];
    
    LunchTabBarController *controller = (LunchTabBarController *) self.tabBarController;
    [controller updateLocation];
    [[RestaurantManager sharedManager] sortInOrderOfDistace];
    [self.restaurantTableView reloadData];
    [controller updateConditionLabel];
    
    [self.refreshControl endRefreshing];
}


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [RestaurantManager sharedManager].filteredRestaurantArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[RestaurantCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                  reuseIdentifier:kCellIdentifier];
    }
    
    Restaurant *restaurant = [[RestaurantManager sharedManager].filteredRestaurantArray objectAtIndex:indexPath.row];
    [cell setRestaurant:restaurant];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    Restaurant *r = [[RestaurantManager sharedManager].filteredRestaurantArray objectAtIndex:indexPath.row];
    RestaurantDetailViewController *controller = [[RestaurantDetailViewController alloc]
                                                  initWithNibName:@"RestaurantDetailViewController" bundle:nil];
    [controller showRestaurant:r];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.navigationController presentViewController:navController
                                            animated:YES
                                          completion:nil];
}


@end
