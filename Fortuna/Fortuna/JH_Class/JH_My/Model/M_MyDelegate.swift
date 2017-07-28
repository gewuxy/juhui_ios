//
//  M_MyDelegate.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/20.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import SwiftyJSON

struct M_MyDelegate {
    var id =  ""
    var update_at =  ""
    var create_at =  "--"
    var price =  ""
    var user_name =  ""
    var trade_direction =  ""
    var user_id =  "--"
    var wine_code =  ""
    var num = "--"
    var wine_name = ""
    
    var statusStr:String {
        return trade_direction + status.stringValue
    }
    var status = statusType.t可撤销
    
    enum statusType:Int {
        case t可撤销 = 0
        case t已撤销 = 1
        case t已成交 = 2
        case t已取消 = 3
        case t未知
        
        var stringValue:String {
            switch self {
            case .t可撤销:
                return "已报"
            case .t已撤销:
                return "已撤销"
            case .t已成交:
                return "已成交"
            case .t已取消:
                return "已取消"
            case .t未知:
                return "状态未知"
            
            }
        }
    }
}

extension M_MyDelegate:SP_JsonModel {
    init(_ json: JSON) {
        if json.isEmpty{
            return
        }
        id = json["id"].stringValue
        update_at = json["update_at"].stringValue
        create_at = json["create_at"].stringValue
        price = String(format:"%.2f",json["price"].doubleValue)
        user_name = json["user_name"].stringValue
        user_id = json["user_id"].stringValue
        num = json["num"].stringValue
        wine_code = json["wine_code"].stringValue
        wine_name = json["wine_name"].stringValue
        trade_direction = json["trade_direction"].stringValue
        status = M_MyDelegate.statusType(rawValue: json["status"].intValue) ?? .t未知
    }
}
