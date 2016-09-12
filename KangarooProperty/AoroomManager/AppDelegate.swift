//
//  AppDelegate.swift
//  KangarooProperty
//
//  Created by YYQ on 16/3/18.
//  Copyright © 2016年 YYQ. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // iOS8 下需要使用新的 API
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//            UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
//            
//            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
//            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//            NSString *isSystemPush = [NSString stringWithFormat:@"%lu", (unsigned long)myTypes];
//            NSUserDefaults *isSystemPushDefaults = [NSUserDefaults standardUserDefaults];
//            [isSystemPushDefaults setObject:isSystemPush forKey:k_isSystemPush];
//            [isSystemPushDefaults synchronize];
//        }else {
//            UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
//            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
//            NSString *isSystemPush = [NSString stringWithFormat:@"%lu", (unsigned long)myTypes];
//            NSUserDefaults *isSystemPushDefaults = [NSUserDefaults standardUserDefaults];
//            [isSystemPushDefaults setObject:isSystemPush forKey:k_isSystemPush];
//            [isSystemPushDefaults synchronize];
        
        if Float(UIDevice.currentDevice().systemVersion) >= 8.0 {
            let myTypes: UIUserNotificationType = [UIUserNotificationType.Badge,UIUserNotificationType.Sound,UIUserNotificationType.Alert]
//            let settings = UIUserNotificationSettings(forTypes: myTypes, categories: nil)
//            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
            JPUSHService.registerForRemoteNotificationTypes(myTypes.rawValue, categories: nil)
        }else {
            let myTypes: UIRemoteNotificationType = [UIRemoteNotificationType.Badge,UIRemoteNotificationType.Sound,UIRemoteNotificationType.Alert]
            JPUSHService.registerForRemoteNotificationTypes(myTypes.rawValue, categories: nil)
        }
        //注册微信
        WXApi.registerApp("wx76b9525a23eaaab5")
        //推送
        JPUSHService.setupWithOption(launchOptions, appKey: "fc7bdb69974e1601f7cfff8f", channel: nil, apsForProduction: true)
        NSNotificationCenter.defaultCenter().postNotificationName("badge", object: self, userInfo: nil)
        return true
    }

    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("DeviceToken 获取失败")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
//        BPush.handleNotification(userInfo)
        JPUSHService.handleRemoteNotification(userInfo)
        UIAlertView(title: "提示", message: "有新的推荐消息", delegate: self, cancelButtonTitle: "确定").show()
        
//        NSNotificationCenter.defaultCenter().postNotificationName("badge", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("badge", object: nil, userInfo: userInfo)
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        NSNotificationCenter.defaultCenter().postNotificationName("badge", object: nil, userInfo: nil)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

