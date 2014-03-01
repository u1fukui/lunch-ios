//
//  Restaurant.h
//  lunch
//
//  Created by u1 on 2014/01/25.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject

/** 識別ID  */
@property (strong, nonatomic) NSString *restaurantId;

/** 店名 */
@property (strong, nonatomic) NSString *name;

/** 住所 */
@property (strong, nonatomic) NSString *address;

/** 緯度 */
@property (assign, nonatomic) double lat;

/** 軽度 */
@property (assign, nonatomic) double lng;

/** おすすめメニュー */
@property (strong, nonatomic) NSString *featuredMenu;

/** お昼の営業開始時間 */
@property (strong, nonatomic) NSString *startLunchTime;

/** お昼の営業修了時間 */
@property (strong, nonatomic) NSString *finishLunchTime;

/** 定休日 */
@property (strong, nonatomic) NSString *holiday;

/** 食べログURL */
@property (strong, nonatomic) NSString *tabelogUrl;

/** サムネイル画像のファイル名 */
@property (strong, nonatomic) NSString *thumbnailName;


+(id)initWithCsvArray:(NSArray *)array;

@end
