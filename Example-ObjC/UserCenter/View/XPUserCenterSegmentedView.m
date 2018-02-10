//
//  XPUserCenterSegmentedView.m
//  https://github.com/xiaopin/weibo-UserCenter.git
//
//  Created by nhope on 2018/2/9.
//  Copyright © 2018年 nhope. All rights reserved.
//

#import "XPUserCenterSegmentedView.h"

@implementation XPUserCenterSegmentedView
{
    UIStackView *_stackView;
    UIView *_indicatorView;
    __weak UIButton *_selectedButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        // 通过UIStackView来使按钮宽度平分
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_stackView];
        [_stackView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
        [_stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
        [_stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
        [_stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
        // 添加按钮
        NSArray *titles = @[@"主页", @"微博", @"相册"];
        [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [button setTag:idx];
            if (idx == 1) {
                _selectedButton = button;
                button.selected = YES;
            }
            [_stackView addArrangedSubview:button];
        }];
        // 添加底部黑色分割线
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = [UIColor lightGrayColor];
        bottomLine.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:bottomLine];
        [bottomLine.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
        [bottomLine.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
        [bottomLine.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
        [bottomLine.heightAnchor constraintEqualToConstant:0.5].active = YES;
        // 添加选中指示器
        _indicatorView = [[UIView alloc] init];
        _indicatorView.backgroundColor = [UIColor orangeColor];
        _indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_indicatorView];
        [_indicatorView.widthAnchor constraintEqualToConstant:30.0].active = YES;
        [_indicatorView.heightAnchor constraintEqualToConstant:2.0].active = YES;
        [_indicatorView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
        [_indicatorView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    }
    return self;
}


- (void)buttonAction:(UIButton *)sender {
    [self indicatorScrollAnimationWithTargetButton:sender];
    if (nil != self.didClickedButtonHandler) {
        self.didClickedButtonHandler(sender, sender.tag);
    }
}


- (void)setIndicatorLocationAtIndex:(NSInteger)index {
    [_stackView.arrangedSubviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if (idx == index) {
            *stop = YES;
            [self indicatorScrollAnimationWithTargetButton:(UIButton*)obj];
        }
    }];
}

- (void)indicatorScrollAnimationWithTargetButton:(UIButton *)sender {
    if (sender == _selectedButton) { return; }
    _selectedButton.selected = NO;
    sender.selected = YES;
    _selectedButton = sender;
    
    // 更新指示器位置
    for (NSLayoutConstraint *layout in self.constraints) {
        if (layout.firstItem == _indicatorView && layout.firstAttribute == NSLayoutAttributeCenterX) {
            layout.active = NO;
            [self removeConstraint:layout];
            [_indicatorView.centerXAnchor constraintEqualToAnchor:sender.centerXAnchor].active = YES;
            break;
        }
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
}

@end
