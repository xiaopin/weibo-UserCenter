//
//  UserCenterContentProxyViewController.swift
//  Example
//
//  Created by nhope on 2018/2/7.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

import UIKit


/// 使用场景,根据使用场景返回滚动视图的contentInsets
enum UserCenterUseScenes {
    case none // 没有导航栏和TabBar
    case navigationBar // 有导航栏
    case tabBar // 有TabBar
    case navigationBarAndTabBar // 有导航栏和TabBar
}


extension Notification.Name {
    static let userCenterScrollState = Notification.Name("userCenterScrollState")
}


class UserCenterContentProxyViewController: UIViewController {
    
    // MARK: Properties
    
    var isCanContentScroll = false
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Public
    
    func defaultScrollContentInsets(for useScenes: UserCenterUseScenes) -> UIEdgeInsets {
        let width = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        let height = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        let iPhoneX = (width == 375.0 && height == 812.0)
        var insets = UIEdgeInsets.zero
        switch useScenes {
        case .none:
            break
        case .navigationBar:
            insets.bottom =  iPhoneX ? (88.0+34.0) : 64.0
        case .tabBar:
            insets.bottom = iPhoneX ? 83.0 : 49.0
        case .navigationBarAndTabBar:
            insets.bottom = iPhoneX ? (88.0+83.0) : (49.0+64.0)
        }
        return insets
    }
    
    // MARK: 需要子类自行实现以下方法
    
    /// 滚动到顶部
    func scrollToTop() {}

}


// MARK: - UIScrollViewDelegate代理方法,子类如果重写了这些方法,记得调用父类的方法
extension UserCenterContentProxyViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isCanContentScroll {
            scrollView.setContentOffset(.zero, animated: false)
            return
        }
        if scrollView.contentOffset.y <= 0 {
            isCanContentScroll = false
            scrollView.setContentOffset(.zero, animated: false)
            NotificationCenter.default.post(name: .userCenterScrollState, object: nil)
        }
    }
    
}
