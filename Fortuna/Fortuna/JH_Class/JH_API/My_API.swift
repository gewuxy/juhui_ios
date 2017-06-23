//
//  JH_API.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/8.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import SwiftyJSON

//#if DEBUG
//let main_url = "http://39.108.142.204/"
//#else
//let main_url = ""
//#endif

//测试环境
let main_url = "https://jh.qiuxiaokun.com/"
//生产环境
//let main_url = ""



enum My_API {
    static let url_用户信息修改 = "api/account/info/"
    case t_用户信息修改(mobile:String)
    
    
}
extension My_API {
    func post<T: SP_JsonModel>(_ type: T.Type, block:((Bool,Any,String) -> Void)? = nil) {
        
    }
    
    
    
}


//MARK:--- 数据初步处理 -----------------------------
public protocol SP_JsonModel {
    //所有的转模型通过遵循 SP_JsonModel 协议
    init?(_ json:JSON)
}
extension My_API {
    
    static func map_FromJSON<T: SP_JsonModel>(_ jsonData:JSON, classType: T.Type) -> T? {
        return T(jsonData)
    }
    
    static func map_Array<T: SP_JsonModel>(_ type: T.Type, response:Any?, error:String?, isOk:Bool, block:((Bool,[T],String)->Void)? = nil){
        if isOk {
            let json = JSON(response!)
            guard json[My_Net_Code].stringValue == My_NetCodeError.t成功.rawValue else{
                let message = (My_NetCodeError(rawValue: json[My_Net_Code].stringValue) ?? .tError).stringValue
                block?(false,[],message)
                return
            }
            guard let array:[JSON] = json[My_Net_Data].array else{
                block?(true,[],"没有数据！")
                return
            }
            var objects = [T]()
            
            if array.count > 0 {
                for object in array {
                    if let obj = My_API.map_FromJSON(object, classType:type)  {
                        objects.append(obj)
                    }
                }
                block?(true,objects,"")
            } else {
                block?(true,[],"没有数据！")
            }
        }else{
            block?(false,[],error!)
        }
    }
    
    static func map_Object<T: SP_JsonModel>(_ type: T.Type, response:Any?, error:String?, isOk:Bool, block:((Bool,T?,String)->Void)? = nil){
        if isOk {
            let json = JSON(response!)
            guard json[My_Net_Code].stringValue == My_NetCodeError.t成功.rawValue else{
                let message = (My_NetCodeError(rawValue: json[My_Net_Code].stringValue) ?? .tError).stringValue
                block?(false,nil,message)
                return
            }
            guard !json[My_Net_Data].isEmpty else{
                block?(true,nil,"没有数据！")
                return
            }
            let obj = My_API.map_FromJSON(json[My_Net_Data], classType:type)!
            block?(true,obj,"")
        }else{
            block?(false,nil,error!)
        }
    }
}

let My_Net_Code = "code"
let My_Net_Msg = "msg"
let My_Net_Data = "data"

enum My_NetCodeError: String {
    case t成功         = "000000"
    case t请求方法错误  = "000001"
    case t参数错误     = "000002"
    case t用户已注册   = "000003"
    case t用户未注册    = "000004"
    case t发送验证码失败 = "000005"
    case t密码错误     = "000006"
    case t需要登录     = "000007"
    case tError      = "011111"
    
    var stringValue:String {
        switch self {
        case .t成功:       return sp_localized(My_NetCodeError.t成功.rawValue)
        case .t请求方法错误: return sp_localized(My_NetCodeError.t请求方法错误.rawValue)
        case .t参数错误:    return sp_localized(My_NetCodeError.t参数错误.rawValue)
        case .t用户已注册:   return sp_localized(My_NetCodeError.t用户已注册.rawValue)
        case .t用户未注册:   return sp_localized(My_NetCodeError.t用户未注册.rawValue)
        case .t发送验证码失败: return sp_localized(My_NetCodeError.t发送验证码失败.rawValue)
        case .t密码错误: return sp_localized(My_NetCodeError.t密码错误.rawValue)
        case .t需要登录: return sp_localized(My_NetCodeError.t需要登录.rawValue)
        default: return sp_localized(My_NetCodeError.tError.rawValue)
        }
    }
}

