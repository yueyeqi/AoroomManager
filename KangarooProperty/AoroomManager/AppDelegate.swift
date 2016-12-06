//
//  AppDelegate.swift
//  KangarooProperty
//
//  Created by YYQ on 16/3/18.
//  Copyright © 2016年 YYQ. All rights reserved.
//

import UIKit
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, JPUSHRegisterDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let version: String = UIDevice.current.systemVersion
        let versionInt = Int(version.replacingOccurrences(of: ".", with: ""))
        if  versionInt! >= 1000 {
            let entity:JPUSHRegisterEntity = JPUSHRegisterEntity()
            let type: UInt = UIUserNotificationType.alert.rawValue | UIUserNotificationType.sound.rawValue | UIUserNotificationType.badge.rawValue
            entity.types = Int(type)
            JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        }else if versionInt! >= 800 {
            JPUSHService.register(forRemoteNotificationTypes: UIUserNotificationType.alert.rawValue | UIUserNotificationType.sound.rawValue | UIUserNotificationType.badge.rawValue, categories: nil)
        }else {
            JPUSHService.register(forRemoteNotificationTypes: UIUserNotificationType.alert.rawValue | UIUserNotificationType.sound.rawValue | UIUserNotificationType.badge.rawValue, categories: nil)
        }
        
        //推送
        JPUSHService.setup(withOption: launchOptions, appKey: "fc7bdb69974e1601f7cfff8f", channel: nil, apsForProduction: true)
        
        JPUSHService.registrationIDCompletionHandler { (resCode, resID) in
            if resCode == 0 {
                print(NSString(format: "registrationID获取成功:%@", resID!))
            }else {
                print(NSString(format: "registrationID获取失败:%@", resCode))
            }
        }
        
        //注册微信
        WXApi.registerApp("wx76b9525a23eaaab5")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "badge"), object: self, userInfo: nil)
        return true
    }
    
    //后台收到通知
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "badge"), object: nil, userInfo: nil)
        completionHandler()
    }
    
    //前台收到通知
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        JPUSHService.handleRemoteNotification(userInfo)
        UIAlertView(title: "提示", message: "有新的推荐消息", delegate: self, cancelButtonTitle: "确定").show()
        let badge: NSNumber = notification.request.content.badge!
        NotificationCenter.default.post(name: Notification.Name(rawValue: "badge"), object: nil, userInfo: ["badge": badge])
        
        let type: UInt = UIUserNotificationType.alert.rawValue | UIUserNotificationType.sound.rawValue | UIUserNotificationType.badge.rawValue
        completionHandler(Int(type))
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("DeviceToken 获取失败")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        NotificationCenter.default.post(name: Notification.Name(rawValue: "badge"), object: nil, userInfo: nil)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

