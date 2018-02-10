//
//  XPUserCenterHeaderView.h
//  https://github.com/xiaopin/weibo-UserCenter.git
//
//  Created by nhope on 2018/2/9.
//  Copyright © 2018年 nhope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPUserCenterHeaderView : UIView

/// 背景视图
@property (nonatomic, strong, readonly) UIImageView *backgroundImageView;
/// 头像视图
@property (nonatomic, strong, readonly) UIImageView *avatarImageView;
/// 用户名标签
@property (nonatomic, strong, readonly) UILabel *usernameLabel;

@end
