//
//  M_MyDeal.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/20.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import SwiftyJSON

struct M_MyDeal {
    var buyer_name =  ""
    var wine_code =  ""
    var price =  ""
    var allprice =  ""
    var seller_id =  ""
    var seller_name =  "--"
    var create_at =  "--"
    var buyer_id =  ""
    var num = "--"
    var wine_name = ""
    
    
}

extension M_MyDeal:SP_JsonModel {
    init(_ json: JSON) {
        if json.isEmpty{
            return
        }
        buyer_name = json["buyer_name"].stringValue
        wine_code = json["wine_code"].stringValue
        price = String(format:"%.2f",json["price"].doubleValue)
        seller_id = json["seller_id"].stringValue
        seller_name = json["seller_name"].stringValue
        create_at = json["create_at"].stringValue
        buyer_id = json["buyer_id"].stringValue
        num = json["num"].stringValue
        wine_name = json["wine_name"].stringValue
        allprice = String(format:"%.2f",json["price"].doubleValue * json["num"].doubleValue)
        
        
    }
}
