//
//  XPUserCenterViewController.m
//  https://github.com/xiaopin/weibo-UserCenter.git
//
//  Created by nhope on 2018/2/9.
//  Copyright © 2018年 nhope. All rights reserved.
//

#import "XPUserCenterViewController.h"
#import "XPUserCenterContentProxyViewController.h"
#import "XPUserCenterHeaderView.h"
#import "XPUserCenterSegmentedView.h"
#import "XPUserCenterScrollView.h"
#import "MJRefresh.h"

#warning 测试代码,请导入项目中实际的控制器头文件
#import "XPHomeViewController.h"
#import "XPWeiboViewController.h"
#import "XPAlbumViewController.h"



@interface XPUserCenterViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

/// 背景滚动视图容器
@property (nonatomic, strong) XPUserCenterScrollView *scrollView;
/// 头部视图
@property (nonatomic, strong) XPUserCenterHeaderView *headerView;
/// 分段按钮视图
@property (nonatomic, strong) XPUserCenterSegmentedView *segmentedView;
/// 用于切换要显示的控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;
/// 分段按钮对应的控制器
@property (nonatomic, strong) NSArray<XPUserCenterContentProxyViewController *> *viewControllers;
/// 标记`scrollView`是否可以滚动
@property (nonatomic, assign) BOOL canContentContainerScroll;

@end

@implementation XPUserCenterViewController

static CGFloat const kHeaderViewHeight      =   200.0;
static CGFloat const kSegmentedViewHeight   =   40.0;

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    _canContentContainerScroll = YES;
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:XPUserCenterScrollStateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endHeaderRefreshNotification:) name:XPUserCenterEndHeaderRefreshNotification object:nil];
    
#warning 这是测试代码
    _headerView.backgroundImageView.image = [UIImage imageNamed:@"profile_cover_background"];
    _headerView.avatarImageView.image = [UIImage imageNamed:@"icon-MV_Smile"];
    _headerView.usernameLabel.text = @"微博小账号";
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UIPageViewControllerDataSource>

/// 返回当前页面的上一个页面
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [_viewControllers indexOfObject:(XPUserCenterContentProxyViewController*)viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    return [_viewControllers objectAtIndex:(index-1)];
}

/// 返回当前页面的下一个页面
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [_viewControllers indexOfObject:(XPUserCenterContentProxyViewController*)viewController];
    if (index < _viewControllers.count-1) {
        return [_viewControllers objectAtIndex:(index+1)];
    }
    return nil;
}

#pragma mark - <UIPageViewControllerDelegate>

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    XPUserCenterContentProxyViewController *vc = (XPUserCenterContentProxyViewController*)_pageViewController.viewControllers.lastObject;
    NSInteger index = [_viewControllers indexOfObject:vc];
    if (index >= 0 && index != NSNotFound) {
        [_segmentedView setIndicatorLocationAtIndex:index];
    }
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
    CGFloat navigationBarHeight = navigationBarFrame.origin.y + navigationBarFrame.size.height;
    CGFloat offsetThreshold = kHeaderViewHeight - navigationBarHeight;
    if (scrollView.contentOffset.y >= offsetThreshold) {
        [scrollView setContentOffset:CGPointMake(0.0, offsetThreshold)];
        _canContentContainerScroll = NO;
        // 子视图可以滚动了
        for (XPUserCenterContentProxyViewController *vc in _viewControllers) {
            vc.canContentScroll = YES;
        }
    } else {
        if (!_canContentContainerScroll) {
            [scrollView setContentOffset:CGPointMake(0.0, offsetThreshold)];
        }
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    for (XPUserCenterContentProxyViewController *vc in _viewControllers) {
        [vc scrollToTop];
    }
    return YES;
}

#pragma mark - Actions

- (void)notificationAction:(NSNotification *)sender {
    _canContentContainerScroll = YES;
    for (XPUserCenterContentProxyViewController *vc in _viewControllers) {
        vc.canContentScroll = NO;
        [vc scrollToTop];
    }
}

- (void)endHeaderRefreshNotification:(NSNotification *)sender {
    if ([_scrollView.mj_header isRefreshing]) {
        [_scrollView.mj_header endRefreshing];
    }
}

- (void)headerRefreshAction {
    XPUserCenterContentProxyViewController *vc = (XPUserCenterContentProxyViewController *)_pageViewController.viewControllers.lastObject;
    [vc beginHeaderRefresh];
}

#pragma mark - Private

- (void)setupUI {
    _scrollView = [[XPUserCenterScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_scrollView];
    [_scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [_scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [_scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [_scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [_scrollView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [_scrollView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor].active = YES;
    // 集成下拉刷新
    _scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction)];
    
    _headerView = [[XPUserCenterHeaderView alloc] init];
    _headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_headerView];
    [_headerView.topAnchor constraintEqualToAnchor:_scrollView.topAnchor].active = YES;
    [_headerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [_headerView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [_headerView.heightAnchor constraintEqualToConstant:kHeaderViewHeight].active = YES;
    
    _segmentedView = [[XPUserCenterSegmentedView alloc] init];
    _segmentedView.translatesAutoresizingMaskIntoConstraints = NO;
    __weak __typeof(self) weakSelf = self;
    [_segmentedView setDidClickedButtonHandler:^(UIButton *button, NSInteger index) {
        [weakSelf showChildViewControllerAtIndex:index];
    }];
    [_scrollView addSubview:_segmentedView];
    [_segmentedView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor];
    [_segmentedView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [_segmentedView.heightAnchor constraintEqualToConstant:kSegmentedViewHeight].active = YES;
    [_segmentedView.topAnchor constraintEqualToAnchor:_headerView.bottomAnchor].active = YES;
    
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey: @(10.0)}];
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    [self addChildViewController:_pageViewController];
    [self.scrollView addSubview:_pageViewController.view];
    _pageViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [_pageViewController.view.topAnchor constraintEqualToAnchor:_segmentedView.bottomAnchor].active = YES;
    [_pageViewController.view.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [_pageViewController.view.heightAnchor constraintEqualToAnchor:self.view.heightAnchor constant:-kSegmentedViewHeight].active = YES;
    [_pageViewController.view.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [_pageViewController.view.bottomAnchor constraintEqualToAnchor:_scrollView.bottomAnchor].active = YES;
    [_pageViewController didMoveToParentViewController:self];
    [self showChildViewControllerAtIndex:1];
}

- (void)showChildViewControllerAtIndex:(NSInteger)index {
    if (index >= self.viewControllers.count) {
        return;
    }
    XPUserCenterContentProxyViewController *currentVC = (XPUserCenterContentProxyViewController *)self.pageViewController.viewControllers.lastObject;
    NSInteger currentIndex = [self.viewControllers indexOfObject:currentVC];
    UIViewController *toVC = [self.viewControllers objectAtIndex:index];
    UIPageViewControllerNavigationDirection direction = (currentIndex > index) ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward;
    [self.pageViewController setViewControllers:@[toVC] direction:direction animated:YES completion:nil];
}

- (NSArray<XPUserCenterContentProxyViewController *> *)viewControllers {
    if (nil == _viewControllers) {
#warning 测试代码,请返回项目实际的控制器
        _viewControllers = @[
                             [XPHomeViewController new],
                             [XPWeiboViewController new],
                             [XPAlbumViewController new],
                             ];
    }
    return _viewControllers;
}

@end
