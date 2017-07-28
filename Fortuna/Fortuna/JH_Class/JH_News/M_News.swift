//
//  M_News.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/21.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import SwiftyJSON
struct M_News {
    var article = ""
    var href =  ""
    var title =  ""
    var text = ""
    var news_time =  ""
    var thumb_img =  ""
    var newsYY:String {
        let arr = news_time.components(separatedBy: " ")
        return arr.count > 0 ? arr.first! : "--"
    }
    var newsMM:String {
        let arr = news_time.components(separatedBy: " ")
        return arr.count > 0 ? arr.last! : "--"
    }
    
    
}

extension M_News:SP_JsonModel {
    init(_ json: JSON) {
        if json.isEmpty{
            return
        }
        article = json["article"].stringValue
        href = json["href"].stringValue
        title = json["title"].stringValue
        text = json["text"].stringValue
        news_time = json["news_time"].stringValue
        thumb_img = json["thumb_img"].stringValue
       
        
        
    }
}
