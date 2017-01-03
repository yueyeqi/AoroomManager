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
        // Do any additional setup after loading the view.
        self.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.setBadge), name: "badge", object: nil)
    }
    
    func setBadge(nt: NSNotification) {
        if  (nt.userInfo != nil) {
            let bar = self.tabBar.items![1]
            if String(nt.userInfo!["aps"]!["badge"]) == "0" {
                bar.badgeValue = nil
            }else {
                let badge: [NSObject: AnyObject] = nt.userInfo!["aps"] as! [NSObject: AnyObject]
                let num = badge["badge"]
                bar.badgeValue = "\(num!)"
            }
        }else {
            let bar = self.tabBar.items![1]
            if UIApplication.sharedApplication().applicationIconBadgeNumber == 0 {
                bar.badgeValue = nil
            }else {
                bar.badgeValue = String(UIApplication.sharedApplication().applicationIconBadgeNumber)
            }
        }
    }

}

extension BaseTabViewController: UITabBarControllerDelegate {
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {

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
        fram.origin.y = UIScreen.mainScreen().bounds.height
        self.shareView.frame = fram
        self.view.addSubview(self.shareView)
        UIApplication.sharedApplication().windows.last?.addSubview(self.shareView)
        UIView.animateWithDuration(0.5, animations: {
            self.shareView.frame = yuanfram
            }) { (bool) in
//                self.createBgBt()
        }
    }
    
//    func createBgBt() -> Void {
//        let sWidth = UIScreen.mainScreen().bounds.size.width
//        let sHeight = UIScreen.mainScreen().bounds.size.height
//    
//        bgBt = UIButton.init(frame: CGRectMake(0, 0, sWidth, sHeight - self.shareView.frame.size.height))
//        bgBt?.backgroundColor = UIColor.blackColor()
//        bgBt?.alpha = 0.5
//        bgBt?.addTarget(self, action: #selector(BaseTabViewController.cancelBtPressed), forControlEvents: UIControlEvents.TouchUpInside)
//        UIApplication.sharedApplication().windows.last?.addSubview(bgBt!)
//    }
//    
//    func cancelBtPressed()
//    {
//        self.bgBt?.removeFromSuperview()
//        UIView.animateWithDuration(0.5, animations: { 
//            var fram = self.shareView.frame
//            fram.origin.y = UIScreen.mainScreen().bounds.height
//            self.shareView.frame = fram
//            }) { (bool) in
//                
//        }
//    }

}
