//
//  JH_Attention_Model.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/26.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import SwiftyJSON

struct M_Attention {
    var code =  ""
    var id =  ""
    var isDelete =  false
    var name =  ""
    var proposedPrice =  "--"
    var quoteChange =  ""
    var winery =  ""
    
    var isFollow = false
    var isSelect = false
    
}

extension M_Attention:SP_JsonModel {
    init?(_ json: JSON) {
        if json.isEmpty{
            return
        }
        code = json["code"].stringValue
        id = json["id"].stringValue
        isDelete = json["is_delete"].boolValue
        name = json["name"].stringValue
        proposedPrice = json["proposed_price"].stringValue
        quoteChange = json["quote_change"].stringValue
        winery = json["winery"].stringValue
        isFollow = json["isFollow"].boolValue
        isSelect = false
    }
}
