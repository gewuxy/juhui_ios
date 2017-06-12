//
//  AppDelegate+Extension.swift
//  SuperApp
//
//  Created by LCD-sifenzi on 2016/10/8.
//  Copyright © 2016年 Friends-Home. All rights reserved.
//

import Foundation
import UIKit

//MARK:---------- 主要 Key
let my_APPID  = ""
let my_UMengAppKey  = "58d9fbbfbbea832efc001890"
let my_JPushKey     = "99875be9517257493bc38da8"
let my_WXappID      = "wx0a92d39012e81d0a"
let my_WXappSecret  = "88d47cc2c76637e4c4102f14b2f102bb"
let my_QQappID      = "1105975319"
let my_QQappSecret  = "SvyXcDOSaIyIQiZP"
let my_SinaappID      = "1691952433"
let my_SinaappSecret  = "ca759156415d114743397d8d0cab0c6c"
let my_AliappID      = "2015111700822536"

let my_ShareUrl  = "https://wancheleyuan.com"
let my_ShareDownUrl  = "https:/wancheleyuan.com"


extension AppDelegate {
    //MARK:----------- 状态栏全局样式
    func setupGlobalStyle() {
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }
    //MARK:----------- 配置根控制器
    func setupRootViewController() {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        sp_MainWindow = window!
        /*
        if isNewVersion() {
            let vc = SP_GuideVC()
            window?.rootViewController = vc
            vc.SP_firstOpenBlock = { [weak self]_ in
                
                let vc = SP_TabBarController.initSPVC()
                self?.window?.rootViewController = vc
                self?.saveVersion()
            }
        }else{
            let vc = SP_TabBarController.initSPVC()
            window?.rootViewContrvarer = vc
            //显示广告
            if let nvc = vc.childViewControllers.first as? UINavigationController, let hvc = nvc.childViewControllers.first as? my_HomeVC {
                hvc.isShowAds = true
                
            }
            
            
        }*/
        let vc = SP_TabBarController.initSPVC()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        
    }
    
    /*
    private static var tabBar:SP_TabBarController = {
        let viewControllers = [SP_MainVC.initSPVC(),SP_AdsVC.initSPVC(),SP_AdsVC.initSPVC(),SP_AdsVC.initSPVC(),SP_AdsVC.initSPVC()]
        let titles = ["1","2","","4","5"]
        let images = ["30x30","30x30","","30x30","30x30"]
        let selectedImages = ["30x30","30x30","","30x30","30x30"]
        let vc = SP_TabBarController.initTabbar(viewControllers, titles: titles, images: images, selectedImages: selectedImages, selectedIndex: 0)
        vc.setProperty(true, colorNormal: UIColor.maintext_darkgray, colorSelected: UIColor.main_1, titleFontNormal: 12.0, titleFontSelected: 12.0, imageInsets: UIEdgeInsetsMake(0, 0, 0, 0))
        vc.centerMenuButton()
        return vc
    }()
    */
    //MARK:----------- 判断是否是新版本
    private func isNewVersion() -> Bool {
        // 获取当前的版本号
        let versionString = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let nowVersion = versionString
        // 获取到之前的版本号
        let oldVersion: String = sp_UserDefaultsGet("my_OldVersionKey") as! String
        // 对比
        return nowVersion > oldVersion
    }
    //MARK:----------- 保存当前版本号
    private func saveVersion() {
        // 获取当前的版本号
        let nowVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "1.0.0"
        // 保存当前版本号
        sp_UserDefaultsSet("my_OldVersionKey", obj:nowVersion as AnyObject)
        sp_UserDefaultsSyn()
    }
    /*
    //MARK:---------- 友盟分享
    func umShare() {
        // ----- 打开日志
        UMSocialManager.default().openLog(true)
        // ----- 设置友盟appkey
        UMSocialManager.default().umSocialAppkey = my_UMengAppKey
        // ----- 获取友盟social版本号
        print("UMeng social version: \(UMSocialGlobal.umSocialSDKVersion())")
        // ----- 设置微信
        UMSocialManager.default().setPlaform(.wechatSession, appKey: my_WXappID, appSecret: my_WXappSecret, redirectURL: my_ShareUrl)
        // ----- 设置 QQ
        UMSocialManager.default().setPlaform(.QQ, appKey: my_QQappID, appSecret: my_QQappSecret, redirectURL: my_ShareUrl)
        //        UMSocialManager.defaultManager().setPlaform(.Qzone, appKey: QQappID, appSecret: QQappSecret, redirectURL: shareIhgUrl)
        //        UMSocialManager.defaultManager().setPlaform(.TencentWb, appKey: QQappID, appSecret: QQappSecret, redirectURL: shareIhgUrl)
        // ----- 设置新浪微博
        UMSocialManager.default().setPlaform(.sina, appKey: my_SinaappID, appSecret: my_SinaappSecret, redirectURL: my_ShareUrl)
        // ----- 设置支付宝
        
        
    }

    //MARK:--- 登录
    func userLogin(_ new:Bool) {
        //var result = gregorian!.components(NSCalendar.Unit.CalendarUnitHour, fromDate: dateresult!, toDate: NSDate(), options: NSCalendarOptions(0))
        //let dateresult = Date.xzReturnDateFormat("yyyy-MM-dd hh:mm:ss")
        
        
        if SP_User.shared.userIsLogin {
            SP_User.shared.url_用户中心详细内容()
        }else{
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        if !new {
            guard !M_UserData.shared.expireTime.isEmpty else {
                return
            }
            let endDate = Date(timeIntervalSince1970: Double(M_UserData.shared.expireTime)!/1000)
            let gregorian = Calendar(identifier: .gregorian)
            let result = gregorian.dateComponents([Calendar.Component.minute], from: endDate, to: Date())
            print_SP(result)
            guard result.minute! >= -10 else {
                return
            }
        }
        SP_User.shared.login( block:{ (isOk, error) in
            if isOk {
                
            }
        })
    }
    
    
    
    //MARK:---- 版本更新
    func updateVersions() {
        my_APIHelp.shared.net_Help(.url_版本控制, pram:[:]) { (isOk, data, error) in
            if isOk {
                guard SP_UpdateVersionViewModel.shared.isUpdateShow else {return}
                SP_UpdateVersionView.show()
            }
        }
        
    }*/

}
