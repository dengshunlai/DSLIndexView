//
//  DSLIndexFeatureView.m
//  DSLIndexViewDemo
//
//  Created by dengshunlai on 16/1/15.
//  Copyright © 2016年 dengshunlai. All rights reserved.
//

#import "DSLIndexFeatureView.h"

static NSInteger const kIndexFeatureViewStyle = DSLIndexFeatureViewStyleRound;

static CGFloat const kFontSize = 17;

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
        
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextAddEllipseInRect(context, CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.height - 4));
        CGContextFillPath(context);
        
        CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
        CGContextSetLineWidth(context, 1);
        CGContextAddEllipseInRect(context, CGRectMake(1.5, 1.5, self.frame.size.width - 3, self.frame.size.height - 3));
        CGContextStrokePath(context);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _textLabel.center = self.center;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
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
