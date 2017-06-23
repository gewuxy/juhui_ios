//
//  SP_UserListModel.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/21.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import RxDataSources
import ObjectMapper
import SwiftyJSON
import Moya


//MARK:--- SP_UserListModel -----------------------------
struct SP_UserListModel {
    var users = [SP_UserModel]()
}
extension SP_UserListModel: Mappable {
    init?(map: Map) { }
    mutating func mapping(map: Map) {
        users <- map["users"]
    }
}
extension SP_UserListModel: Hashable {
    var hashValue: Int {
        return users.description.hashValue
    }
}

extension SP_UserListModel: IdentifiableType {
    var identity: Int {
        return hashValue
    }
}

func ==(lhs: SP_UserListModel, rhs: SP_UserListModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
}


//MARK:--- SP_UserModel -----------------------------
enum SP_UserModelKey:String {
    case createdAt = "SP_User_createdAt"
    case email = "SP_User_email"
    case userId = "SP_User_userId"
    case imgUrl = "SP_User_imgUrl"
    case isDelete = "SP_User_isDelete"
    case mobile = "SP_User_mobile"
    case nickname = "SP_User_nickname"
    case role = "SP_User_role"
    case unionId = "SP_User_unionId"
    case updatedAt = "SP_User_updatedAt"
    case user = "SP_User_user"
    case personalSelect = "SP_User_personalSelect"
    case tradePasswd = "SP_User_tradePasswd"
}
struct SP_UserModel {
    var createdAt = ""
    var email = ""
    var userId = ""
    var imgUrl = ""
    var isDelete = false
    var mobile = ""
    var nickname = ""
    var role = ""
    var unionId = ""
    var updatedAt = ""
    var user = ""
    var personalSelect = ""
    var tradePasswd = ""
    
    var token = ""
}
////--- ObjectMapper 版本
//extension SP_UserModel: Mappable {
//    init?(map: Map) { }
//    
//    mutating func mapping(map: Map) {
//        
//    }
//}
//--- SwiftyJSON 版本
extension SP_UserModel: Mapable {
    init?(jsonData: JSON) {
        
    }
}
extension SP_UserModel: SP_JsonModel {
    init?(_ json: JSON) {
        if json.isEmpty{
            return
        }
        createdAt = json["created_at"].stringValue
        email = json["email"].stringValue
        userId = json["id"].stringValue
        imgUrl = json["img_url"].stringValue
        isDelete = json["is_delete"].boolValue
        mobile = json["mobile"].stringValue
        nickname = json["nickname"].stringValue
        role = json["role"].stringValue
        unionId = json["union_id"].stringValue
        updatedAt = json["updated_at"].stringValue
        user = json["user"].stringValue
        
        personalSelect = json["personal_select"].stringValue
        tradePasswd = json["trade_passwd"].stringValue
        token = json["token"].stringValue
        
    }
}
extension SP_UserModel {
    static func write(_ model:SP_UserModel) {
        sp_UserDefaultsSet(SP_UserModelKey.createdAt.rawValue, value: model.createdAt)
        sp_UserDefaultsSet(SP_UserModelKey.email.rawValue, value: model.email)
        sp_UserDefaultsSet(SP_UserModelKey.userId.rawValue, value: model.userId)
        sp_UserDefaultsSet(SP_UserModelKey.imgUrl.rawValue, value: model.imgUrl)
        sp_UserDefaultsSet(SP_UserModelKey.isDelete.rawValue, value: model.isDelete)
        sp_UserDefaultsSet(SP_UserModelKey.mobile.rawValue, value: model.mobile)
        sp_UserDefaultsSet(SP_UserModelKey.nickname.rawValue, value: model.nickname)
        sp_UserDefaultsSet(SP_UserModelKey.role.rawValue, value: model.role)
        sp_UserDefaultsSet(SP_UserModelKey.unionId.rawValue, value: model.unionId)
        sp_UserDefaultsSet(SP_UserModelKey.updatedAt.rawValue, value: model.updatedAt)
        sp_UserDefaultsSet(SP_UserModelKey.user.rawValue, value: model.user)
        sp_UserDefaultsSet(SP_UserModelKey.personalSelect.rawValue, value: model.personalSelect)
        sp_UserDefaultsSet(SP_UserModelKey.tradePasswd.rawValue, value: model.tradePasswd)
        sp_UserDefaultsSyn()
    }
    static func read() -> SP_UserModel {
        var model = SP_UserModel()
        model.createdAt = sp_UserDefaultsGet(SP_UserModelKey.createdAt.rawValue) as? String ?? ""
        model.email = sp_UserDefaultsGet(SP_UserModelKey.email.rawValue) as? String ?? ""
        model.userId = sp_UserDefaultsGet(SP_UserModelKey.userId.rawValue) as? String ?? ""
        model.imgUrl = sp_UserDefaultsGet(SP_UserModelKey.imgUrl.rawValue) as? String ?? ""
        model.isDelete = sp_UserDefaultsGet(SP_UserModelKey.isDelete.rawValue)as? Bool ?? false
        model.mobile = sp_UserDefaultsGet(SP_UserModelKey.mobile.rawValue) as? String ?? ""
        model.nickname = sp_UserDefaultsGet(SP_UserModelKey.nickname.rawValue) as? String ?? ""
        model.role = sp_UserDefaultsGet(SP_UserModelKey.role.rawValue) as? String ?? ""
        model.unionId = sp_UserDefaultsGet(SP_UserModelKey.unionId.rawValue) as? String ?? ""
        model.updatedAt = sp_UserDefaultsGet(SP_UserModelKey.updatedAt.rawValue) as? String ?? ""
        model.user = sp_UserDefaultsGet(SP_UserModelKey.user.rawValue) as? String ?? ""
        
        model.personalSelect = sp_UserDefaultsGet(SP_UserModelKey.personalSelect.rawValue) as? String ?? ""
        model.tradePasswd =  sp_UserDefaultsGet(SP_UserModelKey.tradePasswd.rawValue) as? String ?? ""
        return model
    }
    static func remove() {
        sp_UserDefaultsSet(SP_UserModelKey.createdAt.rawValue, value: "")
        sp_UserDefaultsSet(SP_UserModelKey.email.rawValue, value: "")
        sp_UserDefaultsSet(SP_UserModelKey.userId.rawValue, value: "")
        sp_UserDefaultsSet(SP_UserModelKey.imgUrl.rawValue, value: "")
        sp_UserDefaultsSet(SP_UserModelKey.isDelete.rawValue, value: false)
        sp_UserDefaultsSet(SP_UserModelKey.mobile.rawValue, value: "")
        sp_UserDefaultsSet(SP_UserModelKey.nickname.rawValue, value: "")
        sp_UserDefaultsSet(SP_UserModelKey.role.rawValue, value: "")
        sp_UserDefaultsSet(SP_UserModelKey.unionId.rawValue, value: "")
        sp_UserDefaultsSet(SP_UserModelKey.updatedAt.rawValue, value: "")
        sp_UserDefaultsSet(SP_UserModelKey.user.rawValue, value: "")
        sp_UserDefaultsSet(SP_UserModelKey.personalSelect.rawValue, value: "")
        sp_UserDefaultsSet(SP_UserModelKey.tradePasswd.rawValue, value: "")
        sp_UserDefaultsSyn()
    }
}

/*
extension SP_UserModel: Hashable {
    var hashValue: Int {
        return name.hashValue
    }
}

extension SP_UserModel: IdentifiableType {
    var identity: Int {
        return hashValue
    }
}

func ==(lhs: SP_UserModel, rhs: SP_UserModel) -> Bool {
    return lhs.name == rhs.name
}
*/

