//
//  JH_API.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/8.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import Moya

#if DEBUG
let main_url = "http://39.108.142.204/"
#else
let main_url = "http://39.108.142.204/"
#endif






class My_API {
    private static let sharedInstance = My_API()
    private init() {}
    //提供静态访问方法
    open static var shared: My_API {
        return self.sharedInstance
    }
    //测试环境
    lazy var main_url = {return "http://39.108.142.204/"}()
    //生产环境
    //lazy var main_url = {return "https://app.wancheleyuan.com/AppIndex/"}()
    
    
    
    lazy var url_用户信息修改 = {return "api/account/info/"}()
    lazy var url_用户信息获取 = {return "api/account/info/"}()
}
