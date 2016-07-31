//
//  DSLIndexView.h
//  DSLIndexView
//
//  Created by dengshunlai on 16/1/7.
//  Copyright © 2016年 dengshunlai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSLIndexFeatureView.h"

typedef void (^DSLIndexViewSelectBlock)(NSInteger index);

typedef NS_ENUM(NSInteger, DSLIndexViewStyle) {
    DSLIndexViewStyleWave,
    DSLIndexViewStyleFeatureRound
};

@interface DSLIndexView : UIView

/**
 *  索引字颜色  //FIXME
 */
@property (nonatomic, strong, readonly) UIColor *indexColor;

/**
 *  字体大小，默认14，字体越大，索引条越宽
 */
@property (nonatomic, assign) CGFloat fontSize;

/**
 *  索引条建议宽度
 */
@property (nonatomic, assign, readonly) CGFloat fitWidth;

/**
 *  索引条建议高度
 */
@property (nonatomic, assign, readonly) CGFloat fitHeight;

/**
 *  DSLIndexViewStyleFeatureRound风格中的特写view
 */
@property (nonatomic, strong, readonly) DSLIndexFeatureView *featureView;

/**
 *  作为KVO观察者时的回调block
 */
@property (nonatomic, copy) void (^observerBlock)(DSLIndexView *indexView);

/**
 *  便利构造器
 *
 *  @param indexTitles 索引字
 *  @param style       索引条的风格
 *
 *  @return DSLIndexView
 */
+ (instancetype)indexViewWithIndexTitles:(NSArray *)indexTitles style:(DSLIndexViewStyle)style;

/**
 *  选中索引字后触发的block
 *
 *  @param selectBlock block
 */
- (void)didSelectIndexWithCallBack:(DSLIndexViewSelectBlock)selectBlock;

@end
