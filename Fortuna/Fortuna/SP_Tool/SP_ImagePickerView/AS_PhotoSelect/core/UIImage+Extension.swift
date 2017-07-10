//
//  UIImage+Extension.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/7.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    /**
     resize and crop image
     
     - parameter toSize: destnation size
     
     - returns: destination image
     */
    func resizeAndCropImage(_ toSize: CGSize)-> UIImage{
        
        let widthFactor = toSize.width / self.size.width
        let heightFactor =  toSize.height / self.size.height
        
        var positionX:CGFloat = 0
        var positionY:CGFloat = 0
        let scaleFactor = widthFactor > heightFactor ? widthFactor : heightFactor
    
        let scaleWidth = scaleFactor * self.size.width
        let scaleHeight = scaleFactor * self.size.height
        
        if widthFactor > heightFactor {
            positionY = (toSize.height - scaleHeight) * 0.5
        } else {
            positionX = (toSize.width - scaleWidth) * 0.5
        }
        
        UIGraphicsBeginImageContext(toSize)
        self.draw(in: CGRect(x: positionX, y: positionY, width: scaleWidth, height: scaleHeight))
        
        return UIGraphicsGetImageFromCurrentImageContext()!
        
    }
    
    
}
