//
//  UserCenterSegmentedView.swift
//  https://github.com/xiaopin/weibo-UserCenter.git
//
//  Created by nhope on 2018/2/6.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

import UIKit

class UserCenterSegmentedView: UIView {
    
    // MARK: Properties
    
    /// 按钮点击事件回调
    var didTappedButtonHandler: ((_ button: UIButton, _ index: Int) -> Void)?
    
    /// 用于按钮平分宽度
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    /// 底部分割线
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    /// 活动指示器
    private let indicator: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        return view
    }()
    
    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        ([stackView, separator, indicator]).forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        separator.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 2.0).isActive = true
        indicator.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        ["主页", "微博", "相册"].forEach { (title) in
            let button = UIButton(type: .custom)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.lightGray, for: .normal)
            button.setTitleColor(.black, for: .selected)
            button.tag = self.stackView.arrangedSubviews.count
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            if button.tag == 1 {
                button.isSelected = true
            }
            self.stackView.addArrangedSubview(button)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Actions
    
    @objc private func buttonAction(_ sender: UIButton) {
        indicatorScrollAnimation(sender)
        didTappedButtonHandler?(sender, sender.tag)
    }
    
    // MARK: Public
    
    /// 设置指示器位置
    func setIndicatorLocation(at index: Int) {
        for (idx, view) in stackView.arrangedSubviews.enumerated() {
            if idx == index {
                guard let button = view as? UIButton else { return }
                indicatorScrollAnimation(button)
            }
        }
    }
    
    // MARK: Private
    
    /// 指示器滚动动画
    private func indicatorScrollAnimation(_ button: UIButton) {
        // 切换选中按钮状态
        guard let buttons = stackView.arrangedSubviews as? [UIButton] else { return }
        buttons.forEach { $0.isSelected = false }
        button.isSelected = true
        // 更新指示器位置
        for layout in constraints {
            guard let firstItemView = layout.firstItem as? UIView else { continue }
            if firstItemView == indicator && layout.firstAttribute == .centerX {
                layout.isActive = false
                removeConstraint(layout)
                indicator.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
                break
            }
        }
        // 开启动画
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
}
