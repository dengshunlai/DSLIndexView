//
//  DSLIndexFeatureView.m
//  DSLIndexViewDemo
//
//  Created by dengshunlai on 16/1/15.
//  Copyright © 2016年 dengshunlai. All rights reserved.
//

#import "DSLIndexFeatureView.h"

static NSInteger const kIndexFeatureViewStyle = DSLIndexFeatureViewStyleRound;

static CGFloat const kFontSize = 20;

static CGFloat const kTextLabelSize = kFontSize + 5;

@interface DSLIndexFeatureView ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation DSLIndexFeatureView

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

+ (instancetype)indexFeatureViewWithFrame:(CGRect)frame style:(DSLIndexFeatureViewStyle)style
{
    DSLIndexFeatureView *featureView = [[DSLIndexFeatureView alloc] initWithFrame:frame];
    featureView.style = style;
    
    return featureView;
}

- (void)initialization
{
    self.backgroundColor = [UIColor clearColor];
    _style = kIndexFeatureViewStyle;
    _textColor = [UIColor blackColor];
    [self createTextLabel];
}

- (void)drawRect:(CGRect)rect
{
    if (_style == DSLIndexFeatureViewStyleRound) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:248.0/255 green:248.0/255 blue:250.0/255 alpha:1].CGColor);
        CGContextAddEllipseInRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
        CGContextFillPath(context);
        
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:225.0/255 green:225.0/255 blue:225.0/255 alpha:1].CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextAddEllipseInRect(context, CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.height - 4));
        CGContextStrokePath(context);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _textLabel.center = CGPointMake(self.frame.size.width / 2 + 1, self.frame.size.height / 2);
}

- (void)setText:(NSString *)text
{
    _text = text;
    _textLabel.text = _text;
}

- (void)setStyle:(DSLIndexFeatureViewStyle)style
{
    if (_style != style) {
        _style = style;
        [self setNeedsDisplay];
    }
}

- (void)createTextLabel
{
    _textLabel = [[UILabel alloc] init];
    _textLabel.font = [UIFont systemFontOfSize:kFontSize];
    _textLabel.textColor = _textColor;
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.frame = CGRectMake(0, 0, kTextLabelSize, kTextLabelSize);
    
    [self addSubview:_textLabel];
}

@end
