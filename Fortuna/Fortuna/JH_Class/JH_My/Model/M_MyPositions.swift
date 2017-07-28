//
//  M_MyPositions.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/21.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation

import SwiftyJSON

struct M_MyPositions {
    var total_market_value =  "--"
    var total_assets =  "--"
    var float_profit_loss =  "--"
    var current_profit_loss =  "--"
    var position_list =  [M_MyPositionsList]()
}
struct M_MyPositionsList {
    var name = ""
    var num =  "--"
    var profit_loss =  "--"
    var code =  "--"
    var profit_loss_ratio =  "--"
}
extension M_MyPositions:SP_JsonModel {
    init(_ json: JSON) {
        if json.isEmpty{
            return
        }
        total_market_value = String(format:"%.2f",json["total_market_value"].doubleValue)
        total_assets = String(format:"%.2f",json["total_assets"].doubleValue)
        float_profit_loss = String(format:"%.2f",json["float_profit_loss"].doubleValue)
        current_profit_loss = String(format:"%.2f",json["current_profit_loss"].doubleValue)
        
        total_market_value = total_market_value.isEmpty ? "--" : total_market_value
        total_assets = total_assets.isEmpty ? "--" : total_assets
        float_profit_loss = float_profit_loss.isEmpty ? "--" : float_profit_loss
        current_profit_loss = current_profit_loss.isEmpty ? "--" : current_profit_loss
        
        let positionArr = json["position_list"].arrayValue
        for item in positionArr {
            position_list.append(M_MyPositionsList(item))
        }
    }
}
extension M_MyPositionsList:SP_JsonModel {
    init(_ json: JSON) {
        if json.isEmpty{
            return
        }
        name = json["name"].stringValue
        num = json["num"].stringValue
        profit_loss = json["profit_loss"].stringValue
        code = json["code"].stringValue
        profit_loss_ratio = json["profit_loss_ratio"].stringValue
        
        num = num.isEmpty ? "--" : num
        profit_loss = profit_loss.isEmpty ? "--" : profit_loss
        code = code.isEmpty ? "--" : code
        profit_loss_ratio = profit_loss_ratio.isEmpty ? "--" : profit_loss_ratio
    }
}
