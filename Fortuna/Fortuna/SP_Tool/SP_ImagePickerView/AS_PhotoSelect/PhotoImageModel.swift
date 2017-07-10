//
//  ImageModel.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/11.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import Foundation
import Photos

enum ModelType{
    case button
    case image
}

struct PhotoImageModel {
    var type: ModelType?
    var data: PHAsset?
    var imageData: Data?
    
    init(type: ModelType?,data:PHAsset?, imageData:Data?){
        self.type = type
        self.data = data
        self.imageData = imageData
    }
}
