//
//  JH_Attention_Model.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/26.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift


/*
 因为已经建立好了模型，
 原则：不改变原有模型设计之上来添加功能，尽量将模块分离.
 */
class M_AttentionRealmS: Object {
    var id = ""
    
    var attentions = List<M_AttentionRealm>()
    
    var high_ratio = List<M_AttentionRealm>()
    var low_ratio = List<M_AttentionRealm>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class M_AttentionRealm: Object {
    dynamic var code =  ""
    dynamic var id =  ""
    dynamic var isDelete =  false
    dynamic var name =  ""
    dynamic var proposedPrice =  "--"
    dynamic var quoteChange =  "--"
    dynamic var winery =  ""
    dynamic var last_price = "--"
    
    dynamic var isFollow = false//是否已加自选
    dynamic var isSelect = false
    
    dynamic var ratio = ""
    
    override static func primaryKey() -> String? {
        return "code"
    }
    
    func write(_ model:M_Attention) {
        code = model.code
        id = model.id
        isDelete = model.isDelete
        name = model.name
        proposedPrice = model.proposedPrice
        quoteChange = model.quoteChange
        winery = model.winery
        last_price = model.last_price
        isFollow = model.isFollow
        isSelect = model.isSelect
        ratio = model.ratio
    }
    func read() -> M_Attention {
        return M_Attention(code: code,
                           id: id,
                           isDelete: isDelete,
                           name: name,
                           proposedPrice: proposedPrice,
                           quoteChange: quoteChange,
                           winery: winery,
                           last_price: last_price,
                           isFollow: isFollow,
                           isSelect: isSelect,
                           ratio: ratio)
        
    }
}

struct M_Attention {
    var code =  ""
    var id =  ""
    var isDelete =  false
    var name =  ""
    var proposedPrice =  "--"
    var quoteChange =  "--"
    var winery =  ""
    var last_price = "--"
    
    var isFollow = false//是否已加自选
    var isSelect = false
    
    var ratio = ""
}

extension M_Attention:SP_JsonModel {
    init(_ json: JSON) {
        if json.isEmpty{
            return
        }
        code = json["code"].stringValue
        id = json["id"].stringValue
        isDelete = json["is_delete"].boolValue
        name = json["name"].stringValue
        proposedPrice = String(format:"%.2f",json["proposed_price"].doubleValue)
        proposedPrice = proposedPrice.isEmpty ? "--" : proposedPrice
        quoteChange = json["quote_change"].stringValue
        quoteChange = quoteChange.isEmpty ? "--" : quoteChange
        winery = json["winery"].stringValue
        isFollow = json["is_select"].boolValue
        last_price = json["last_price"].stringValue
        last_price = last_price.isEmpty ? "--" : last_price
        ratio = json["ratio"].stringValue
        isSelect = false
    }
}


struct M_AttentionDetail {
    var code = ""
    //成交量
    var deal_count =  "--"
    //最高价
    var highest_price =  "--"
    //总市值
    var total_market_value =  "--"
    //换手率
    var turnover_rate =  "--"
    //最低价
    var lowest_price =  "--"
    //最新价
    var lastest_price =  "--"
    //振幅
    var amplitude =  "--"
    //量比
    var ratio = "--"
    //涨幅比例
    var increase_ratio = "--"
    //涨幅值
    var increase = "--"
    //成交额
    var turnover = "--"
    
    
    var buy_5_level:[[String]] = []
    var sell_5_level:[[String]] = []
    
    var shareTitle = ""
    var shareText = ""
    var shareImg = ""
    var shareLink = ""
    
    
}

extension M_AttentionDetail:SP_JsonModel {
    init(_ json: JSON) {
        if json.isEmpty{
            return
        }
        code = json["code"].stringValue
        
        shareTitle = json["shareTitle"].stringValue
        shareText = json["shareText"].stringValue
        shareImg = json["shareImg"].stringValue
        shareLink = json["shareLink"].stringValue
        
        increase_ratio = json["increase_ratio"].stringValue
        increase = json["increase"].stringValue
        
        turnover = json["turnover"].stringValue
        if turnover.isEmpty {
            turnover = "--"
        }else{
            let num = json["turnover"].doubleValue
            if  num >= 10000.0 {
                turnover = String(format: "%.2f万", num/10000.0)
            }
            if num >= 100000000.0 {
                turnover = String(format: "%.2f亿", num/100000000.0)
            }
            
        }
        //成交量
        deal_count =  json["deal_count"].stringValue
        if deal_count.isEmpty {
            deal_count = "--"
        }else{
            let num = json["deal_count"].doubleValue
            deal_count += "手"
            if  num >= 10000.0 {
                deal_count = String(format: "%.2f万手", num/10000.0)
            }
            if num >= 100000000.0 {
                deal_count = String(format: "%.2f亿手", num/100000000.0)
            }
            
        }
        
        //最高价
        highest_price =  json["highest_price"].stringValue
        if highest_price.isEmpty {
            highest_price = "--"
        }else{
            let num = json["highest_price"].doubleValue
            if  num >= 10000.0 {
                highest_price = String(format: "%.2f万", num/10000.0)
            }
            if num >= 100000000.0 {
                highest_price = String(format: "%.2f亿", num/100000000.0)
            }
            
        }
        //总市值
        total_market_value =  json["total_market_value"].stringValue
        if total_market_value.isEmpty {
            total_market_value = "--"
        }else{
            let num = json["total_market_value"].doubleValue
            if  num >= 10000.0 {
                total_market_value = String(format: "%.2f万", num/10000.0)
            }
            if num >= 100000000.0 {
                total_market_value = String(format: "%.2f亿", num/100000000.0)
            }
            
        }
        //换手率
        turnover_rate =  json["turnover_rate"].stringValue
        //最低价
        lowest_price =  json["lowest_price"].stringValue
        if lowest_price.isEmpty {
            lowest_price = "--"
        }else{
            let num = json["lowest_price"].doubleValue
            if  num >= 10000.0 {
                lowest_price = String(format: "%.2f万", num/10000.0)
            }
            if num >= 100000000.0 {
                lowest_price = String(format: "%.2f亿", num/100000000.0)
            }
            
        }
        //最新价
        lastest_price =  json["lastest_price"].stringValue
        if lastest_price.isEmpty {
            lastest_price = "--"
        }else{
            let num = json["lastest_price"].doubleValue
            if  num >= 10000.0 {
                lastest_price = String(format: "%.2f万", num/10000.0)
            }
            if num >= 100000000.0 {
                lastest_price = String(format: "%.2f亿", num/100000000.0)
            }
            
        }
        //振幅
        amplitude =  json["amplitude"].stringValue
        
        //量比
        ratio = String(format: "%.2f", json["ratio"].doubleValue)
        
        
        let buy_5_levelArr = json["buy_5_level"].arrayValue
        for item in buy_5_levelArr {
            let arr = item.arrayValue
            var ar:[String] = []
            for (i,item) in arr.enumerated() {
                if i == 0 {
                    let num = item.doubleValue
                    var str = "--"
                    if num > 0 {
                        str = String(format:"%.2f",num)
                        if  num >= 10000.0 {
                            str = String(format: "%.2f万", num/10000.0)
                        }
                        if num >= 100000000.0 {
                            str = String(format: "%.2f亿", num/100000000.0)
                        }
                    }
                    ar.append(str)
                }else{
                    let num = item.doubleValue
                    var str = "--"
                    if num > 0 {
                        str = String(format:"%.0f",num)
                        if  num >= 10000.0 {
                            str = String(format: "%.0f万", num/10000.0)
                        }
                        if num >= 100000000.0 {
                            str = String(format: "%.0f亿", num/100000000.0)
                        }
                    }
                    ar.append(str)
                }
                
            }
            buy_5_level.append(ar)
        }
        
        
        
        let sell_5_levelArr = json["sell_5_level"].arrayValue
        for item in sell_5_levelArr {
            let arr = item.arrayValue
            var ar:[String] = []
            for (i,item) in arr.enumerated() {
                if i == 0 {
                    let num = item.doubleValue
                    var str = "--"
                    if num > 0 {
                        str = String(format:"%.2f",num)
                        if  num >= 10000.0 {
                            str = String(format: "%.2f万", num/10000.0)
                        }
                        if num >= 100000000.0 {
                            str = String(format: "%.2f亿", num/100000000.0)
                        }
                    }
                    ar.append(str)
                }else{
                    let num = item.doubleValue
                    var str = "--"
                    if num > 0 {
                        str = String(format:"%.0f",num)
                        if  num >= 10000.0 {
                            str = String(format: "%.0f万", num/10000.0)
                        }
                        if num >= 100000000.0 {
                            str = String(format: "%.0f亿", num/100000000.0)
                        }
                    }
                    ar.append(str)
                }
                
            }
            sell_5_level.append(ar)
        }
    }
}

