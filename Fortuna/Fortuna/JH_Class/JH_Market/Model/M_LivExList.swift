//
//  M_Liv-ex.swift
//  Fortuna
//
//  Created by LCD on 2017/9/13.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class M_LivExListRealm: Object {
    dynamic var symbol = ""
    dynamic var level = ""
    dynamic var date = ""
    dynamic var ytdPerf = ""
    dynamic var fiveYearPerf = ""
    dynamic var momPerf = ""
    dynamic var name = ""
    dynamic var oneYearPerf = ""
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
    func write(_ model:M_LivExList) {
        symbol = model.symbol
        level =  model.level
        date =  model.date
        ytdPerf = model.ytdPerf
        fiveYearPerf =  model.fiveYearPerf
        momPerf =  model.momPerf
        name = model.name
        oneYearPerf = model.oneYearPerf
    }
    func read() -> M_LivExList {
        return M_LivExList(symbol: symbol,
                           level: level,
                           date: date,
                           ytdPerf: ytdPerf,
                           fiveYearPerf: fiveYearPerf,
                           momPerf: momPerf,
                           name: name,
                           oneYearPerf: oneYearPerf)
        
    }
}

struct M_LivExList {
    var symbol = ""
    var level = ""
    var date = ""
    var dates:String {
        let arr = date.components(separatedBy: "-")
        var str = ""
        for (i,item) in arr.enumerated() {
            if i == 0 {
                str = item
            }else{
                str = item + "." + str
            }
            
        }
        return str
    }
    var ytdPerf = ""
    var fiveYearPerf = ""
    var momPerf = ""
    var name = ""
    var oneYearPerf = ""
}
extension M_LivExList:SP_JsonModel {
    init(_ json: JSON) {
        if json.isEmpty{return}
        name = json["name"].stringValue
        symbol = json["symbol"].stringValue
        level = json["level"].stringValue
        date = json["date"].stringValue
        
        ytdPerf = String(format:"%.2f",json["ytdPerf"].doubleValue) + "%"
        fiveYearPerf = String(format:"%.2f",json["fiveYearPerf"].doubleValue) + "%"
        momPerf = String(format:"%.2f",json["momPerf"].doubleValue) + "%"
        oneYearPerf = String(format:"%.2f",json["oneYearPerf"].doubleValue) + "%"
        
    }
}

struct M_LivExHistory {
    var pctChange = ""
    var level = ""
    var date = ""
    var change = ""
    var dates:String {
        let arr = date.components(separatedBy: "-")
        var str = ""
        for (i,item) in arr.enumerated() {
            if i == 0 {
                str = item
            }else{
                str = item + "." + str
            }
            
        }
        return str
    }
    
}
extension M_LivExHistory:SP_JsonModel {
    init(_ json: JSON) {
        if json.isEmpty{return}
        pctChange = String(format:"%.2f",json["pctChange"].doubleValue) + "%"
        level = json["level"].stringValue
        date = json["date"].stringValue
        change = String(format:"%.2f",json["change"].doubleValue) + "%"
    }
}
