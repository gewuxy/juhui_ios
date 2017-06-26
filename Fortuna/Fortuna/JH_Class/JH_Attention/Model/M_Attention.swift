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
    
}

extension M_Attention:SP_JsonModel {
    init?(_ json: JSON) {
        if json.isEmpty{
            return
        }
    }
    
    
}
