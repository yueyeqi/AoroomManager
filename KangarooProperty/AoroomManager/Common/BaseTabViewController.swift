//
//  BaseTabViewController.swift
//  KangarooProperty
//
//  Created by YYQ on 16/3/20.
//  Copyright © 2016年 YYQ. All rights reserved.
//

import UIKit

class BaseTabViewController: UITabBarController {

    
    var shareView = CommonShareView()
    var bgBt: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.setBadge), name: NSNotification.Name(rawValue: "badge"), object: nil)
    }
    
    func setBadge(_ nt: Notification) {
        if  ((nt as NSNotification).userInfo != nil) {
            let bar = self.tabBar.items![1]
            let badgeNumber = nt.userInfo?["badge"] as! NSNumber
            if Int(badgeNumber) == 0 {
                bar.badgeValue = nil
            }else {
                let num = Int(badgeNumber)
                bar.badgeValue = "\(num)"
            }
        }else {
            let bar = self.tabBar.items![1]
            if UIApplication.shared.applicationIconBadgeNumber == 0 {
                bar.badgeValue = nil
            }else {
                bar.badgeValue = String(UIApplication.shared.applicationIconBadgeNumber)
            }
        }
    }

}

extension BaseTabViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        //这里我判断的是当前点击的tabBarItem的标题
        if (viewController.tabBarItem.title == "微信分享") {
            showShareView()
            return false
        }else {
            return true
        }
    }
    func showShareView() {
        let yuanfram = self.shareView.frame
        var fram = self.shareView.frame
        fram.origin.y = UIScreen.main.bounds.height
        self.shareView.frame = fram
        self.view.addSubview(self.shareView)
        UIApplication.shared.windows.last?.addSubview(self.shareView)
        UIView.animate(withDuration: 0.5, animations: {
            self.shareView.frame = yuanfram
            }, completion: { (bool) in

        }) 
    }
}
