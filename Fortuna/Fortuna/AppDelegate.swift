//
//  AppDelegate.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/5.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupRootViewController()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    //MARK:---- 应用程序将要进入活动状态，即将进入前台运行
    func applicationWillEnterForeground(_ application: UIApplication) {
        //极光推送，清除通知栏和角标
        //application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
        
        
    }

    //MARK:---------- 应用由后台恢复到前台,应用程序已进入前台
    func applicationDidBecomeActive(_ application: UIApplication) {
        userLogin(false)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

