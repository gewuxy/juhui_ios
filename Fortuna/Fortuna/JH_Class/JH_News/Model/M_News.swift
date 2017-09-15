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



class M_NewsSRealm: Object {
    dynamic var type = M_NewsS.newsType.t新闻.rawValue
    dynamic var parent_blog_id = ""
    dynamic var contentString = ""
    dynamic var bastractString = ""
    dynamic var blog_id = ""
    dynamic var likes_count = 0
    dynamic var comments_count = 0
    dynamic var area = ""
    dynamic var title = ""
    dynamic var is_delete = false
    dynamic var author_name = ""
    dynamic var author_img = ""
    dynamic var author_id = ""
    dynamic var create_time = ""
    dynamic var first_img = ""
    dynamic var is_concerned = false
    dynamic var is_likes = false
    
    
    override static func primaryKey() -> String? {
        return "blog_id"
    }
    
    func write(_ model:M_NewsS, _ index:Int) {
        type = model.type.rawValue
        parent_blog_id = model.parent_blog_id
        contentString = model.contentString
        bastractString = model.bastractString
        title =  model.title
        blog_id = model.blog_id
        likes_count =  model.likes_count
        comments_count =  model.comments_count
        area = model.area
        is_delete = model.is_delete
        author_name = model.author_name
        author_img = model.author_img
        author_id = model.author_id
        create_time = model.create_time
        first_img = model.first_img
        is_concerned = model.is_concerned
        is_likes = model.is_likes
    }
    func read() -> M_NewsS {
        var model = M_NewsS()
        model.type = M_NewsS.newsType(rawValue: type) ?? .t新闻
        model.parent_blog_id = parent_blog_id
        model.contentString = contentString
        model.bastractString = bastractString
        model.title =  title
        model.blog_id = blog_id
        model.likes_count = likes_count
        model.comments_count =  comments_count
        model.area = area
        model.is_delete = is_delete
        model.author_name = author_name
        model.author_id = author_id
        model.author_img = author_img
        model.create_time = create_time
        model.first_img = first_img
        model.is_concerned = is_concerned
        model.is_likes = is_likes
        return model
        
    }
}

struct M_NewsS {
    enum newsType:Int {
        case t新闻 = 0
        case t帖子
    }
    var type = newsType.t新闻
    var parent_blog_id = ""
    var contentString = ""
    var bastractString = ""
    var title = ""
    var blog_id = ""
    var likes_count = 0
    var comments_count = 0
    var area = ""
    var is_delete = false
    var author_name = ""
    var author_id = ""
    var author_img = ""
    var create_time = ""
    var first_img = ""
    var is_concerned = false
    var notice_not_read = 0
    var is_likes = false
    
    var news = M_News()
    
    var content:[M_SP_RichText] {
        var arr = [M_SP_RichText]()
        let arrContentString = contentString.components(separatedBy: "<*|换行:字符串|*>")
        for item in arrContentString {
            let arr11 = item.components(separatedBy: "<*|属性:参数|*>")
            var model = M_SP_RichText()
            for item in arr11 {
                if item.hasPrefix("type:") {
                    model.type = item
                    model.type[0 ..< 5] = ""
                }
                if item.hasPrefix("text:") {
                    model.text = item
                    model.text[0 ..< 5] = ""
                }
                if item.hasPrefix("fontPt:") {
                    var s = item
                    s[0 ..< 7] = ""
                    model.fontPt = CGFloat(Double(s) ?? 18)
                }
                if item.hasPrefix("fontPx:") {
                    var s = item
                    s[0 ..< 7] = ""
                    model.fontPx = CGFloat(Double(s) ?? 36)
                }
                if item.hasPrefix("isBold:") {
                    var s = item
                    s[0 ..< 7] = ""
                    model.isBold = s == "0" ? false : true
                }
                if item.hasPrefix("link:") {
                    model.link = item
                    model.link[0 ..< 5] = ""
                }
                if item.hasPrefix("code:") {
                    model.code = item
                    model.code[0 ..< 5] = ""
                }
                if item.hasPrefix("imgUrl:") {
                    model.imgUrl = item
                    model.imgUrl[0 ..< 7] = ""
                }
                if item.hasPrefix("imgWidth:") {
                    var s = item
                    s[0 ..< 9] = ""
                    model.imgWidth = CGFloat(Double(s) ?? 0)
                }
                if item.hasPrefix("imgHeight:") {
                    var s = item
                    s[0 ..< 10] = ""
                    model.imgHeight = CGFloat(Double(s) ?? 0)
                }
            }
            arr.append(model)
        }
        return arr
    }
    
    var bastract: [M_SP_RichText] {
        var arr = [M_SP_RichText]()
        let arrBastractString = bastractString.components(separatedBy: "<*|换行:字符串|*>")
        for item in arrBastractString {
            let arr11 = item.components(separatedBy: "<*|属性:参数|*>")
            var model = M_SP_RichText()
            for item in arr11 {
                if item.hasPrefix("type:") {
                    model.type = item
                    model.type[0 ..< 5] = ""
                }
                if item.hasPrefix("text:") {
                    model.text = item
                    model.text[0 ..< 5] = ""
                }
                if item.hasPrefix("fontPt:") {
                    var s = item
                    s[0 ..< 7] = ""
                    model.fontPt = CGFloat(Double(s) ?? 18)
                }
                if item.hasPrefix("fontPx:") {
                    var s = item
                    s[0 ..< 7] = ""
                    model.fontPx = CGFloat(Double(s) ?? 36)
                }
                if item.hasPrefix("isBold:") {
                    var s = item
                    s[0 ..< 7] = ""
                    model.isBold = s == "0" ? false : true
                }
                if item.hasPrefix("link:") {
                    model.link = item
                    model.link[0 ..< 5] = ""
                }
                if item.hasPrefix("code:") {
                    model.code = item
                    model.code[0 ..< 5] = ""
                }
                if item.hasPrefix("imgUrl:") {
                    model.imgUrl = item
                    model.imgUrl[0 ..< 7] = ""
                }
                if item.hasPrefix("imgWidth:") {
                    var s = item
                    s[0 ..< 9] = ""
                    model.imgWidth = CGFloat(Double(s) ?? 0)
                }
                if item.hasPrefix("imgHeight:") {
                    var s = item
                    s[0 ..< 10] = ""
                    model.imgWidth = CGFloat(Double(s) ?? 0)
                }
            }
            arr.append(model)
        }
        return arr
    }
}

extension M_NewsS:SP_JsonModel {
    init(_ json: JSON) {
        if json.isEmpty{
            return
        }
        parent_blog_id = json["parent_blog_id"].stringValue
        type = M_NewsS.newsType(rawValue: json["type"].intValue) ?? .t新闻
        blog_id = json["blog_id"].stringValue
        likes_count = json["likes_count"].intValue
        comments_count = json["comments_count"].intValue
        area = json["area"].stringValue
        title = json["title"].stringValue
        is_delete = json["is_delete"].boolValue
        author_name = json["author_name"].stringValue
        create_time = json["create_time"].stringValue
        author_img = json["author_img"].stringValue
        author_id = json["author_id"].stringValue
        first_img = json["first_img"].stringValue
        
        is_concerned = json["is_concerned"].boolValue
        notice_not_read = json["notice_not_read"].intValue
        is_likes = json["is_like"].boolValue
        
        news = M_News(json["news"])
        
        contentString = json["content"].stringValue.removingPercentEncoding ?? json["content"].stringValue
        bastractString = json["abstract"].stringValue.removingPercentEncoding ?? json["abstract"].stringValue
    }
}
