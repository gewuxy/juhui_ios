//
//  UITextField_extension.swift
//  IEXBUY
//
//  Created by 刘才德 on 2016/11/3.
//  Copyright © 2016年 IEXBUY. All rights reserved.
//
import UIKit
import Foundation

enum UITextDelegateType {
    case tBegin
    case tChange
    case tEnd
    
}
enum UITextLimitErrorType {
    case tNormal
    case tOutRange
    case tUnlawful
}

//MARK:---- UITextField
extension UITextField {
    
    func showOkButton() {
        let toolBar = UIToolbar(frame: CGRect(x: 0,y: 0, width: sp_ScreenWidth,height: 25))
        toolBar.backgroundColor = UIColor.main_bg
        let button = UIButton(frame: CGRect(x: sp_ScreenWidth - 40,y: 0,width: 40,height: 25))
        button.setTitle("完成", for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(UIColor.main_1, for: .normal)
        button.addTarget(self, action: #selector(UITextField.resignFirstResponder), for: .touchUpInside)
        toolBar.addSubview(button)
        self.inputAccessoryView = toolBar
    }
    
    
    //MARK:---------- 价格类
    func sp_limitForPrice(_ range: NSRange,  string: String, stringLength:Int = 7, errorType:((UITextLimitErrorType) ->Void)? = nil ) -> Bool {
        print("-->\(string)")
        
        if Int(string) == nil && string != "." && string != ""{
            errorType?(.tUnlawful)
            return false
        }
        // -1- 限制首字
        if self.text == "" &&  string == "."{
            errorType?(.tUnlawful)
            return false
        }
        // -2- 判断首字为 0 的情况， 再次输入不为 . 替换
        if self.text == "0" &&  string != "."{
            self.text = string
            errorType?(.tUnlawful)
            return false
        }
        // -3- 排除 (0123456789.退格) 之外的字符
        let remin = 2
        let pointRange = self.text?.range(of: ".")
        if ( pointRange != nil )
        {
            switch string {
            case "0","1","2","3","4","5","6","7","8","9","":
                // -4- 限制只能保留到小数点后2位
                if string != "" {
                    let textRange = Range(pointRange!.lowerBound..<self.text!.endIndex)
                    let subStr = self.text!.substring(with: textRange)
                    
                    if subStr.characters.count > remin {
                        return false  // 超出小数后两位
                    }
                    // -5- 限制长度
                    if (range.location >= stringLength + 3) {
                        errorType?(.tOutRange)
                        return false
                    }
                }
                errorType?(.tNormal)
                return true
            default:
                errorType?(.tUnlawful)
                return false // -- 输入非法字符
            }
        }
        else
        {
            switch string {
            case "0","1","2","3","4","5","6","7","8","9",".","":
                // -5- 限制长度
                if (range.location >= stringLength) {
                    errorType?(.tOutRange)
                    return false
                }
                errorType?(.tNormal)
                return true
            default:
                errorType?(.tUnlawful)
                return false  // -- 输入非法字符
            }
        }
    }

    
    //MARK:---------- 纯数字类
    func sp_limitForNumbers(_ range: NSRange,  string: String, firstcanfor0:Bool = false, stringLength:Int = 7, errorType:((UITextLimitErrorType) ->Void)? = nil ) -> Bool {
        // -1- 限制首字
        if Int(string) == nil && string != "" {
            errorType?(.tUnlawful)
            return false
        }
        if self.text == "" &&  string == "."{
            return false
        }
        // -2- 判断首字为 0 的情况， 再次输入不为 . 替换
        if !firstcanfor0 {
            if self.text == "0" &&  string != "."{
                self.text = string
                return false
            }
            if range.location == 0 && string == "0" && !self.text!.isEmpty{
                return false
            }
        }
        // -2- 排除 (0123456789退格) 之外的字符
        switch string {
        case "0","1","2","3","4","5","6","7","8","9","":
            // -3- 限制长度
            if (range.location >= stringLength) {
                errorType?(.tOutRange)
                return false
            }
            errorType?(.tNormal)
            return true
        default:
            errorType?(.tUnlawful)
            return false // -- 输入非法字符
        }
    }
    
    //MARK:---------- 纯字母类
    func sp_limitForABC(_ range: NSRange,  string: String, stringLength:Int = 16, errorType:((UITextLimitErrorType) ->Void)? = nil ) -> Bool {
        print("-->\(string)")
        // -1- 排除 (abc--XYZ退格) 之外的字符
        switch string {
        case "","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z":
            // -2- 限制长度
            if (range.location >= stringLength) {
                errorType?(.tOutRange)
                return false
            }
            errorType?(.tNormal)
            return true
        default:
            errorType?(.tUnlawful)
            return false // -- 输入非法字符
        }
    }
    
    //MARK:---------- 密码类
    func sp_limitForPwd(_ range: NSRange,  string: String, stringLength:Int = 16, errorType:((UITextLimitErrorType) ->Void)? = nil ) -> Bool {
        // -1- 排除 (abc--XYZ退格) 之外的字符
        switch string {
        case "","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","0","1","2","3","4","5","6","7","8","9","_":
            // -2- 限制长度
            if (range.location >= stringLength) {
                errorType?(.tOutRange)
                return false
            }
            errorType?(.tNormal)
            return true
        default:
            errorType?(.tUnlawful)
            return false // -- 输入非法字符
        }
    }
    
    
    //MARK:---------- 限制长度
    func sp_limitForRange(_ range: NSRange, stringLength:Int = 30, errorType:((UITextLimitErrorType) ->Void)? = nil ) -> Bool {
        return sp_limitTextForRange(range, stringLength: stringLength) { (type) in
            errorType?(type)
        }
    }
}
//MARK:---- UITextView
extension UITextView {
    func showOkButton() {
        let toolBar = UIToolbar(frame: CGRect(x: 0,y: 0, width: sp_ScreenWidth,height: 25))
        toolBar.backgroundColor = UIColor.main_bg
        let button = UIButton(frame: CGRect(x: sp_ScreenWidth - 40,y: 0,width: 40,height: 25))
        button.setTitle("完成", for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(UIColor.main_1, for: .normal)
        button.addTarget(self, action: #selector(UITextView.resignFirstResponder), for: .touchUpInside)
        toolBar.addSubview(button)
        self.inputAccessoryView = toolBar
    }
    
    //MARK:---------- 限制长度
    func sp_limitForRange(_ range: NSRange, stringLength:Int = 300, errorType:((UITextLimitErrorType) ->Void)? = nil ) -> Bool {
        return sp_limitTextForRange(range, stringLength: stringLength) { (type) in
            errorType?(type)
        }
    }
}


extension UITextView:UITextViewDelegate {
    
    static var sendBlock:((_ type:UITextDelegateType)->Void)?
    public func textViewDidBeginEditing(_ textView: UITextView) {
        UITextView.sendBlock?(.tBegin)
    }
    public func textViewDidChange(_ textView: UITextView) {
        UITextView.sendBlock?(.tChange)
    }
    public func textViewDidEndEditing(_ textView: UITextView) {
        UITextView.sendBlock?(.tEnd)
    }
    
    
}

//MARK:---------- 限制长度
fileprivate func sp_limitTextForRange(_ range: NSRange, stringLength:Int = 300, errorType:((UITextLimitErrorType) ->Void)? = nil ) -> Bool {
    
    if (range.location >= stringLength) {
        errorType?(.tOutRange)
        return false
    }
    errorType?(.tNormal)
    return true
}
