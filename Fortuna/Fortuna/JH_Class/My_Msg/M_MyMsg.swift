//
//  M_MsgSocket.swift
//  Fortuna
//
//  Created by LCD on 2017/9/14.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift


class M_MyMsgListRealm: Object {
    dynamic var msg_type = ""
    dynamic var create_time = ""
    dynamic var is_read = false
    dynamic var content = ""
    dynamic var to_user_id = ""
    dynamic var to_user_name = ""
    dynamic var to_user_img = ""
    dynamic var from_user_name = ""
    dynamic var from_user_img = ""
    dynamic var from_user_id = ""
    dynamic var notice_id = ""
    
    override static func primaryKey() -> String? {
        return "notice_id"
    }
    
    func write(_ model:M_MyMsgList) {
        msg_type = model.msg_type
        create_time = model.create_time
        is_read =  model.is_read
        content =  model.content
        to_user_id = model.to_user_id
        to_user_name =  model.to_user_name
        to_user_img =  model.to_user_img
        from_user_name = model.from_user_name
        from_user_img = model.from_user_img
        from_user_id = model.from_user_id
        notice_id = model.notice_id
    }
    func read() -> M_MyMsgList {
        var model = M_MyMsgList()
        model.msg_type = msg_type
        model.create_time = create_time
        model.is_read =  is_read
        model.content =  content
        model.to_user_id = to_user_id
        model.to_user_name =  to_user_name
        model.to_user_img =  to_user_img
        model.from_user_name = from_user_name
        model.from_user_img = from_user_img
        model.from_user_id = from_user_id
        model.notice_id = notice_id
        return model
        
    }
}

struct M_MyMsgList {
    enum msgType:String {
        case t评论 = "comment"
        case t点赞 = "like"
        case t新短评 = "new_commentary"
        case tOther = ""
    }
    var type:msgType {
        return msgType(rawValue: msg_type) ?? .tOther
    }
    var msg_type = ""
    var create_time = ""
    var is_read = false
    var content = ""
    var to_user_id = ""
    var to_user_name = ""
    var to_user_img = ""
    var from_user_name = ""
    var from_user_img = ""
    var from_user_id = ""
    var notice_id = ""
}
extension M_MyMsgList:SP_JsonModel {
    init(_ json: JSON) {
        if json.isEmpty {return}
        msg_type = json["msg_type"].stringValue
        create_time = json["create_time"].stringValue
        is_read = json["is_read"].boolValue
        content = json["content"].stringValue.removingPercentEncoding ?? json["content"].stringValue
        to_user_id = json["to_user_id"].stringValue
        to_user_name = json["to_user_name"].stringValue
        to_user_img = json["to_user_img"].stringValue
        from_user_name = json["from_user_name"].stringValue
        from_user_img = json["from_user_img"].stringValue
        from_user_id = json["from_user_id"].stringValue
        notice_id = json["notice_id"].stringValue
    }
}


struct M_MsgSocket {
    
    enum msgType:String {
        case t评论 = "comment"
        case t点赞 = "like"
        case t新短评 = "new_commentary"
        case tOther = ""
        
        var stringValue:String {
            switch self {
            case .t评论:
                return sp_localized("评论了你")
            case .t点赞:
                return sp_localized("赞了你")
            case .t新短评:
                return sp_localized("发表了一篇短评")
            default:
                return ""
            }
        }
    }
    var type:msgType {
        return msgType(rawValue: msg_type) ?? .tOther
    }
    //'comment',  # 消息类型，commen：评论；like：点赞；new_commentary：新短评。
    var msg_type = ""
    var from_name = ""
    var from_id = ""
    var to_id = ""
    var create_time = ""
    var content = ""
    var from_img = ""
    
    var commomString:String{
        var arr = [String]()
        let arrBastractString = content.components(separatedBy: "<*|换行:字符串|*>")
        for item in arrBastractString {
            let arr11 = item.components(separatedBy: "<*|属性:参数|*>")
            var text = ""
            for item in arr11 {
                if item.hasPrefix("text:") {
                    text = item
                    text[0 ..< 5] = ""
                }
            }
            arr.append(text)
        }
        let str0 = arr.joined()
        let arr0 = str0.components(separatedBy: "\n")
        let str1 = arr0.joined()
        if str1.characters.count > 30 {
            return str1[0 ..< 29] + "..."
        }
        return str1
    }
}
extension M_MsgSocket:SP_JsonModel {
    init(_ json: JSON) {
        if json.isEmpty {return}
        msg_type = json["msg_type"].stringValue
        from_name = json["from_name"].stringValue
        from_id = json["from_id"].stringValue
        to_id = json["to_id"].stringValue
        create_time = json["create_time"].stringValue
        content = json["content"].stringValue.removingPercentEncoding ?? json["content"].stringValue
        from_img = json["from_img"].stringValue
    }
}
