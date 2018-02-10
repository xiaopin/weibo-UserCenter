//
//  XPWeiboViewController.m
//  Example-ObjC
//
//  Created by nhope on 2018/2/10.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

#import "XPWeiboViewController.h"
#import "MJRefresh.h"

@interface XPWeiboViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;

@end

@implementation XPWeiboViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _page = 1;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.rowHeight = 80.0;
    _tableView.tableFooterView = [UIView new];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.contentInset = [self defaultScrollContentInsetsForUseScenes:XPUserCenterUseScenesNavigationBar];
    [self.view addSubview:_tableView];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [_tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [_tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [_tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [_tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    
    // 上拉刷新
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshAction)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _page * 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSString *title = [NSString stringWithFormat:@"微博-%ld", indexPath.row];
    cell.textLabel.text = title;
    return cell;
}

#pragma mark - <UITableViewDelegate>


#pragma mark - Override

- (void)scrollToTop {
    [self.tableView setContentOffset:CGPointZero];
}

- (void)beginHeaderRefresh {
#warning Send network request.
    // 模拟发送网络
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 停止下拉刷新动画,目前只能通过发通知来结束下拉刷新的动画
        [[NSNotificationCenter defaultCenter] postNotificationName:XPUserCenterEndHeaderRefreshNotification object:nil];
    });
}

#pragma mark - Action

- (void)footerRefreshAction {
    __weak __typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.page++;
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView reloadData];
    });
}

@end
