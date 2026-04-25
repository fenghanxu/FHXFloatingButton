//
//  FHXViewController.m
//  FHXFloatingButton
//
//  Created by fenghanxu on 04/25/2026.
//  Copyright (c) 2026 fenghanxu. All rights reserved.
//

#import "FHXViewController.h"

#import "FHXFloatingManager.h"

@interface FHXViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableview;

@end

@implementation FHXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    FHXFloatingManager *manager = [FHXFloatingManager shared];
    /// 图片（推荐用 name）
    manager.imageName = @"loginBtn";
    /// 按钮大小
    manager.size = CGSizeMake(85, 85);
    /// 边界限制（替代 top/bottom）
    manager.edgeInset = UIEdgeInsetsMake(100, 10, 100, 10);
    /// 滚动时自动隐藏
    manager.autoHideWhenScroll = YES;
    /// 默认动画时间
    manager.dragAnimationDuration = 0.5;
    /// 拖拽吸边动画时间（透传给按钮）
    manager.moveAnimationDuration = 0.25;
    /// 点击回调
    manager.clickBlock = ^{
        NSLog(@"点击悬浮按钮");
    };

    [manager show];
    
    CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.tableview = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableview];
    self.tableview.delegate = self;
    self.tableview.dataSource =self;
    self.tableview.backgroundColor = [UIColor whiteColor];
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.showsHorizontalScrollIndicator = NO;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.tableFooterView = [[UIView alloc] init];
    self.tableview.rowHeight = 80;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellIdentifier"];
    //为解决tableview  Group的问题
    self.tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.tableview.sectionHeaderHeight = CGFLOAT_MIN;
    self.tableview.sectionFooterHeight = CGFLOAT_MIN;
    //为解决ios11 后tableview刷新跳动的问题
    self.tableview.estimatedRowHeight = 0;
    self.tableview.estimatedSectionHeaderHeight = 0;
    self.tableview.estimatedSectionFooterHeight = 0;

}

#pragma  mark UITableViewDelegate 的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CellIdentifier";
    
    // 从复用池获取cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        // 创建新的cell（使用系统默认样式）
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellID];
    }
    
    // 设置内容
    cell.textLabel.text = [NSString stringWithFormat:@"第 %ld 行", (long)indexPath.row];
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FHXScrollBegin" object:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FHXScrollEnd" object:nil];
}

@end


