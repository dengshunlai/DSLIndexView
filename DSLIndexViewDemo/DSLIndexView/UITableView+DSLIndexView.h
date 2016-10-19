//
//  UITableView+DSLIndexView.h
//  DSLIndexView
//
//  Created by qwb on 16/7/27.
//  Copyright © 2016年 邓顺来. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSLIndexView.h"

@interface UITableView (DSLIndexView)

/**
 *  安装索引条
 *
 *  @param indexs 索引字数组
 */
- (void)dsl_setupIndexViewWithIndexs:(NSArray *)indexs;

/**
 *  安装索引条
 *
 *  @param indexs 索引字数组
 *  @param style  索引样式
 */
- (void)dsl_setupIndexViewWithIndexs:(NSArray *)indexs style:(DSLIndexViewStyle)style;

/**
 *  设置索引字的字体大小，默认14
 *
 *  @param fontSize 字体大小
 */
- (void)dsl_setIndexFontSize:(CGFloat)fontSize;

/**
 *  点击索引字后触发的回调
 *
 *  默认的回调为tebleView滚动到对应的section :
 *  if (index < weakSelf.numberOfSections) {
 *      [weakSelf scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
 *                      atScrollPosition:UITableViewScrollPositionTop
 *                              animated:NO];
 *  }
 */
- (void)setDsl_didSelectIndexBlock:(DSLIndexViewSelectBlock)dsl_didSelectIndexBlock;

@end
