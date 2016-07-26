//
//  UILabel+DSLIndexView.m
//  DSLIndexView
//
//  Created by dengshunlai on 16/1/12.
//  Copyright © 2016年 dengshunlai. All rights reserved.
//

#import "UILabel+DSLIndexView.h"
#import <objc/runtime.h>

static void *dsl_key = &dsl_key;

@implementation UILabel (DSLIndexView)

- (CGFloat)dsl_fromValue
{
    NSNumber *number = objc_getAssociatedObject(self, dsl_key);
    return [number doubleValue];
}

- (void)setDsl_fromValue:(CGFloat)dsl_fromValue
{
    NSNumber *number = [NSNumber numberWithDouble:dsl_fromValue];
    objc_setAssociatedObject(self, dsl_key, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
