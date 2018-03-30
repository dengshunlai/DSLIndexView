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

@interface DSLIndexView : UIView

/**
 *  索引字
 */
@property (nonatomic, strong) NSArray *indexTitles;

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
 *  是否显示索引的特写，默认NO
 */
@property (nonatomic, assign) BOOL isShowIndexFeature;

/**
 *  特写的View
 */
@property (nonatomic, strong, readonly) DSLIndexFeatureView *featureView;

/**
 *  便利构造器
 *
 *  @param indexTitles 索引字
 *
 *  @return DSLIndexView
 */
+ (instancetype)indexViewWithIndexTitles:(NSArray *)indexTitles;

/**
 *  选中索引字后触发的block
 *
 *  @param selectBlock block
 */
- (void)setDidSelectIndexWithCallBack:(DSLIndexViewSelectBlock)selectBlock;

@end
