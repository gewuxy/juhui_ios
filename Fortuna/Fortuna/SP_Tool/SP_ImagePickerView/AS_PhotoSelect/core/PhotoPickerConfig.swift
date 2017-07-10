//
//  PhotoPickerConfig.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/6.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import Foundation
import UIKit

class PhotoPickerConfig {
    // tableView Cell height
    static let AlbumTableViewCellHeight: CGFloat = 90.0
    
    // message when select number more than the max number
    static let ErrorImageMaxSelect = "图片选择最多超过不能超过#张"
    
    // button confirm title
    static let ButtonConfirmTitle  = "确定"
    
    // button secelt image done title
    static let ButtonDone = "完成"
    
    // preview view bar background color
    static let PreviewBarBackgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
    
    // button green tin color
    static let GreenTinColor = UIColor(red: 7/255, green: 179/255, blue: 20/255, alpha: 1)
    
    // image total per line
    static let ColNumber: CGFloat = 4
    
    // collceiont cell padding
    static let MinimumInteritemSpacing: CGFloat = 5
    
    
    // fethch single large image max width
    static let PreviewImageMaxFetchMaxWidth:CGFloat = 600
    
    
}