//
//  PhotoFetchOptions.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/11.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import UIKit
import Photos

class PhotoFetchOptions: PHFetchOptions {
    static let shareInstance: PhotoFetchOptions = PhotoFetchOptions()
    fileprivate override init() {
        super.init()
        self.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        self.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    }
}
