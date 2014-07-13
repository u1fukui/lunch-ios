//
//  UINavigationBar+DropShadow.m
//  lunch
//
//  Created by u1 on 2014/07/13.
//  Copyright (c) 2014年 u1. All rights reserved.
//
//  参考: http://qiita.com/hondasports8/items/16cc7632170c9832a059

#import "UINavigationBar+DropShadow.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Utils.h"

@implementation UINavigationBar (DropShadow)

-(void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self addShadow:1.5f];
}

@end
