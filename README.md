# DSLIndexView
tableView索引条

使用方法：
```
#import "DSLIndexView.h"

_indexView = [DSLIndexView indexViewWithIndexTitles:_indexs];
_indexView.isShowIndexFeature = YES;
__weak typeof(self) weak_self = self;
[_indexView setDidSelectIndexWithCallBack:^(NSInteger index) {
    if (index < weak_self.tableView.numberOfSections) {
        [weak_self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                                   atScrollPosition:UITableViewScrollPositionTop
                                           animated:NO];
    }
}];
[self.view addSubview:_indexView];
_indexView.frame = CGRectMake(...);
```
