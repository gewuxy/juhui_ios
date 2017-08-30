//
//  M_SP_RichText.swift
//  Fortuna
//
//  Created by LCD on 2017/8/28.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import SwiftyJSON


struct M_SP_RichText {
    var type = 0  //0:普通文字，1：图片，2：@标签，3：$标签
    var text = ""
    var isBold = false
    var fontSize:Int = 18
    
    var imgUrl = ""
    var imgFile = ""
    
    var code = ""
    
    //是否进行了编辑了
    var isEdit = false
}

extension M_SP_RichText:SP_JsonModel {
    init(_ json: JSON) {
        guard !json.isEmpty else {return}
        
        fontSize = json["fontSize"].intValue
    }
}
