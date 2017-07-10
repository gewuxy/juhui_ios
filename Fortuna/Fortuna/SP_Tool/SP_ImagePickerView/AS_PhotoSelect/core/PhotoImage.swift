//
//  PhotoImageSelected.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/9.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import Foundation
import Photos

class PhotoImage {
    
    // singleton
    static let instance = PhotoImage()
    fileprivate init(){}
    
    var selectedImage = [PHAsset]()
    
}
