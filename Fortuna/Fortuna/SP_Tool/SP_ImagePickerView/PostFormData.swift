//
//  PostFormData.swift
//  iexbuy
//
//  Created by sifenzi on 16/5/5.
//  Copyright © 2016年 IEXBUY. All rights reserved.
//

import UIKit

struct PostFormData {

    let key_data = "data"  //
    let key_requestName = "requestName"  //
    let key_filenName = "filenName"  //
    let key_fileType = "fileType"  //
    
    var data = Data() //
    var requestName = "" //
    var filenName = "" //
    var fileType = "" //
    
    
    init(dict:[String:AnyObject]) {
        data = (dict[key_data] as? Data)!
        requestName = dict[key_requestName] as? String ?? ""
        filenName = dict[key_filenName] as? String ?? ""
        fileType = dict[key_fileType] as? String ?? ""
    }
    init(Data: Foundation.Data, requeName: String, filName: String, filType: String) {
        data = Data
        requestName = requeName
        filenName = filName
        fileType = filType
    }
}
