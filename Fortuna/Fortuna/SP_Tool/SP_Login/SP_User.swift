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
import Moya
import UICKeyChainStore

//LogInApi,Foreign_Login
let sp_Url登录接口 = "apis/account/login/"
/// 用户账号
let sp_UserAccount     =  "SP_UserAccount"
/// 用户设备码
let sp_UserUUID     =  "SP_UserUUID"
/// 用户Token
let sp_UserToken     =  "SP_UserToken"
/// 用户密码
let sp_UserPwd       =  "SP_UserPwd"
/// 用户密码
let sp_UserLoginLastDate       =  "SP_UserLoginLastDate"

/// 是否微信登录
let sp_UserLoginType       =  "SP_UserLoginTypes"
/// 微信登录
let sp_UserWXUnionId       =  "SP_UserWXUnionId"
/// QQ登录
let sp_UserQQUnionId       =  "SP_UserQQUnionId"


open class SP_User {
    private static let sharedInstance = SP_User()
    private init() {}
    //提供静态访问方法
    open static var shared: SP_User {
        return self.sharedInstance
    }
    
    lazy var ntfName_成功登陆了 = NSNotification.Name(rawValue: "ntfName_成功登陆了")
    lazy var ntfName_退出登陆了 = NSNotification.Name(rawValue: "ntfName_退出登陆了")
    lazy var ntfName_更新用户信息 = NSNotification.Name(rawValue: "ntfName_更新用户信息")
    let my_keyChain = UICKeyChainStore(service: "com.sifenzi.friends-Home.juhui.iosapp")
    var userIsLogin: Bool {
        let isLogin = userToken.isEmpty ? false : true
        return isLogin
        
    }
    enum sp_LoginType:String {
        case tOther = "tOther"
        case tUser = "tUser"
        case tWX = "tWX"
        case tQQ = "tQQ"
        
    }
    var deviceUUID:String {
        get{
            
            var str = my_keyChain.string(forKey: sp_UserUUID) ?? ""
            
            if str.isEmpty {
                //1.获取时间戳
                let timestamp = String(format:"%.0f",Date().timeIntervalSince1970)
                //2.产生随机数字符串
                let sjs = Int(arc4random_uniform(UInt32(100000)))
                //let sjs2 = Int(arc4random_uniform(UInt32(100000)))%Int(arc4random_uniform(UInt32(100000)))
                let randomNum = String(format:"%.0f",sjs)
                //3.获取时间，精确到毫秒
                let date = Date()
                let format = "YYYYMMddhhmmssSSS"
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = format
                let time = dateformatter.string(from: date)
                //4,产生随机字符串
                let characters = "abc0defghi1jklmnop2qrstu3vwxyzA4BCDEF5GHIJKL6MNOPQ7RST8UVW9XYZ"
                var ranStr = ""
                var ranStr2 = ""
                for _ in 0..<10 {
                    let index1 = Int(arc4random_uniform(UInt32(characters.characters.count)))
                    let index2 = Int(arc4random_uniform(UInt32(characters.characters.count)))
                    ranStr.append(characters[characters.index(characters.startIndex, offsetBy: index1)])
                    ranStr2.append(characters[characters.index(characters.startIndex, offsetBy: index2)])
                }
                
                //5.拼接字符串
                let uuid = ranStr + timestamp + randomNum + time + ranStr2
                
                my_keyChain.setString(uuid, forKey: sp_UserUUID)
            }
            str = my_keyChain.string(forKey: sp_UserUUID) ?? ""
            return str
        }
    }
    
    
    /*
    var userLoginType:sp_LoginType {
        set{
            sp_UserDefaultsSet(sp_UserLoginType, value: newValue.rawValue)
            sp_UserDefaultsSyn()
        }
        get{
            let str = sp_UserDefaultsGet(sp_UserLoginType) as? String ?? ""
            let type = sp_LoginType(rawValue:str) ?? .tOther
            return type
        }
        
    }*/
    
    var userWXUnionId:String {
        set{
            sp_UserDefaultsSet(sp_UserWXUnionId, value: newValue)
            sp_UserDefaultsSyn()
        }
        get{
            return sp_UserDefaultsGet(sp_UserWXUnionId) as? String ?? ""
        }
        
    }
    var userQQUnionId:String {
        set{
            sp_UserDefaultsSet(sp_UserQQUnionId, value: newValue)
            sp_UserDefaultsSyn()
        }
        get{
            return sp_UserDefaultsGet(sp_UserQQUnionId) as? String ?? ""
        }
        
    }
    
    var userAccount:String {
        set{
            sp_UserDefaultsSet(sp_UserAccount, value: newValue)
            sp_UserDefaultsSyn()
        }
        get{
            return sp_UserDefaultsGet(sp_UserAccount) as? String ?? ""
        }
        
    }
    var userToken:String {
        set{
            sp_UserDefaultsSet(sp_UserToken, value: newValue)
            sp_UserDefaultsSyn()
        }
        get{//"IKjKejCxNUTS2WBeD6x5yqz4nWYL2N"//
            return sp_UserDefaultsGet(sp_UserToken) as? String ?? ""
        }
        
    }
    
    var userPwd:String {
        set{
            my_keyChain.setString(newValue, forKey: sp_UserPwd)
        }
        get{
            return my_keyChain.string(forKey: sp_UserPwd) ?? ""
        }
        
    }
    var loginLastDate:Date {
        set{
            sp_UserDefaultsSet(sp_UserLoginLastDate, value: newValue)
            sp_UserDefaultsSyn()
        }
        get{
            return sp_UserDefaultsGet(sp_UserLoginLastDate) as? Date ?? Date(timeIntervalSince1970: 0)
        }
        
    }
    
    
    let disposeBag = DisposeBag()
    let userProvider = RxMoyaProvider<SP_UserAPI>()
    
    func removeUser(_ ntf:Bool = true) {
        
        self.userToken = ""
        self.userPwd = ""
        //self.userLoginType = .tOther
        self.userWXUnionId = ""
        self.userQQUnionId = ""
        SP_UserModel.remove()
        if ntf {
            sp_Notification.post(name: SP_User.shared.ntfName_退出登陆了, object: false)
        }
        
        
        //JPUSHService.setAlias("", callbackSelector: nil, object: self)
    }
    
    
    func setUser(userAccount:String = "",pwd:String = "") {
        self.userAccount = userAccount
        self.userPwd = pwd
    }
    
    //登录失效处理
    func needLogin() {
        removeUser(false)
    }
    
    func login(_ block: ((Bool,String)->Void)? = nil) {
        print_SP("\(userAccount)\(userPwd)")
        
        if !userWXUnionId.isEmpty {
            
        }
        else if !userWXUnionId.isEmpty {
            
        }
        else if !userAccount.isEmpty && !userPwd.isEmpty {
            SP_UserAPI.t_登录(mobile: userAccount, pwd: userPwd).post({ (isOk, datas, error) in
                //开始计时
                self.timeStart()
                if isOk{
                    
                    SP_User.shared.userToken = (datas as? SP_UserModel)?.token ?? ""
                    print_SP(SP_User.shared.userToken)
                    self.url_用户信息()
                    sp_Notification.post(name: SP_User.shared.ntfName_成功登陆了, object: nil)
                    SP_User.shared.loginLastDate = Date()
                }
                block?(isOk, error)
                
            })
            /* Moye + RxSwift 版本
             userProvider
             .request(.t_登录(mobile: userAccount,pwd: userPwd))
             .filterSuccessfulStatusCodes()
             .mapJSON()
             //.mapSwiftyJsonObj(SP_UserModel.self)
             //.mapObject(SP_UserListModel.self)
             .subscribe(onNext: { (datas) in
             print_SP("url_登录\n\(JSON(datas))")
             block?(true,"")
             }, onError: { (error) in
             print_SP(SP_MoyaReturnError(error))
             block?(false,SP_MoyaReturnError(error))
             }).addDisposableTo(disposeBag)*/
        }
        
        
        
        
        
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
    
    
    func signin(_ param:(mobile: String,pwd: String, code:String), block:((Bool,String)->Void)? = nil) {
        
        SP_UserAPI.t_注册(mobile: param.mobile, pwd: param.pwd, code: param.code).post { (isOk, datas, error) in
            
            block?(isOk, error)
        }
        /*
        userProvider
            .request(.t_注册(mobile: param.mobile,pwd: param.pwd, code:param.code))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapSwiftyJsonObj(SP_UserModel.self)
            //.mapObject(SP_UserListModel.self)
            .subscribe(onNext: { (datas) in
                //print_SP("url_注册\n\(JSON(datas))")
                block?(true,"")
            }, onError: { (error) in
                block?(false,SP_MoyaReturnError(error))
            }).addDisposableTo(disposeBag)*/
    }
    
    func resetPwd(_ param:(mobile: String,pwd: String, code:String), block:((Bool,String)->Void)? = nil) {
        SP_UserAPI
            .t_重置密码(mobile: param.mobile, pwd: param.pwd, code: param.code)
            .post { (isOk, datas, error) in
                block?(isOk,error)
        }
    }
    
    func sendSMS(_ param:(mobile: String,type: String), block:((Bool,String)->Void)? = nil) {
        SP_UserAPI
            .t_短信(mobile: param.mobile, type: param.type)
            .post { (isOk, datas, error) in
                block?(isOk,error)
        }
    }
    
    func loginOut(_ block:((Bool,String)->Void)? = nil) {
        SP_User.shared.removeUser()
        self.url_用户信息()
        block?(true,"")
        
        /*
        SP_UserAPI
            .t_退出登录
            .post { (isOk, datas, error) in
                SP_User.shared.removeUser()
                self.url_用户信息()
                block?(isOk,error)
        }*/
    }
    
    //极光推送注册别名 回调#selector(SP_User.tagsAliasCallBack(_:))
    @objc func tagsAliasCallBack(_ alias:String) {
        print_SP(alias)
    }
    
    
    
    func url_用户信息(_ block:(()->Void)? = nil) {
        SP_UserAPI
            .t_用户信息获取(mobile: userAccount)
            .post { (isOk, datas, error) in
                sp_Notification.post(name: SP_User.shared.ntfName_更新用户信息, object: nil)
                block?()
        }
        
        
        
        
        
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
    
    
    //MARK:--- 秒表倒计时 -- token 10小时过期，每小时轮询，登录一次
    lazy var _timer:Timer? = {
        let tim = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(SP_User.timerClosure(_:)), userInfo: nil, repeats: true)
        return tim
    }()
    lazy var _countTime:Int = {
        let time = 3600
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
            login({ (isOk, error) in
            })
        }else{
            
        }
    }
}

