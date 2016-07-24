//
//  DSLIndexFeatureView.h
//  DSLIndexViewDemo
//
//  Created by dengshunlai on 16/1/15.
//  Copyright © 2016年 dengshunlai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DSLIndexFeatureViewStyle) {

    DSLIndexFeatureViewStyleRound
};

@interface DSLIndexFeatureView : UIView

/**
 *  文本
 */
@property (nonatomic, strong) NSString *text;

/**
 *  文本颜色
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 *  特写风格
 */
@property (nonatomic, assign) DSLIndexFeatureViewStyle style;

/**
 *  便利构造器
 *
 *  @param frame 大小
 *  @param style 风格
 *
 *  @return DSLIndexFeatureView
 */
+ (instancetype)indexFeatureViewWithFrame:(CGRect)frame style:(DSLIndexFeatureViewStyle)style;

@end
