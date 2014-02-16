//
//  RestaurantManager.h
//  lunch
//
//  Created by u1 on 2014/01/26.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Restaurant;

@interface RestaurantManager : NSObject

/** 表示条件の時刻 (HH:mm) */
@property (strong, nonatomic) NSString *filterTime;

/** 表示するお店情報の配列 */
@property (strong, nonatomic) NSMutableArray *filteredRestaurantArray;

/** お店リスト画面を更新する必要があるか */
@property (assign, nonatomic) BOOL needReloadTable;

/** 地図画面を更新する必要があるか */
@property (assign, nonatomic) BOOL needReloadMap;

/**
 * シングルトンのインスタンス取得
 */
+ (RestaurantManager *)sharedManager;

/**
 * お店情報を追加する
 */
- (void)add:(Restaurant *)r;

- (void)filter;

@end
