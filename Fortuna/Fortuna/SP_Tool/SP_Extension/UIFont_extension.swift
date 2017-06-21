//
//  UIFont_extension.swift
//  IEXBUY
//
//  Created by 刘才德 on 2016/11/3.
//  Copyright © 2016年 IEXBUY. All rights reserved.
//
import UIKit
import Foundation
extension UIFont {
    
    class func sp_font(_ size:CGFloat) -> UIFont {
        if sp_iphone == .tiPhoneP {
            return .systemFont(ofSize: size + 2.0)
        }
        if sp_iphone == .tiPhoneA {
            return .systemFont(ofSize: size + 1.0)
        }
        return .systemFont(ofSize: size)
    }
    class func sp_font(_ size:CGFloat, weight:CGFloat) -> UIFont {
        if sp_iphone == .tiPhoneP {
            if #available(iOS 8.2, *) {
                return .systemFont(ofSize: size + 2.0, weight: weight)
            } else {
                return .systemFont(ofSize: size + 2.0)
            }
        }
        if sp_iphone == .tiPhoneA {
            if #available(iOS 8.2, *) {
                return .systemFont(ofSize: size + 1.0, weight: weight)
            } else {
                return .systemFont(ofSize: size + 1.0)
            }
        }
        if #available(iOS 8.2, *) {
            return .systemFont(ofSize: size, weight: weight)
        } else {
            return .systemFont(ofSize: size)
        }
    }
    class func sp_fontBold(_ size:CGFloat) -> UIFont {
        
        if sp_iphone == .tiPhoneP {
            return .boldSystemFont(ofSize: size + 2.0)
        }
        if sp_iphone == .tiPhoneA {
            return .boldSystemFont(ofSize: size + 1.0)
        }
        return .boldSystemFont(ofSize: size)
    }
}
