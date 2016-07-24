//
//  UILabel+DSLIndexView.m
//  DSLIndexView
//
//  Created by dengshunlai on 16/1/12.
//  Copyright © 2016年 dengshunlai. All rights reserved.
//

#import "UILabel+DSLIndexView.h"
#import <objc/runtime.h>

static void *key = &key;

@implementation UILabel (DSLIndexView)

- (CGFloat)dsl_fromValue
{
    NSNumber *number = objc_getAssociatedObject(self, key);
    
    return [number doubleValue];
}

- (void)setDsl_fromValue:(CGFloat)dsl_fromValue
{
    NSNumber *number = [NSNumber numberWithDouble:dsl_fromValue];
    
    objc_setAssociatedObject(self, key, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
