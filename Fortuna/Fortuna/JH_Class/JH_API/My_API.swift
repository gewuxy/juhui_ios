//
//  JH_API.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/8.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation

class My_API {
    private static let sharedInstance = My_API()
    private init() {}
    //提供静态访问方法
    open static var shared: My_API {
        return self.sharedInstance
    }
    
    
}
