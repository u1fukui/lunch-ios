//
//  RestaurantManager.h
//  lunch
//
//  Created by u1 on 2014/01/26.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

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

/** ユーザの現在地 */
@property (strong, nonatomic) CLLocation *currentLocation;

/** 近い順に並び替えをしたか */
@property (assign, nonatomic) BOOL isSortedList;


/**
 * シングルトンのインスタンス取得
 */
+ (RestaurantManager *)sharedManager;

/** お店情報を追加する */
- (void)add:(Restaurant *)r;

/** 表示条件に一致したお店しか表示しないようにする */
- (void)filter;

/** お店リストを近い順に並べ替える */
- (void)sortInOrderOfDistace;

@end
