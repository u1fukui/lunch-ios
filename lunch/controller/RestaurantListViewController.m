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
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

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
    
    self.restaurantTableView.delegate = self;
    self.restaurantTableView.dataSource = self;
    [self.restaurantTableView
                registerNib:[UINib nibWithNibName:@"RestaurantCell" bundle:nil]
     forCellReuseIdentifier:kCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateDescriptionView];
    
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

- (void)updateDescriptionView
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
    self.descriptionLabel.text = message;
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
    [self.navigationController presentViewController:controller
                                            animated:YES
                                          completion:nil];
}


@end
