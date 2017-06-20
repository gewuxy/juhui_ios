//
//  Color+Extension.swift
//  IEXBUY
//
//  Created by 刘才德 on 2016/11/3.
//  Copyright © 2016年 IEXBUY. All rights reserved.
//
import UIKit
extension UIColor {
    ///主题色 -- 界面主色
    open class var main_1: UIColor {
        return UIColor.main_string("#fe6c72")
    }
    ///第二主题色 -- 界面辅助色
    open class var main_2: UIColor {
        return UIColor.main_string("#ff5475")
    }
    ///第三主题色 -- 界面辅助色
    open class var main_3: UIColor {
        return UIColor.main_string("#5c86ff")
    }
    
    ///第1字色 -- 字体主色
    open class var mainText_1: UIColor {
        return UIColor.main_string("#4d4d4d")
    }
    ///第2字色 -- 字体副色
    open class var mainText_2: UIColor {
        return UIColor.main_string("#8c8c8c")
    }
    ///第3字色 -- 字体辅助色
    open class var mainText_3: UIColor {
        return UIColor.main_string("#b2b2b2")
    }
    
    ///第4字色 -- 字体辅助色
    open class var mainText_4: UIColor {
        return UIColor.main_string("#ff0000")
    }
    ///第5字色 -- 字体辅助色
    open class var mainText_5: UIColor {
        return UIColor.main_string("#15cd48")
    }
    
    ///按钮不可点
    open class var main_btnNotEnb: UIColor {
        return UIColor.main_string("#b2b2b2")
    }
    ///按钮不可点
    open class var main_btnNormal: UIColor {
        return UIColor.main_string("#5c86ff")
    }
    ///按钮不可点
    open class var main_btnSelect: UIColor {
        return UIColor.main_string("#2860ff")
    }
    
    ///背景色
    open class var main_bg: UIColor {
        //对应调色板上的银白
        return UIColor.main_string("#f2f2f2")
    }
    ///线条颜色
    open class var main_line: UIColor {
        return UIColor.main_string("#cccccc")
    }
    
    
    ///警告颜色
    open class var main_warning: UIColor {
        return UIColor(red: 255/255, green: 254/255, blue: 102/255, alpha: 1)
    }
    
    ///字体颜色 铅黑 #191919
    open class var maintext_leadblack: UIColor {
        return UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha:1)
    }
    ///字体颜色 雅黑#333333
    open class var maintext_inkblack: UIColor {
        return UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha:1)
    }
    ///字体颜色 钨黑#424242
    open class var maintext_pitchblack: UIColor {
        return UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha:1)
    }
    ///字体颜色 深灰
    open class var maintext_darkgray: UIColor {
        return UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha:1)
    }
    ///字体颜色 浅灰
    open class var maintext_lightgray: UIColor {
        return UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1)
    }
    ///通过16进制值转换
    open class func main_int(_ rgb: Int) -> UIColor {
        return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                       alpha: 1.0)
    }
    ///通过16进制值转换
    open class func main_string(_ string: String) -> UIColor {
        var cString: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        guard cString.hasPrefix("#") else {
            return UIColor.white
        }
        guard cString.characters.count == 7 else {
            return UIColor.white
        }
        //这是string的一个扩展需要在String扩展中找
        cString = cString[1..<7]
        let rString = cString[0..<2]
        let gString = cString[2..<4]
        let bString = cString[4..<6]
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
        
    }
    
}
