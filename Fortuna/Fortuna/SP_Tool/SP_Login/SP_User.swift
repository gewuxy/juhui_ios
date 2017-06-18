//
//  SP_User.swift
//  carpark
//
//  Created by 刘才德 on 2017/2/19.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxCocoa
import RxSwift
//LogInApi,Foreign_Login
let SP_Url登录接口 = "LogInApi"
/// 用户账号
let SP_UserAccount     =  "SP_UserAccount"
/// 用户密码
let SP_UserPwd       =  "SP_UserPwd"
/// 是否微信登录
let SP_UserLoginWX       =  "SP_UserLoginWX"
/// 是否微信登录
let SP_UserWXUnionId       =  "SP_UserWXUnionId"

open class SP_User {
    private static let sharedInstance = SP_User()
    private init() {}
    //提供静态访问方法
    open static var shared: SP_User {
        return self.sharedInstance
    }
    
    lazy var notification成功登陆了 = NSNotification.Name(rawValue: "CP_My成功登陆了")
    lazy var notification退出登陆了 = NSNotification.Name(rawValue: "CP_My退出登陆了")
    
    
    var userIsLogin: Bool {
        let isLogin = M_UserData.shared.userId.isEmpty ? false : true
        return isLogin
        
    }
    var userLoginWX:Bool {
        set{
            sp_UserDefaultsSet(SP_UserLoginWX, obj: newValue)
            sp_UserDefaultsSyn()
        }
        get{
            return sp_UserDefaultsGet(SP_UserLoginWX) as? Bool ?? false
        }
        
    }
    var userWXUnionId:String {
        set{
            sp_UserDefaultsSet(SP_UserWXUnionId, obj: newValue)
            sp_UserDefaultsSyn()
        }
        get{
            return sp_UserDefaultsGet(SP_UserWXUnionId) as? String ?? ""
        }
        
    }
    
    var userAccount:[String:String] {
        set{
            sp_UserDefaultsSet(SP_UserAccount, obj: newValue)
            sp_UserDefaultsSyn()
        }
        get{
            return sp_UserDefaultsGet(SP_UserAccount) as? [String:String] ?? ["Account":""]
        }
        
    }
    var userPwd:[String:String] {
        set{
            sp_UserDefaultsSet(SP_UserPwd, obj: newValue)
            sp_UserDefaultsSyn()
        }
        get{
            return sp_UserDefaultsGet(SP_UserPwd) as? [String:String] ?? ["Pwd":""]
        }
        
    }
    func removeUser(_ notification:Bool = true) {
        self.userPwd = ["":""]
        //self.userAccount = ""
        self.userLoginWX = false
        self.userWXUnionId = ""
        
        M_UserData.shared.remove()
        //M_UserMessageData.shared.remove()
        if notification {
            sp_Notification.post(name: SP_User.shared.notification退出登陆了, object: false)
        }
        
        //JPUSHService.setAlias("", callbackSelector: nil, object: self)
    }
    func setUser(userAccount:[String:String] = ["":""],pwd:[String:String] = ["":""]) {
        for item in userAccount {
            if !item.value.isEmpty {
                self.userAccount = userAccount
            }
        }
        for item in pwd {
            if !item.value.isEmpty {
                self.userPwd = pwd
            }
        }
    }
    
    func login(_ notification:Bool = false , block:@escaping ((Bool,String)->Void)) {
        /*
        if self.userLoginWX {
            let prame:[String:Any] = ["unionid":userWXUnionId]
            print_SP(prame)
            
            SP_NetWorkingType.post(urlString: CP_API.shared.url_微信授权登录, parameters: prame).alamofire_Net({ (isOk, response, error) in
                print_SP("url_微信授权登录\n\(JSON(response!))")
                let data = M_UserLogin(fromJson: JSON(response!))
                if data.data.statue {
                    sp_Notification.post(name: SP_User.shared.notification成功登陆了, object: true)
                    JPUSHService.setAlias(M_UserData.shared.userId, callbackSelector: nil, object: self)
                    self.url_用户中心详细内容()
                }else{
                    M_UserData.shared.userId = ""
                    M_UserData.shared.signText = ""
                    JPUSHService.setAlias("", callbackSelector: nil, object: self)
                }
                var err = ""
                switch data.data.statueCode {
                case 1:
                    err = "正常"
                case -1:
                    err = "账号或密码不正确"
                case -2:
                    err = "账号不正确"
                case -3:
                    err = "密码不正确"
                default:
                    err = error!
                }
                block(cp_ApiIsOk((isOk && data.data.statue),data.code),err)
                //开始计时
                self.timeStart()
            })
        }else{
            var parame = userAccount
            parame += userPwd
            
            SP_NetWorkingType.post(urlString: SP_Url登录接口, parameters: parame).alamofire_Net({ (isOk, response, error) in
                print_SP("url_登录接口\n\(JSON(response!))")
                let data = M_UserLogin(fromJson: JSON(response!))
                if data.data.loginStatue {
                    sp_Notification.post(name: SP_User.shared.notification成功登陆了, object: true)
                    JPUSHService.setAlias(M_UserData.shared.userId, callbackSelector: nil, object: self)
                    self.url_用户中心详细内容()
                }else{
                    M_UserData.shared.userId = ""
                    M_UserData.shared.signText = ""
                    JPUSHService.setAlias("", callbackSelector: nil, object: self)
                }
                var err = ""
                switch data.data.statueCode {
                case 1:
                    err = "正常"
                case -1:
                    err = "账号或密码不正确"
                case -2:
                    err = "账号不正确"
                case -3:
                    err = "密码不正确"
                default:
                    err = error!
                }
                block(cp_ApiIsOk((isOk && data.data.loginStatue),data.code),err)
                //开始计时
                self.timeStart()
            })
        }
        */
    }
    
    //极光推送注册别名 回调#selector(SP_User.tagsAliasCallBack(_:))
    @objc func tagsAliasCallBack(_ alias:String) {
        print_SP(alias)
    }
    
    
    
    func url_用户中心详细内容(_ block:(()->Void)? = nil) {
        let prame:[String:Any] = [:]
        /*
        CP_APIHelp.shared.net_Help(.url_用户中心详细内容, pram:prame) { (isOk, data, error) in
            switch isOk {
            case false:
                M_UserMessageData.shared.remove()
            case true:
                break
            }
            block?()
            if let vc = SP_MainWindow.rootViewController as? SP_TabBarController {
                var badgeValue = 0
                
                if M_UserMessageData.shared.newMessageNum > 0 {
                    badgeValue += M_UserMessageData.shared.newMessageNum
                }
                if M_UserMessageData.shared.newCommentsNum > 0 {
                    badgeValue += M_UserMessageData.shared.newCommentsNum
                }
                if M_UserMessageData.shared.newSystemMessageNum > 0 {
                    badgeValue += M_UserMessageData.shared.newSystemMessageNum
                }
                
                
                if M_UserMessageData.shared.newAttentionDynamics {
                    //my_newAttentionDynamics
                    
                }
                sp_Notification.post(name: NotificationName_NewAttention, object: M_UserMessageData.shared.newAttentionDynamics)
                
//                if M_UserMessageData.shared.newAttentionDynamicsNum > 0 {
//                    badgeValue += M_UserMessageData.shared.newAttentionDynamicsNum
//                }
                
                
                if badgeValue > 0 {
                    vc.childViewControllers.last?.tabBarItem.badgeValue = badgeValue > 99 ? "99+" : String(format: "%d", badgeValue)
                    UIApplication.shared.applicationIconBadgeNumber = 0
                    UIApplication.shared.applicationIconBadgeNumber = badgeValue
                    
                }else{
                    vc.childViewControllers.last?.tabBarItem.badgeValue = nil
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
//                if M_UserMessageData.shared.newMessage{
//                    badgeValue += 1
//                }
//                if M_UserMessageData.shared.newComments{
//                    badgeValue += 1
//                }
//                if M_UserMessageData.shared.newSystemMessage {
//                    badgeValue += 1
//                }
//                if M_UserMessageData.shared.newAttentionDynamics {
//                    badgeValue += 1
//                }
//                
//                if badgeValue > 0 {
//                    vc.childViewControllers.last?.tabBarItem.badgeValue = String(format: "%d", badgeValue)
//                    
//                }else{
//                    vc.childViewControllers.last?.tabBarItem.badgeValue = nil
//                }
                
            }
        }*/
    }
    
    
    //MARK:--- 秒表倒计时
    lazy var _timer:Timer? = {
        let tim = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(SP_User.timerClosure(_:)), userInfo: nil, repeats: true)
        return tim
    }()
    lazy var _countTime:Int = {
        let time = 1800
        return time
    }()
    lazy var _time:Int = {
        let time = 0
        return time
    }()
    lazy var isFirst:Bool = true
    func timeStart(){
        guard isFirst else {return}
        isFirst = false
        RunLoop.current.add(_timer!, forMode: .commonModes)
    }
    @objc private func timerClosure(_ timer: Timer) {
        _time += 1
        if _time >= _countTime{
            _time = 0
            //超时了
            login(block: { (isOk, error) in
            })
        }else{
            
        }
    }

    
}

//MARK:--- 用户模型
class M_UserLogin{
    
    var code = 1
    var data = M_UserData.shared
    var time = ""
    var msg = ""
    init(){}
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        code = json["Code"].intValue
        let dataJson = json["Data"]
        if !dataJson.isEmpty{
            M_UserData.shared.write(dataJson)
        }
        time = json["Time"].stringValue
        msg = json["msg"].stringValue
    }
    
}

class M_UserData {
    private static let sharedInstance = M_UserData()
    private init() {}
    //提供静态访问方法
    open static var shared: M_UserData {
        return self.sharedInstance
    }
    
    var loginStatue = false
    var statueCode = 0
    
    var statue = false
    
    var userLogo = ""
    var userName = ""
    var phone = ""
    var loginTime = ""
    var unionid = ""
    var expireTime = ""
    var signText = ""
    var userId = ""
    
    func remove(){
        loginStatue = false
        statueCode = 0
        statue = false
        
        userLogo = ""
        userName = ""
        phone = ""
        loginTime = ""
        
        expireTime = ""
        signText = ""
        userId = ""
        
        unionid = ""
    }
    func write(_ json: JSON!) {
        if json.isEmpty{
            return
        }
        unionid = json["unionid"].stringValue
        userId = json["UserId"].stringValue
        loginStatue = json["LoginStatue"].boolValue
        loginTime = json["LoginTime"].stringValue
        phone = json["Phone"].stringValue
        statueCode = json["StatueCode"].intValue
        userLogo = json["UserLogo"].stringValue
        userName = json["UserName"].stringValue
        statue = json["Statue"].boolValue
        expireTime = json["ExpireTime"].stringValue
        signText = json["SignText"].stringValue
        
        print_SP(expireTime)
        
        let strArray = expireTime.components(separatedBy: "/Date(")
        expireTime = strArray.joined(separator: "")
        let strArray2 = expireTime.components(separatedBy: ")/")
        expireTime = strArray2.joined(separator: "")
        
        let strArray3 = expireTime.components(separatedBy: "/Date(")
        loginTime = strArray3.joined(separator: "")
        let strArray4 = expireTime.components(separatedBy: ")/")
        loginTime = strArray4.joined(separator: "")
        
    }
    
}

