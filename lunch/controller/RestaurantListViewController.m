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

@interface RestaurantListViewController ()

@property (weak, nonatomic) IBOutlet UIButton *conditionButton;
@property (weak, nonatomic) IBOutlet UIButton *sortButton;
@property (weak, nonatomic) IBOutlet UITableView *restaurantTableView;

@property NSMutableArray *restaurantArray;

@end

@implementation RestaurantListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"%s", __func__);
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.restaurantArray = [NSMutableArray array];
        NSArray *nameArray = @[ @"サブウェイ", @"松屋", @"すき家", @"マクドナルド", @"吉野家"];
        for (NSString *name in nameArray) {
            Restaurant *restaurant = [[Restaurant alloc] init];
            restaurant.name = name;
            [self.restaurantArray addObject:restaurant];            
        }

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
    
    self.restaurantTableView.delegate = self;
    self.restaurantTableView.dataSource = self;
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


#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.restaurantArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    RestaurantCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[RestaurantCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    Restaurant *restaurant = [self.restaurantArray objectAtIndex:indexPath.row];
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
