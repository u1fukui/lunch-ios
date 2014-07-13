//
//  UIView+Utils.m
//  lunch
//
//  Created by u1 on 2014/07/13.
//  Copyright (c) 2014年 u1. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

- (void)addShadow:(CGFloat)dy
{
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(0, dy);
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

@end
