//
//  M_TimeLine.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/5.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import SwiftyJSON

struct M_TimeLine {
    var high_price = ""
    var low_price = ""
    var num = ""
    var last_price = ""
    var timestamp = ""
    
    var open_price = ""
    var close_price = ""
    var deal_count = ""
    var turnover_rate = ""
    
}

extension M_TimeLine:SP_JsonModel {
    init(_ json: JSON) {
        if json.isEmpty{
            return
        }
        high_price = json["high_price"].stringValue.isEmpty ? "0" : json["high_price"].stringValue
        
        low_price = json["low_price"].stringValue.isEmpty ? "0" : json["low_price"].stringValue
        
        num = json["num"].stringValue.isEmpty ? "0" : json["num"].stringValue
        
        last_price = json["last_price"].stringValue.isEmpty ? "0" : json["last_price"].stringValue
        
        timestamp = json["timestamp"].stringValue + "000"
        
        open_price = json["open_price"].stringValue.isEmpty ? "0" : json["open_price"].stringValue
        
        close_price = json["close_price"].stringValue.isEmpty ? "0" : json["close_price"].stringValue
        
        deal_count = json["deal_count"].stringValue.isEmpty ? "0" : json["deal_count"].stringValue
        
        
        
        turnover_rate = json["turnover_rate"].stringValue.isEmpty ? "--" : json["turnover_rate"].stringValue
        
    }
}


