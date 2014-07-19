//
//  UIColor+Hex.h
//  lunch
//
//  Created by u1 on 2014/07/19.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

/**
 * 16進数で指定されたRGBでインスタンスを生成する
 *
 * @param     colorCode  RGB
 * @return    UIColorインスタンス
 */
+ (UIColor *)colorWithHex:(NSString *)colorCode;


/**
 * 16進数で指定されたRGBとAlpha値でインスタンスを生成する
 *
 * @param     colorCode   RGB
 * @param     alpha       Alpha値
 * @return    UIColorインスタンス
 */
+ (UIColor *)colorWithHex:(NSString *)colorCode alpha:(CGFloat)alpha;

@end
