//
//  DSLIndexView.m
//  DSLIndexView
//
//  Created by dengshunlai on 16/1/7.
//  Copyright © 2016年 dengshunlai. All rights reserved.
//

#import "DSLIndexView.h"
#import "UILabel+DSLIndexView.h"

static CGFloat const kFontSize = 14;
static CGFloat const kLabelWidth = kFontSize + 3;
static CGFloat const kMaxMoveDistance = -55;
static CGFloat const kLeftRightEdge = 3;
static CGFloat const kAnimationDuration = 0.1;
static CGFloat const kFeatureViewSize = 55;

@interface DSLIndexView ()

@property (nonatomic, strong) NSMutableArray *labels;
@property (nonatomic, strong) UIColor *indexColor;
@property (nonatomic, assign) CGFloat labelWidth;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger indexCount;
@property (nonatomic, copy) DSLIndexViewSelectBlock selectBlock;

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

+ (instancetype)indexViewWithIndexTitles:(NSArray *)indexTitles
{
    DSLIndexView *indexView = [[DSLIndexView alloc] init];
    indexView.indexTitles = indexTitles;
    return indexView;
}

- (void)initialization {
    self.backgroundColor = [UIColor clearColor];
    
    _isShowIndexFeature = NO;
    _fontSize = kFontSize;
    _indexColor = [UIColor darkGrayColor];
    _labels = [NSMutableArray array];
    _labelWidth = kLabelWidth;
    _index = -1;
    [self createFeatureView];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}

- (void)dealloc {
    [_featureView removeFromSuperview];
    _featureView = nil;
    NSLog(@"%s",__func__);
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(_fitWidth, _fitHeight);
}

#pragma mark - Set method

- (void)setIndexTitles:(NSArray *)indexTitles {
    _indexTitles = indexTitles;
    _indexCount = indexTitles.count;
    [self createIndexLabel];
    [self invalidateIntrinsicContentSize];
}

- (void)setFontSize:(CGFloat)fontSize {
    if (_fontSize != fontSize) {
        _fontSize = fontSize;
        _labelWidth = fontSize + 3;
        _fitWidth = _labelWidth + kLeftRightEdge * 2;
        _fitHeight = _labelWidth * _indexTitles.count;
        [_labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * stop) {
            label.font = [UIFont systemFontOfSize:_fontSize];
            label.frame = CGRectMake(kLeftRightEdge, _labelWidth * idx, _labelWidth, _labelWidth);
        }];
        [self invalidateIntrinsicContentSize];
    }
}

#pragma mark - Instance method

- (void)setDidSelectIndexWithCallBack:(DSLIndexViewSelectBlock)selectBlock {
    self.selectBlock = selectBlock;
}

#pragma mark - Create UI

- (void)createIndexLabel {
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
    _fitHeight = _labelWidth * _indexTitles.count;
    
    [_labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * stop) {
        label.frame = CGRectMake(kLeftRightEdge, _labelWidth * idx, _labelWidth, _labelWidth);
    }];
}

- (void)createFeatureView {
    _featureView = [DSLIndexFeatureView indexFeatureViewWithFrame:CGRectZero style:DSLIndexFeatureViewStyleRound];
    _featureView.hidden = YES;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_featureView];
    _featureView.frame = CGRectMake(0, 0, kFeatureViewSize, kFeatureViewSize);
    _featureView.center = CGPointMake(CGRectGetWidth(window.frame) / 2, CGRectGetHeight(window.frame) / 2);
}

#pragma mark - Touch event & PanGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint local = [touch locationInView:self];
    NSInteger index = local.y / _labelWidth;
    if (index < 0) {
        index = 0;
    } else if (index >= _indexCount) {
        index = _indexCount - 1;
    }
    
    [self waveForTouchBeginWithIndex:index];
    if (_isShowIndexFeature) {
        [self featureForTouchBeginWithIndex:index];
    }
    [self didSelectIndex:index];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self resetAllIndexLabel];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self resetAllIndexLabel];
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    CGPoint local = [pan locationInView:self];
    NSInteger index = local.y / _labelWidth;
    if (index < 0) {
        index = 0;
    } else if (index >= _indexCount) {
        index = _indexCount - 1;
    }
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            if (index != _index) {
                [self waveForTouchMoveWithIndex:index];
                if (_isShowIndexFeature) {
                    [self featureForTouchBeginWithIndex:index];
                }
                [self didSelectIndex:index];
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            [self resetAllIndexLabel];
        }
            break;
        case UIGestureRecognizerStateCancelled: {
            [self resetAllIndexLabel];
        }
            break;
        default:
            break;
    }
}

- (void)resetAllIndexLabel {
    for (NSInteger i = 0; i < _indexCount; i++) {
        [self moveIndex:i toValue:0];
    }
    _featureView.hidden = YES;
    _index = -1;
}

- (void)didSelectIndex:(NSInteger)index {
    if (self.selectBlock) {
        self.selectBlock(index);
    }
    _index = index;
}

#pragma mark - Wave method

- (void)waveForTouchBeginWithIndex:(NSInteger)index {
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

- (void)waveForTouchMoveWithIndex:(NSInteger)index {
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
}

#pragma mark - Move Animation

- (void)moveIndex:(NSInteger)index toValue:(CGFloat)toValue {
    UILabel *label = _labels[index];
    
    CABasicAnimation *translation = [CABasicAnimation animation];
    translation.keyPath = @"transform.translation.x";
    translation.fromValue = @(label.dsl_fromValue);
    translation.toValue = @(toValue);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[translation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.duration = kAnimationDuration;// * (-kMaxMoveDistance - label.dsl_fromValue) / (-kMaxMoveDistance);
    
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

- (void)featureForTouchBeginWithIndex:(NSInteger)index {
    if (index < 0 || index >= _indexCount) {
        return;
    }
    _featureView.text = _indexTitles[index];
    _featureView.hidden = NO;
}

@end
