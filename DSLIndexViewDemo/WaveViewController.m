//
//  WaveViewController.m
//  DSLIndexView
//
//  Created by 邓顺来 on 16/10/19.
//  Copyright © 2016年 邓顺来. All rights reserved.
//

#import "WaveViewController.h"
#import "UITableView+DSLIndexView.h"

@interface WaveViewController () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *indexs;

@end

@implementation WaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _indexs = @[].mutableCopy;
    for (int i = 0; i < 26; i++) {
        char c = 'a' + i;
        char str[2] = {c,'\0'};
        NSString *string = [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
        [_indexs addObject:string];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               [UIScreen mainScreen].bounds.size.width,
                                                               [UIScreen mainScreen].bounds.size.height)
                                              style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    //安装索引条
    [_tableView dsl_setupIndexViewWithIndexs:_indexs];
    
    //设置字体大小
    //[_tableView dsl_setIndexFontSize:10];
    
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
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
    return 68;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

@end