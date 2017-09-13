//
//  M_Comment.swift
//  Fortuna
//
//  Created by LCD on 2017/9/11.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import SwiftyJSON
struct M_Comment {
    var comment_id = ""
    var contentString = ""
    var blog_id = ""
    var author_name = ""
    var create_time = ""
    var blog_title = ""
    var author_img = ""
    var likes_count = 0
    var content = [M_SP_RichText]()
    
}
extension M_Comment:SP_JsonModel {
    init(_ json: JSON) {
        guard !json.isEmpty else {
            return
        }
        comment_id = json["comment_id"].stringValue
        contentString = json["content"].stringValue
        blog_id = json["blog_id"].stringValue
        author_name = json["author_name"].stringValue
        create_time = json["create_time"].stringValue
        blog_title = json["blog_title"].stringValue
        author_img = json["author_img"].stringValue
        likes_count = json["likes_count"].intValue
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
            content.append(model)
        }
    }
}
