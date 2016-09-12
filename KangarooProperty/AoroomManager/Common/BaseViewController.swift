//
//  BaseViewController.swift
//  KangarooProperty
//
//  Created by YYQ on 16/3/20.
//  Copyright © 2016年 YYQ. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setLeftButtonImage(UIImage(named: "back"))
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.translucent = false
        self.tabBarController?.tabBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(rgba: "#F6F6F6")
        self.tabBarController?.tabBar.barTintColor = UIColor(rgba: "#F6F6F6")
        self.tabBarController?.tabBar.tintColor = UIColor.blackColor()
        let navigationTitleAttribute: NSDictionary = NSDictionary(object: UIColor.blackColor(), forKey: NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
//        UINavigationBar.appearance().translucent = false
//        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    func setLeftButtonImage(leftImge: UIImage?) {
        
        if leftImge == nil {
            self.navigationItem.leftBarButtonItem = nil
            return
        }
        
        var leftBarButtonItem = UIBarButtonItem()
        let leftButton = UIButton(type: .Custom)
        leftButton.frame = CGRectMake(0, 0, (leftImge?.size.width)!, (leftImge?.size.height)!)
        leftButton.setImage(leftImge, forState: .Normal)
        leftButton.addTarget(self, action: #selector(BaseViewController.leftBtnClick), forControlEvents: .TouchUpInside)
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0)
        leftButton.setImage(leftImge, forState: .Highlighted)
        leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }

    func leftBtnClick() {
        self.navigationController!.popViewControllerAnimated(true)
    }

}
