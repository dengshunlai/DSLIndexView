//
//  DSLIndexView.h
//  DSLIndexView
//
//  Created by dengshunlai on 16/1/7.
//  Copyright © 2016年 dengshunlai. All rights reserved.
//

/*********************************************************************************
 *
 * 支持autoLayout，支持xib、storyboard
 *
 * 感谢您的使用！
 *
 *********************************************************************************/

#import <UIKit/UIKit.h>

typedef void (^DSLIndexViewSelectBlock)(NSInteger index);

typedef NS_ENUM(NSInteger, DSLIndexViewStyle) {

    DSLIndexViewStyleWave,
    DSLIndexViewStyleFeatureRound
};

@interface DSLIndexView : UIView

/**
 *  索引字
 */
@property (nonatomic, strong) NSArray *indexTitles;

/**
 *  索引字颜色  //FIXME
 */
@property (nonatomic, strong, readonly) UIColor *indexColor;

/**
 *  索引条的风格
 */
@property (nonatomic, assign) DSLIndexViewStyle style;

/**
 *  字体大小，默认12，字体越大，索引条越宽
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
 *  便利构造器
 *
 *  @param indexTitles 索引字
 *  @param style       索引条的风格
 *
 *  @return DSLIndexView
 */
+ (instancetype)indexViewWithIndexTitles:(NSArray *)indexTitles style:(DSLIndexViewStyle)style;

/**
 *  点击，放手后触发的block
 *
 *  @param selectBlock block
 */
- (void)didSelectIndexWithCallBack:(DSLIndexViewSelectBlock)selectBlock;

@end
