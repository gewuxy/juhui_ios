//
//  M_Market.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/10.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import SwiftyJSON
////import RealmSwift
//import Realm



struct M_Market {
    var high_ratio = [M_Attention]()
    var low_ratio = [M_Attention]()
    
    
}

extension M_Market:SP_JsonModel {
    init(_ json: JSON) {
        if json.isEmpty{
            return
        }
        
        let high_ratioArr = json["high_ratio"].arrayValue
        for item in high_ratioArr {
            let value = M_Attention(item)
            high_ratio.append(value)
        }
        
        let low_ratioArr = json["low_ratio"].arrayValue
        for item in low_ratioArr {
            let value = M_Attention(item)
            low_ratio.append(value)
        }
    }
}

