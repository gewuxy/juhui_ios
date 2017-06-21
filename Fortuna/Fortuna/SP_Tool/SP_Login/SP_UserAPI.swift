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


enum SP_UserAPI {
    case tLogin(mobile:String, pwd:String)
    case tSignin(mobile: String, pwd: String, code: String)
    case tSendSMS(mobile: String, type: String)
    case tResetPwd(mobile: String, pwd: String, code: String)
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
        case .tLogin(_,_):
            return "apis/account/login"
        case .tSignin(_, _, _):
            return "api/account/register"
        case .tSendSMS(_, _):
            return "api/account/sendsms"
        case .tResetPwd(_, _, _):
            return "apis/account/resetpw"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .tLogin(_,_):
            return .post
        case .tSignin(_, _, _):
            return .post
        case .tSendSMS(_, _):
            return .post
        case .tResetPwd(_, _, _):
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .tLogin(let mobile, let password):
            return ["mobile": mobile, "password": password]
        case .tSignin(let mobile, let password, let code):
            return ["mobile": mobile, "password": password, "code": code]
        case .tSendSMS(let mobile, let type):
            return ["mobile": mobile, "sms_type": type]
        case .tResetPwd(let mobile, let password, let code):
            return ["mobile": mobile, "password": password, "code": code]
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8) ?? Data()
        switch self {
        case .tLogin(_,_):
            return "".data(using: String.Encoding.utf8) ?? Data()
        case .tSignin(_, _, _):
            return "".data(using: String.Encoding.utf8) ?? Data()
        default: return "".data(using: String.Encoding.utf8) ?? Data()
        }
    }
    
    var task: Task {
        return .request
    }
}
