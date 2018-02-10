//
//  XPUserCenterScrollView.m
//  https://github.com/xiaopin/weibo-UserCenter.git
//
//  Created by nhope on 2018/2/9.
//  Copyright © 2018年 nhope. All rights reserved.
//

#import "XPUserCenterScrollView.h"

@implementation XPUserCenterScrollView

/// 允许同时识别多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
