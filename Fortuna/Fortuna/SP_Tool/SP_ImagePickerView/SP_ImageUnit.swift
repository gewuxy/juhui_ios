//
//  SP_ImageUnit.swift
//  iexbuy
//
//  Created by sifenzi on 16/5/5.
//  Copyright © 2016年 IEXBUY. All rights reserved.
//

import UIKit
//缩放比例
let MAX_LONG: CGFloat = 1000.0
//JPG压缩比例
let RATIO_OF_IMAGE_TO_DATA: CGFloat = 0.5

struct SP_ImageUnit {
    //MARK:--- 返回 PNG 的 Data
    static func toPngData(_ image:UIImage, isZip:Bool) -> Data {
        var newImage = image
        if isZip {
            newImage = SP_ImageUnit.zipImage(image)
        }
        return UIImagePNGRepresentation(newImage) ?? Data()
    }
    //MARK:--- 返回 JPG 的 Data
    static func toJpgData(_ image:UIImage, isZip:Bool) -> Data {
        var newImage = image
        if isZip {
            newImage = SP_ImageUnit.zipImage(image)
        }
        return UIImageJPEGRepresentation(newImage, RATIO_OF_IMAGE_TO_DATA) ?? Data()
    }
    //MARK:--- 返回 string
    static func toBase64String(_ image:UIImage, isZip:Bool) -> String {
        var newImage = image
        if isZip {
            newImage = SP_ImageUnit.zipImage(image)
        }
        let data = UIImageJPEGRepresentation(newImage, RATIO_OF_IMAGE_TO_DATA)
        let encodedImageStr = String(format: "%@", (data?.base64EncodedString(options: .lineLength64Characters))!)
        return encodedImageStr
        
        
    }
    static func zipImage(_ oldImage:UIImage) -> UIImage {
        //设置image的压缩尺寸
        let  newSize = SP_ImageUnit.calculatePicNewSize(oldImage.size)
        
        UIGraphicsBeginImageContext(newSize)
        oldImage.draw(in: CGRect(x:0, y:0, width:newSize.width, height:newSize.height))
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImg!;
    }
    // 等比例缩放
    static func calculatePicNewSize(_ oldSize:CGSize) -> CGSize {
        let oldHeight = oldSize.height
        let oldWidth = oldSize.width
        var newHeight = oldHeight
        var newWidth = oldWidth
        if(oldHeight > oldWidth && oldHeight > MAX_LONG) {
            newHeight = MAX_LONG
            newWidth = oldWidth * newHeight / oldHeight
        } else if(oldHeight <= oldWidth && oldHeight <= MAX_LONG) {
            newWidth = MAX_LONG
            newHeight = oldHeight * newWidth / oldWidth
        }
        return CGSize(width:newWidth, height:newHeight)
    }
    
    //MARK:---- 保存图片至沙盒
    static func saveImage(_ imageData:Data, name:String) -> URL {
        /*var name = "abc"
        if let appName:String = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String {
            name = appName
        }*/
        // 获得沙盒的根路径
        let homeDocuments = NSHomeDirectory().appending("/Documents/").appending(name)
        // 获得Documents路径，使用NSString对象的stringByAppendingPathComponent()方法拼接路径
        let fullPath = URL(fileURLWithPath: homeDocuments)
        try! imageData.write(to: fullPath)
        
        //try! FileManager.default.createDirectory(atPath: homeDocuments, withIntermediateDirectories: true, attributes: nil)
        //FileManager.default.createFile(atPath: homeDocuments.appending("/image.png"), contents: imageData, attributes: nil)
        
        return fullPath
    }
    
    
    
}
