//
//  UITableView+DSLIndexView.m
//  DSLIndexView
//
//  Created by qwb on 16/7/27.
//  Copyright © 2016年 邓顺来. All rights reserved.
//

#import "UITableView+DSLIndexView.h"
#import <objc/runtime.h>

static CGFloat const kFeatureRoundSize = 50;

@interface UITableView ()

@property (strong, nonatomic) UIView *dsl_indexContainerView;
@property (strong, nonatomic) DSLIndexView *dsl_indexView;

@end

@implementation UITableView (DSLIndexView)

#pragma mark - obj_associate

- (UIView *)dsl_indexContainerView
{
    UIView *view = objc_getAssociatedObject(self, @selector(dsl_indexContainerView));
    if (!view) {
        self.dsl_indexContainerView = view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
    }
    return view;
}

- (void)setDsl_indexContainerView:(UIView *)dsl_indexContainerView
{
    objc_setAssociatedObject(self, @selector(dsl_indexContainerView), dsl_indexContainerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DSLIndexView *)dsl_indexView
{
    return objc_getAssociatedObject(self, @selector(dsl_indexView));
}

- (void)setDsl_indexView:(DSLIndexView *)dsl_indexView
{
    objc_setAssociatedObject(self, @selector(dsl_indexView), dsl_indexView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DSLIndexViewSelectBlock)dsl_didSelectIndexBlock
{
    return objc_getAssociatedObject(self, @selector(dsl_didSelectIndexBlock));
}

- (void)setDsl_didSelectIndexBlock:(DSLIndexViewSelectBlock)dsl_didSelectIndexBlock
{
    objc_setAssociatedObject(self, @selector(dsl_didSelectIndexBlock), dsl_didSelectIndexBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - instance method

- (void)dsl_setupIndexViewWithIndexs:(NSArray *)indexs
{
    [self dsl_setupIndexViewWithIndexs:indexs style:DSLIndexViewStyleWave];
}

- (void)dsl_setupIndexViewWithIndexs:(NSArray *)indexs style:(DSLIndexViewStyle)style
{
    __weak typeof(self) weakSelf = self;
    self.dsl_indexView = [DSLIndexView indexViewWithIndexTitles:indexs style:style];
    [self.dsl_indexView didSelectIndexWithCallBack:^(NSInteger index) {
        if (weakSelf.dsl_didSelectIndexBlock) {
            weakSelf.dsl_didSelectIndexBlock(index);
        } else {
            if (index < weakSelf.numberOfSections) {
                [weakSelf scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                                atScrollPosition:UITableViewScrollPositionTop
                                        animated:NO];
            }
        }
    }];
    [self.dsl_indexContainerView addSubview:self.dsl_indexView];
    self.dsl_indexView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.dsl_indexContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.dsl_indexView
                                                                            attribute:NSLayoutAttributeCenterX
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.dsl_indexContainerView
                                                                            attribute:NSLayoutAttributeCenterX
                                                                           multiplier:1
                                                                             constant:0]];
    [self.dsl_indexContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.dsl_indexView
                                                                            attribute:NSLayoutAttributeCenterY
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.dsl_indexContainerView
                                                                            attribute:NSLayoutAttributeCenterY
                                                                           multiplier:1
                                                                             constant:0]];
    [self.dsl_indexContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.dsl_indexView
                                                                            attribute:NSLayoutAttributeWidth
                                                                            relatedBy:0
                                                                               toItem:nil
                                                                            attribute:0
                                                                           multiplier:1
                                                                             constant:self.dsl_indexView.fitWidth]];
    [self.dsl_indexContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.dsl_indexView
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:0
                                                                               toItem:nil
                                                                            attribute:0
                                                                           multiplier:1
                                                                             constant:self.dsl_indexView.fitHeight]];
    [self addSubview:self.dsl_indexContainerView];
    
    if (style == DSLIndexViewStyleFeatureRound) {
        [self addSubview:self.dsl_indexView.featureView];
        self.dsl_indexView.featureView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.dsl_indexView.featureView
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.dsl_indexView.featureView
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.dsl_indexView
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.dsl_indexView.featureView
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:0
                                                        multiplier:1
                                                          constant:kFeatureRoundSize]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.dsl_indexView.featureView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:0
                                                        multiplier:1
                                                          constant:kFeatureRoundSize]];
    }
    [self addObserver:self.dsl_indexView forKeyPath:@"bounds" options:NSKeyValueObservingOptionInitial context:nil];
    [self.dsl_indexView setObserverBlock:^(DSLIndexView *indexView) {
        weakSelf.dsl_indexContainerView.frame = CGRectMake(weakSelf.bounds.size.width - indexView.fitWidth, weakSelf.bounds.origin.y, indexView.fitWidth, weakSelf.bounds.size.height);
        [weakSelf bringSubviewToFront:weakSelf.dsl_indexContainerView];
        [weakSelf bringSubviewToFront:indexView.featureView];
    }];
}

#pragma mark - hit test
#pragma mark - warn categpory override subclass override
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.decelerating) {
        CGFloat x = point.x;
        if (x >= self.frame.size.width - self.dsl_indexContainerView.frame.size.width) {
            self.scrollEnabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.scrollEnabled = YES;
            });
        }
    }
    return YES;
}

#pragma mark - view hierarchy
#pragma mark - warn categpory override subclass override
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self removeObserver:self.dsl_indexView forKeyPath:@"bounds"];
    }
}

@end
