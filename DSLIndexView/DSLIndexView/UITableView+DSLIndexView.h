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

- (void)dsl_setupIndexViewWithIndexs:(NSArray *)indexs;

- (void)dsl_setupIndexViewWithIndexs:(NSArray *)indexs style:(DSLIndexViewStyle)style;

@end

@interface UIViewController (DSLIndexView)

@end
