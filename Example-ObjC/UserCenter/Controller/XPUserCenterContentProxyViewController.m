//
//  XPUserCenterContentViewController.m
//  https://github.com/xiaopin/weibo-UserCenter.git
//
//  Created by nhope on 2018/2/9.
//  Copyright © 2018年 nhope. All rights reserved.
//

#import "XPUserCenterContentProxyViewController.h"


NSString * const XPUserCenterScrollStateNotification = @"XPUserCenterScrollStateNotification";
NSString * const XPUserCenterEndHeaderRefreshNotification = @"XPUserCenterEndHeaderRefreshNotification";


@implementation XPUserCenterContentProxyViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isCanContentScroll) {
        [scrollView setContentOffset:CGPointZero];
        return;
    }
    if (scrollView.contentOffset.y <= 0) {
        _canContentScroll = NO;
        [scrollView setContentOffset:CGPointZero];
        [[NSNotificationCenter defaultCenter] postNotificationName:XPUserCenterScrollStateNotification object:nil];
    }
}

#pragma mark - Public

- (void)scrollToTop {
    // do nothing.
}

- (void)beginHeaderRefresh {
    // 停止下拉刷新动画,目前只能通过发通知来结束下拉刷新的动画
    [[NSNotificationCenter defaultCenter] postNotificationName:XPUserCenterEndHeaderRefreshNotification object:nil];
}

- (UIEdgeInsets)defaultScrollContentInsetsForUseScenes:(XPUserCenterUseScenes)scenes {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat width = MIN(screenSize.width, screenSize.height);
    CGFloat height = MAX(screenSize.width, screenSize.height);
    BOOL iPhoneX = (width == 375.0 && height == 812.0);
    UIEdgeInsets insets = UIEdgeInsetsZero;
    switch (scenes) {
        case XPUserCenterUseScenesNone:
            break;
        case XPUserCenterUseScenesNavigationBar:
            insets.bottom = iPhoneX ? (88.0+34.0) : 64.0;
            break;
        case XPUserCenterUseScenesTabBar:
            insets.bottom = iPhoneX ? 83.0 : 49.0;
            break;
        case XPUserCenterUseScenesNavigationBarAndTabBar:
            insets.bottom = iPhoneX ? (88.0+83.0) : (49.0+64.0);
            break;
    }
    return insets;
}

@end
