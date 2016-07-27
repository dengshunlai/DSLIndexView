//
//  UITableView+DSLIndexView.m
//  DSLIndexView
//
//  Created by qwb on 16/7/27.
//  Copyright © 2016年 邓顺来. All rights reserved.
//

#import "UITableView+DSLIndexView.h"
#import <objc/runtime.h>

@interface UITableView ()

@property (strong, nonatomic) DSLIndexView *dsl_indexView;
@property (strong, nonatomic) NSArray *dsl_indexs;

@end

@implementation UITableView (DSLIndexView)

- (DSLIndexView *)dsl_indexView
{
    return objc_getAssociatedObject(self, @selector(dsl_indexView));
}

- (void)setDsl_indexView:(DSLIndexView *)dsl_indexView
{
    objc_setAssociatedObject(self, @selector(dsl_indexView), dsl_indexView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)dsl_indexs
{
    return objc_getAssociatedObject(self, @selector(dsl_indexs));
}

- (void)setDsl_indexs:(NSArray *)dsl_indexs
{
    objc_setAssociatedObject(self, @selector(dsl_indexs), dsl_indexs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)dsl_setupIndexViewWithIndexs:(NSArray *)indexs
{
    [self dsl_setupIndexViewWithIndexs:indexs style:DSLIndexViewStyleWave];
}

- (void)dsl_setupIndexViewWithIndexs:(NSArray *)indexs style:(DSLIndexViewStyle)style
{
    self.dsl_indexs = indexs;
    self.dsl_indexView = [DSLIndexView indexViewWithIndexTitles:indexs style:style];
    [self.superview addSubview:self.dsl_indexView];
    self.dsl_indexView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.dsl_indexView
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.superview
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1
                                                                constant:0]];
    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[dsl_indexView(width)]|"
                                                                           options:0
                                                                           metrics:@{@"width":@(self.dsl_indexView.fitWidth)}
                                                                             views:@{@"dsl_indexView":self.dsl_indexView}]];
    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[dsl_indexView(height)]"
                                                                           options:0
                                                                           metrics:@{@"height":@(self.dsl_indexView.fitHeight)}
                                                                             views:@{@"dsl_indexView":self.dsl_indexView}]];
}

@end
