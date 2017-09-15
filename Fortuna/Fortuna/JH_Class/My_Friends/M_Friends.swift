//
//  M_Friends.swift
//  Fortuna
//
//  Created by LCD on 2017/8/30.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class M_FriendsRealmS: Object {
    var id = ""
    
    var followlist = List<M_FriendsRealm>()
    
    var search = List<M_FriendsRealm>()
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class M_FriendsRealm: Object {
    dynamic var name =  ""
    dynamic var id =  ""
    dynamic var logo =  ""
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func write(_ model:M_Friends) {
        name = model.name
        id = model.id
        logo = model.logo
    }
    func read() -> M_Friends {
        return M_Friends(name: name,
                           id: id,
                           logo: logo)
        
    }
}


struct M_Friends {
    var name = "用户:--"
    var id = ""
    var logo = ""
}
extension M_Friends:SP_JsonModel {
    init(_ json: JSON) {
        guard !json.isEmpty else {
            return
        }
        id = json["user_id"].stringValue
        logo = json["user_img_url"].stringValue
        name = json["user_nickname"].stringValue
        if name.isEmpty {
            name = "用户:" + id
        }
    }
}
