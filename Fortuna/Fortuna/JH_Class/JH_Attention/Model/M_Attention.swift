//
//  JH_Attention_Model.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/26.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import SwiftyJSON

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
    init?(_ json: JSON) {
        if json.isEmpty{
            return
        }
        code = json["code"].stringValue
        id = json["id"].stringValue
        isDelete = json["is_delete"].boolValue
        name = json["name"].stringValue
        proposedPrice = json["proposed_price"].stringValue
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
    //成交量
    var deal_count =  ""
    //最高价
    var highest_price =  ""
    //总市值
    var total_market_value =  ""
    //换手率
    var turnover_rate =  ""
    //最低价
    var lowest_price =  ""
    //最新价
    var lastest_price =  ""
    //振幅
    var amplitude =  ""
    //量比
    var ratio = ""
    
    var buy_5_level:[[Double]] = []
    var sell_5_level:[[Double]] = []
    
    var shareTitle = ""
    var shareText = ""
    var shareImg = ""
    var shareLink = ""
    
}

extension M_AttentionDetail:SP_JsonModel {
    init?(_ json: JSON) {
        if json.isEmpty{
            return
        }
        shareTitle = json["shareTitle"].stringValue
        shareText = json["shareText"].stringValue
        shareImg = json["shareImg"].stringValue
        shareLink = json["shareLink"].stringValue
        
        //成交量
        deal_count =  json["deal_count"].stringValue
        //最高价
        highest_price =  json["highest_price"].stringValue
        //总市值
        total_market_value =  json["total_market_value"].stringValue
        //换手率
        turnover_rate =  json["turnover_rate"].stringValue
        //最低价
        lowest_price =  json["lowest_price"].stringValue
        //最低价
        lastest_price =  json["lastest_price"].stringValue
        //振幅
        amplitude =  json["amplitude"].stringValue
        //量比
        ratio = json["ratio"].stringValue
        
        let buy_5_levelArr = json["buy_5_level"].arrayValue
        for item in buy_5_levelArr {
            let arr = item.arrayValue
            var ar:[Double] = []
            for i in arr {
                ar.append(i.doubleValue)
            }
            buy_5_level.append(ar)
        }
        
        
        
        let sell_5_levelArr = json["sell_5_level"].arrayValue
        for item in sell_5_levelArr {
            let arr = item.arrayValue
            var ar:[Double] = []
            for i in arr {
                ar.append(i.doubleValue)
            }
            sell_5_level.append(ar)
        }
    }
}

