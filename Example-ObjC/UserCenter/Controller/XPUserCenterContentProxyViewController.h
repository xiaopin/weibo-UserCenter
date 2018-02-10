//
//  XPUserCenterContentViewController.h
//  https://github.com/xiaopin/weibo-UserCenter.git
//
//  Created by nhope on 2018/2/9.
//  Copyright © 2018年 nhope. All rights reserved.
//

#import <UIKit/UIKit.h>


/// 使用场景,根据使用场景返回滚动视图的contentInsets
typedef NS_ENUM(NSInteger, XPUserCenterUseScenes) {
    XPUserCenterUseScenesNone                       =   0, // 没有导航栏和TabBar
    XPUserCenterUseScenesNavigationBar              =   1, // 有导航栏
    XPUserCenterUseScenesTabBar                     =   2, // 有TabBar
    XPUserCenterUseScenesNavigationBarAndTabBar     =   3, // 有导航栏和TabBar
};


UIKIT_EXTERN NSString * const XPUserCenterScrollStateNotification;
/// 停止下拉刷新动画的通知
UIKIT_EXTERN NSString * const XPUserCenterEndHeaderRefreshNotification;



@interface XPUserCenterContentProxyViewController : UIViewController <UIScrollViewDelegate>

/// 内容是否可以滚动
@property (nonatomic, assign, getter=isCanContentScroll) BOOL canContentScroll;


/// 子类需要设置滚动视图的偏移量
- (UIEdgeInsets)defaultScrollContentInsetsForUseScenes:(XPUserCenterUseScenes)scenes;


//////////////////////////////
////    请子类重写以下方法   ////
/////////////////////////////

/// 滚动到顶部(请子类自行实现滚动到顶部的功能)
- (void)scrollToTop;
/// 下拉刷新,可以重新请求数据,可以通过发送一个通知来结束刷新动画
- (void)beginHeaderRefresh;


//////////////////////////////////////////
////    UIScrollViewDelegate代理方法   ////
////    子类需要调用父类的方法           ////
/////////////////////////////////////////

- (void)scrollViewDidScroll:(UIScrollView *)scrollView NS_REQUIRES_SUPER;

@end
