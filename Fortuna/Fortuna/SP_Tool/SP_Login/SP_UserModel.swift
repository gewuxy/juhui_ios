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


//MARK:--- ObjectMapper 版本 -----------------------------
struct SP_UserListModel {
    var users = [SP_UserModel]()
}

struct SP_UserModel {
    var name = ""
    var age = ""
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



extension SP_UserModel: Mappable {
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        age <- map["age"]
    }
}

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


//MARK:--- SwiftyJSON 版本 -----------------------------

struct SP_M_User: Mapable {
    var name = ""
    init?(jsonData: JSON) {
        self.name = jsonData["name"].stringValue
    }
}
extension SP_M_User {
    
}
extension SP_M_User: Hashable {
    var hashValue: Int {
        return name.hashValue
    }
}

extension SP_M_User: IdentifiableType {
    var identity: Int {
        return hashValue
    }
}

func ==(lhs: SP_M_User, rhs: SP_M_User) -> Bool {
    return lhs.name == rhs.name
}
