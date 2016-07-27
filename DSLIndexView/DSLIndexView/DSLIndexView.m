//
//  DSLIndexView.m
//  DSLIndexView
//
//  Created by dengshunlai on 16/1/7.
//  Copyright © 2016年 dengshunlai. All rights reserved.
//

#import "DSLIndexView.h"
#import "UILabel+DSLIndexView.h"
#import "DSLIndexFeatureView.h"

static NSInteger const kIndexViewStyle = DSLIndexViewStyleWave;
static CGFloat const kFontSize = 12;
static CGFloat const kLabelWidth = kFontSize + 3;
static CGFloat const kMaxMoveDistance = -45;
static CGFloat const kLeftRightEdge = 8;
static CGFloat const kTopBottomEdge = 8;
static CGFloat const kFeatureRoundSize = 45;
static CGFloat const kFeatureViewDistance = 60;

@interface DSLIndexView ()

@property (nonatomic, strong) NSMutableArray *labels;

@property (nonatomic, assign) CGFloat labelWidth;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger indexCount;
@property (nonatomic, copy) DSLIndexViewSelectBlock selectBlock;
@property (nonatomic, strong) DSLIndexFeatureView *featureView;

@end


@implementation DSLIndexView

#pragma mark - Life cycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

+ (instancetype)indexViewWithIndexTitles:(NSArray *)indexTitles style:(DSLIndexViewStyle)style
{
    DSLIndexView *indexView = [[DSLIndexView alloc] init];
    
    indexView.indexTitles = indexTitles;
    indexView.style = style;
    
    return indexView;
}

- (void)initialization
{
    self.backgroundColor = [UIColor clearColor];
    
    _style = kIndexViewStyle;
    _fontSize = kFontSize;
    _indexColor = [UIColor darkGrayColor];
    _labels = [NSMutableArray array];
    _labelWidth = kLabelWidth;
}

#pragma mark - Set method

- (void)setIndexTitles:(NSArray *)indexTitles
{
    _indexTitles = indexTitles;
    _indexCount = indexTitles.count;
    [self createIndexLabel];
}

- (void)setStyle:(DSLIndexViewStyle)style
{
    _style = style;
    if (_style == DSLIndexViewStyleFeatureRound) {
        
        [self createFeatureView];
    }
    else if (_style == DSLIndexViewStyleWave) {
        
        [_featureView removeFromSuperview];
        _featureView = nil;
    }
}

- (void)setFontSize:(CGFloat)fontSize
{
    if (_fontSize != fontSize) {
        
        _fontSize = fontSize;
        _labelWidth = kFontSize + 3;
    }
}

#pragma mark - Instance method

- (void)didSelectIndexWithCallBack:(DSLIndexViewSelectBlock)selectBlock
{
    self.selectBlock = selectBlock;
}

#pragma mark - Create UI

- (void)createIndexLabel
{
    [_labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * stop) {
        [label removeFromSuperview];
    }];
    [_labels removeAllObjects];
    
    [_indexTitles enumerateObjectsUsingBlock:^(NSString *indexTitle, NSUInteger idx, BOOL * stop) {
        UILabel *label = [[UILabel alloc] init];
        label.text = indexTitle;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = _indexColor;
        label.font = [UIFont systemFontOfSize:_fontSize];
        label.tag = idx;
        [self addSubview:label];
        [_labels addObject:label];
    }];
    
    _fitWidth = _labelWidth + kLeftRightEdge * 2;
    _fitHeight = _labelWidth * _indexTitles.count + kTopBottomEdge * 2;
    
    [_labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * stop) {
        label.frame = CGRectMake(kLeftRightEdge, _labelWidth * idx + kTopBottomEdge, _labelWidth, _labelWidth);
    }];
}

- (void)createFeatureView
{
    DSLIndexFeatureViewStyle featureViewStyle;
    if (_style == DSLIndexViewStyleFeatureRound) {
        
        featureViewStyle = DSLIndexFeatureViewStyleRound;
    }
    _featureView = [DSLIndexFeatureView indexFeatureViewWithFrame:CGRectMake(0, 0, kFeatureRoundSize, kFeatureRoundSize) style:featureViewStyle];
    _featureView.hidden = YES;
    [self addSubview:_featureView];
}

#pragma mark - Touch event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint local = [touch locationInView:self];
    NSInteger index = local.y / _labelWidth;
    
    if (_style == DSLIndexViewStyleWave) {
        [self waveForTouchBeginWithIndex:index];
    } else if (_style == DSLIndexViewStyleFeatureRound) {
        [self featureForTouchBeginWithIndex:index];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint local = [touch locationInView:self];
    NSInteger index = local.y / _labelWidth;
    
    if (_style == DSLIndexViewStyleWave) {
        [self waveForTouchMoveWithIndex:index];
    } else if (_style == DSLIndexViewStyleFeatureRound) {
        [self featureForTouchBeginWithIndex:index];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint local = [touch locationInView:self];
    NSInteger index = local.y / _labelWidth;
    
    if (_style == DSLIndexViewStyleWave) {
        for (NSInteger i = 0; i < _indexCount; i++) {
            [self moveIndex:i toValue:0];
        }
    } else if (_style == DSLIndexViewStyleFeatureRound) {
        _featureView.hidden = YES;
    }
    
    if (self.selectBlock) {
        if (index >= 0 && index < _indexCount) {
            self.selectBlock(index);
        } else if (index < 0) {
            self.selectBlock(0);
        } else if (index >= _indexCount) {
            self.selectBlock(_indexCount - 1);
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    ;
}

#pragma mark - Wave method

- (void)waveForTouchBeginWithIndex:(NSInteger)index
{
    if (index >=0 && index < _indexCount) {
        _index = index;
        [self moveIndex:index toValue:kMaxMoveDistance];
        if (index - 1 >= 0) {
            [self moveIndex:index - 1 toValue:kMaxMoveDistance * 2 / 3];
        }
        if (index - 2 >= 0) {
            [self moveIndex:index - 2 toValue:kMaxMoveDistance / 3];
        }
        if (index + 1 < _indexCount) {
            [self moveIndex:index + 1 toValue:kMaxMoveDistance * 2 / 3];
        }
        if (index + 2 < _indexCount) {
            [self moveIndex:index + 2 toValue:kMaxMoveDistance / 3];
        }
    }
}

- (void)waveForTouchMoveWithIndex:(NSInteger)index
{
    if (index >=0 && index < _indexCount && _index != index) {
        if (index < _index) { //上移
            [self moveIndex:index toValue:kMaxMoveDistance];
            if (index - 1 >= 0) {
                [self moveIndex:index - 1 toValue:kMaxMoveDistance * 2 / 3];
            }
            if (index - 2 >= 0) {
                [self moveIndex:index - 2 toValue:kMaxMoveDistance / 3];
            }
            if (index + 1 < _indexCount) {
                [self moveIndex:index + 1 toValue:kMaxMoveDistance * 2 / 3];
            }
            if (index + 2 < _indexCount) {
                [self moveIndex:index + 2 toValue:kMaxMoveDistance / 3];
            }
            if (index + 3 < _indexCount) {
                [self moveIndex:index + 3 toValue:0];
            }
            for (NSInteger i = 0; i < index - 2; i++) {
                [self moveIndex:i toValue:0];
            }
            for (NSInteger i = _indexCount - 1; i > index + 3; i--) {
                [self moveIndex:i toValue:0];
            }
        }
        if (index > _index) { //下移
            [self moveIndex:index toValue:kMaxMoveDistance];
            if (index + 1 < _indexCount) {
                [self moveIndex:index + 1 toValue:kMaxMoveDistance * 2 / 3];
            }
            if (index + 2 < _indexCount) {
                [self moveIndex:index + 2 toValue:kMaxMoveDistance / 3];
            }
            if (index - 1 >= 0) {
                [self moveIndex:index - 1 toValue:kMaxMoveDistance * 2 / 3];
            }
            if (index - 2 >= 0) {
                [self moveIndex:index - 2 toValue:kMaxMoveDistance / 3];
            }
            if (index - 3 >= 0) {
                [self moveIndex:index - 3 toValue:0];
            }
            for (NSInteger i = 0; i < index - 3; i++) {
                [self moveIndex:i toValue:0];
            }
            for (NSInteger i = _indexCount - 1; i > index + 2; i--) {
                [self moveIndex:i toValue:0];
            }
        }
        _index = index;
    }
}

#pragma mark - Move

- (void)moveIndex:(NSInteger)index toValue:(CGFloat)toValue
{
    UILabel *label = _labels[index];
    
    CABasicAnimation *translation = [CABasicAnimation animation];
    translation.keyPath = @"transform.translation.x";
    translation.fromValue = @(label.dsl_fromValue);
    translation.toValue = @(toValue);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[translation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.duration = 0.3;
    
    [label.layer addAnimation:group forKey:@"label"];
    
    label.dsl_fromValue = toValue;
    
    if (toValue == kMaxMoveDistance) {
        label.textColor = [UIColor blackColor];
    } else if (toValue == kMaxMoveDistance * 2 / 3) {
        label.textColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3];
    } else if (toValue == kMaxMoveDistance / 3) {
        label.textColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.7];
    } else if (toValue == 0) {
        label.textColor = [UIColor darkGrayColor];
    }
}

#pragma mark - Feature method

- (void)featureForTouchBeginWithIndex:(NSInteger)index
{
    if (index < 0 || index >= 26) {
        return;
    }
    _featureView.hidden = YES;
    
    UILabel *label = _labels[index];
    CGPoint center = label.center;
    center.x = center.x - kFeatureViewDistance;
    _featureView.center = center;
    _featureView.text = _indexTitles[index];
    
    _featureView.hidden = NO;
}

@end
