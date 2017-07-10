//
//  SP_UserAPI.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/21.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import SwiftyJSON

enum SP_UserAPI {
    static let url_登录 = "api/account/login/"
    case t_登录(mobile:String, pwd:String)
    
    static let url_退出登录 = "api/account/logout/"
    case t_退出登录
    
    static let url_注册 = "api/account/register/"
    case t_注册(mobile: String, pwd: String, code: String)
    
    static let url_短信 = "api/account/sendsms/"
    case t_短信(mobile: String, type: String)
    
    static let url_重置密码 = "api/account/resetpw/"
    case t_重置密码(mobile: String, pwd: String, code: String)
    
    static let url_用户信息获取 = "api/account/info/"
    case t_用户信息获取(mobile: String, token:String)
}

//MARK:--- 自己的版本 -----------------------------
extension SP_UserAPI {
    func post(_ block:((Bool,Any,String) -> Void)? = nil) {
        SP_Alamofire.shared._headers = [:]
        switch self {
        case .t_登录(let mobile, let pwd):
            let param = ["mobile": mobile, "password": pwd,"client_id":"NEEF9MakoTu9k573c9ExiuMjEp8BZxJ5J0LUk1mr","client_secret":"9zShX4vdI7jggML2rE6TBmrtsXbAdIoBVeGHuDTQ2xdNaVqRLErct9Zh7UgICRkyHE5AkI9iKTwkLsLjPgrveUNSJBK9oPMxONSaxs3vzajeoOUR33YxgZ0ZpPfUAA6t"]
            SP_Alamofire.post(main_url + SP_UserAPI.url_登录, param: param, block: { (isOk, data, error) in
                print_Json("url_登录=>\(JSON(data!))")
                My_API.map_Object(SP_UserModel.self, response: data, error: error, isOk: isOk, block: { (isOk, datas, error) in
                    block?(isOk, datas ?? "", error)
                })
                
            })
        case .t_退出登录:
            SP_Alamofire.shared._headers = ["Authorization":"Bearer "+SP_User.shared.userToken]
            let param = ["token":SP_User.shared.userToken]
            SP_Alamofire.get(main_url + SP_UserAPI.url_退出登录, param: param, block: { (isOk, data, error) in
                print_Json("url_退出登录=>\(JSON(data!))")
                My_API.map_Object(SP_UserModel.self, response: data, error: error, isOk: isOk, block: { (isOk, datas, error) in
                    block?(isOk, datas ?? "", error)
                })
                
            })
        case .t_注册(let mobile, let pwd, let code):
            let param = ["mobile": mobile, "password": pwd, "code": code]
            SP_Alamofire.post(main_url + SP_UserAPI.url_注册, param: param, block: { (isOk, data, error) in
                print_Json("url_注册=>\(JSON(data!))")
                My_API.map_Object(SP_UserModel.self, response: data, error: error, isOk: isOk, block: { (isOk, datas, error) in
                    block?(isOk, datas ?? "", error)
                })
            })
        case .t_短信(let mobile, let type):
            //, "sms_type": type
            let param = ["mobile": mobile]
            SP_Alamofire.post(main_url + SP_UserAPI.url_短信, param: param, block: { (isOk, data, error) in
                print_Json("url_短信=>\(JSON(data!))")
                My_API.map_Object(SP_UserModel.self, response: data, error: error, isOk: isOk, block: { (isOk, datas, error) in
                    block?(isOk, datas ?? "", error)
                })
            })
        case .t_重置密码(let mobile, let pwd, let code):
            let param = ["mobile": mobile, "password": pwd, "code": code]
            SP_Alamofire.post(main_url + SP_UserAPI.url_重置密码, param: param, block: { (isOk, data, error) in
                print_Json("url_重置密码=>\(JSON(data!))")
                My_API.map_Object(SP_UserModel.self, response: data, error: error, isOk: isOk, block: { (isOk, datas, error) in
                    block?(isOk, datas ?? "", error)
                })
            })
        case .t_用户信息获取(let mobile,let token):
            SP_Alamofire.shared._headers = ["Authorization":"Bearer "+SP_User.shared.userToken]
            let param = ["mobile": mobile]
            SP_Alamofire.get(main_url + SP_UserAPI.url_用户信息获取, param: param, block: { (isOk, data, error) in
                print_Json("url_用户信息获取=>\(JSON(data!))")
                My_API.map_Object(SP_UserModel.self, response: data, error: error, isOk: isOk, block: { (isOk, datas, error) in
                    //print_Json(datas)
                    if (datas != nil) {
                        //print_Json(datas)
                        SP_UserModel.write(datas ?? SP_UserModel())
                    }
                    block?(isOk, datas ?? SP_UserModel(), error)
                })
                
            })
        }
    }
    
    
}














//MARK:--- Moya 版本 -----------------------------
private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        
    }
}

let headerFields: [String: String] = [
    "platform": "iOS",
    "sys_ver": String(UIDevice.version())
]

let appendedParams: [String: Any] = ["uid": ""]

var endpointClosure = { (target: SP_UserAPI) -> Endpoint<SP_UserAPI> in
    //URLByAppendingPathComponent(target.path).absoluteString
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
        return Endpoint(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
        .adding(parameters: appendedParams)
        .adding(newHTTPHeaderFields: headerFields)
}

extension SP_UserAPI: TargetType {
    /// The method used for parameter encoding.
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    
    var baseURL: URL {
        return URL(string: main_url)!
    }
    
    var path: String {
        switch self {
        case .t_登录(_,_):
            return SP_UserAPI.url_登录
        case .t_退出登录:
            return SP_UserAPI.url_退出登录
        case .t_注册(_, _, _):
            return SP_UserAPI.url_注册
        case .t_短信(_, _):
            return SP_UserAPI.url_短信
        case .t_重置密码(_, _, _):
            return SP_UserAPI.url_重置密码
        case .t_用户信息获取(_,_):
            return SP_UserAPI.url_用户信息获取
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .t_登录(_,_):
            return .post
        case .t_退出登录:
            return .post
        case .t_注册(_, _, _):
            return .post
        case .t_短信(_, _):
            return .post
        case .t_重置密码(_, _, _):
            return .post
        case .t_用户信息获取(_,_):
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .t_登录(let mobile, let password):
            return ["mobile": mobile, "password": password]
        case .t_退出登录:
            return ["token":SP_User.shared.userToken]
        case .t_注册(let mobile, let password, let code):
            return ["mobile": mobile, "password": password, "code": code]
        case .t_短信(let mobile, let type):
            return ["mobile": mobile, "sms_type": type]
        case .t_重置密码(let mobile, let password, let code):
            return ["mobile": mobile, "password": password, "code": code]
        case .t_用户信息获取(let mobile,let token):
            return ["mobile": mobile,"token":token]
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8) ?? Data()
    }
    
    var task: Task {
        return .request
    }
}

