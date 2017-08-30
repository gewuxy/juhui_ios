//
//  M_Friends.swift
//  Fortuna
//
//  Created by LCD on 2017/8/30.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import SwiftyJSON

struct M_Friends {
    var name = "--"
    var id = ""
    var logo = ""
}
extension M_Friends:SP_JsonModel {
    init(_ json: JSON) {
        
    }
}
