//
//  M_News.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/21.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
import Realm


class M_NewsRealm: Object {
    dynamic var id = 0
    dynamic var article = ""
    dynamic var href =  ""
    dynamic var title =  ""
    dynamic var text = ""
    dynamic var news_time =  ""
    dynamic var thumb_img =  ""
    dynamic var author = ""
    dynamic var origin = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func write(_ model:M_News, _ index:Int) {
        id = index
        article = model.article
        href =  model.href
        title =  model.title
        text = model.text
        news_time =  model.news_time
        thumb_img =  model.thumb_img
        author = model.author
        origin = model.origin
    }
    func read() -> M_News {
        return M_News(article: article,
                      href: href,
                      title: title,
                      text: text,
                      news_time: news_time,
                      thumb_img: thumb_img,
                      author: author,
                      origin: origin)
        
    }
}


struct M_News {
    var article = ""
    var href =  ""
    var title =  ""
    var text = ""
    var news_time =  ""
    var thumb_img =  ""
    var author = ""
    var origin = ""
    
    
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
        author = json["author"].stringValue
        origin = json["origin"].stringValue
        article = json["article"].stringValue
        href = json["href"].stringValue
        title = json["title"].stringValue
        text = json["text"].stringValue
        news_time = json["news_time"].stringValue
        thumb_img = json["thumb_img"].stringValue
       
        
        
    }
}
