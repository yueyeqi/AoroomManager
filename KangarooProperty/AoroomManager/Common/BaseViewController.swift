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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBarController?.tabBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(rgba: "#F6F6F6")
        self.tabBarController?.tabBar.barTintColor = UIColor(rgba: "#F6F6F6")
        self.tabBarController?.tabBar.tintColor = UIColor.black
        let navigationTitleAttribute: NSDictionary = NSDictionary(object: UIColor.black, forKey: NSForegroundColorAttributeName as NSCopying)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
    }
    
    func setLeftButtonImage(_ leftImge: UIImage?) {
        
        if leftImge == nil {
            self.navigationItem.leftBarButtonItem = nil
            return
        }
        
        var leftBarButtonItem = UIBarButtonItem()
        let leftButton = UIButton(type: .custom)
        leftButton.frame = CGRect(x: 0, y: 0, width: (leftImge?.size.width)!, height: (leftImge?.size.height)!)
        leftButton.setImage(leftImge, for: UIControlState())
        leftButton.addTarget(self, action: #selector(BaseViewController.leftBtnClick), for: .touchUpInside)
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 0)
        leftButton.setImage(leftImge, for: .highlighted)
        leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }

    func leftBtnClick() {
        self.navigationController!.popViewController(animated: true)
    }

}
