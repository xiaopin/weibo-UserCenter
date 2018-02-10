//
//  XPUserCenterSegmentedView.h
//  https://github.com/xiaopin/weibo-UserCenter.git
//
//  Created by nhope on 2018/2/9.
//  Copyright © 2018年 nhope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPUserCenterSegmentedView : UIView

/// 按钮点击回调事件(请勿修改button的tag属性)
@property (nonatomic, copy) void(^didClickedButtonHandler)(UIButton *button, NSInteger index);

/// 设置指示器的位置
- (void)setIndicatorLocationAtIndex:(NSInteger)index;

@end
