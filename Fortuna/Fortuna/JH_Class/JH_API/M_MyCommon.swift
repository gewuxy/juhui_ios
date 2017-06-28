//
//  M_MyCommon.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/28.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import SwiftyJSON

struct M_MyCommon {
}

extension M_MyCommon:SP_JsonModel {
    init?(_ json: JSON) {
        if json.isEmpty{
            return
        }
    }
}
