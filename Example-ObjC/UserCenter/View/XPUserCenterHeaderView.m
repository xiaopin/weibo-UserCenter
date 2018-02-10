//
//  XPUserCenterHeaderView.m
//  https://github.com/xiaopin/weibo-UserCenter.git
//
//  Created by nhope on 2018/2/9.
//  Copyright © 2018年 nhope. All rights reserved.
//

#import "XPUserCenterHeaderView.h"

#define kAvatarWidthAndHeight   72.0

@implementation XPUserCenterHeaderView

@synthesize backgroundImageView = _backgroundImageView;
@synthesize avatarImageView = _avatarImageView;
@synthesize usernameLabel = _usernameLabel;


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_backgroundImageView];
        [_backgroundImageView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        [_backgroundImageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
        [_backgroundImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
        [_backgroundImageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
        
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _avatarImageView.layer.cornerRadius = kAvatarWidthAndHeight / 2;
        _avatarImageView.layer.masksToBounds = YES;
        [self addSubview:_avatarImageView];
        [_avatarImageView.widthAnchor constraintEqualToConstant:kAvatarWidthAndHeight].active = YES;
        [_avatarImageView.heightAnchor constraintEqualToConstant:kAvatarWidthAndHeight].active = YES;
        [_avatarImageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        [_avatarImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
        
        _usernameLabel = [[UILabel alloc] init];
        _usernameLabel.textColor = [UIColor colorWithRed:17/255.0 green:17/255.0 blue:17/255.0 alpha:1.0];
        _usernameLabel.textAlignment = NSTextAlignmentCenter;
        _usernameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_usernameLabel];
        [_usernameLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        [_usernameLabel.topAnchor constraintEqualToAnchor:_avatarImageView.bottomAnchor constant:20.0].active = YES;
    }
    return self;
}

@end
