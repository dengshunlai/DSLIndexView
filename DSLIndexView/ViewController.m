//
//  ViewController.m
//  DSLIndexView
//
//  Created by 邓顺来 on 16/7/24.
//  Copyright © 2016年 邓顺来. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+DSLIndexView.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *indexs;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _indexs = @[].mutableCopy;
    for (int i = 0; i < 26; i++) {
        char c = 'a' + i;
        char str[2] = {c,'\0'};
        NSString *string = [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
        [_indexs addObject:string];
    }
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(360, 0, 15, 603)];
//    view.backgroundColor = [UIColor redColor];
//    [_tableView addSubview:view];
    
//    [self addObserver:self forKeyPath:@"tableView.contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"tableView.bounds" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionPrior context:nil];
    
    //显示索引条
//    [_tableView dsl_setupIndexViewWithIndexs:_indexs style:DSLIndexViewStyleWave];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self test];
//    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"tableView.contentOffset"]) {
        NSLog(@"%@",NSStringFromCGPoint(_tableView.contentOffset));
    } else if ([keyPath isEqualToString:@"tableView.bounds"]) {
        NSLog(@"%@",NSStringFromCGRect(_tableView.bounds));
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test
{
    for (UIView *view in _tableView.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITableViewIndex")]) {
            NSLog(@"%@",view);
            NSLog(@"%@",view.superview);
            NSLog(@"%@",view.constraints);
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 26;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UITableViewCell new];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _indexs;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)displayCell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _indexs[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

@end
