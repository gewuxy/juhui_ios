//
//  UIAlert_Extension.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/26.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation

extension UIAlertController {
    class func showAler(_ pVc:UIViewController?,btnText:[String], title:String = "", message:String = "", block:((String)->Void)? = nil) {
        let aler = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for item in btnText {
            let action = UIAlertAction(title: item, style: .default, handler: { _ in
                block?(item)
            })
            aler.addAction(action)
        }
        
        pVc?.present(aler, animated: true, completion: nil)
        
        if btnText.count == 0 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) {
                aler.dismiss(animated: true, completion: { 
                    block?("dismiss")
                })
            }
        }
    }
}
