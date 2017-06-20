//
//  SP_TimeSingleton.swift
//  carpark
//
//  Created by 刘才德 on 2016/12/22.
//  Copyright © 2016年 Friends-Home. All rights reserved.
//

import Foundation

class SP_TimeSingleton {
    fileprivate static let sharedInstance = SP_TimeSingleton()
    fileprivate init() {}
    //提供静态访问方法
    open static var shared: SP_TimeSingleton {
        return self.sharedInstance
    }
    
    
    //MARK:--- 秒表倒计时
    fileprivate lazy var _timer:Timer? = {
        let tim = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(SP_TimeSingleton.timerClosure(_:)), userInfo: nil, repeats: true)
        return tim
    }()
    fileprivate lazy var _countTime:Int = {
        let time = 60
        return time
    }()
    fileprivate lazy var _time:Int = {
        let time = 0
        return time
    }()
    fileprivate lazy var _label:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    weak var _button:UIButton?
    fileprivate  var _title = ""
    fileprivate  var _normalColor:(bg:UIColor,text:UIColor)?
    fileprivate  var _enabledColor:(bg:UIColor,text:UIColor)?
    
    func starCountDown(_ button:UIButton, countTime:Int, enabledColor:(bg:UIColor,text:UIColor)? = nil) {
        
        _button = button
        _title = button.titleLabel!.text!
        _normalColor = (bg:button.backgroundColor!,text:button.titleLabel!.textColor)
        _enabledColor = (bg:button.backgroundColor!,text:button.titleLabel!.textColor)
        if enabledColor != nil {
            _enabledColor = enabledColor
        }
        _countTime = countTime
        _time = 0
        _button?.isEnabled = false
        
        
        //_button?.setTitle("", for: .normal)
        
        //_button?.tintColor = UIColor.clear
        //_button?.backgroundColor = _color
        
        //_label.text = "\(countTime)s 重新获取"
        
//        _button?.addSubview(_label)
//        _label.textColor = color.select
//        _label.font = button.titleLabel?.font
//        _label.frame = button.bounds
        
        makeLabelText(countTime)
        
        RunLoop.current.add(_timer!, forMode: .commonModes)
    }
    @objc private func timerClosure(_ timer: Timer) {
        _time += 1
        if _time >= _countTime{
            _timer?.invalidate()
            //_timer = nil
            
            
            //_button?.backgroundColor = _color
            //_button?.setTitle(_title, for: .normal)
            //_label.text = ""
            makeLabelText(0)
        }
        else{
            makeLabelText(_countTime - _time)
            //_label.text = "\(_countTime - _time)s 重新获取"
            
            //self.setTitle("\(_countTime - _time) 重新获取", for: .normal)
        }
    }
    
    func makeLabelText(_ time:Int) {
        guard time != 0 else {
            _button?.setTitleColor(_normalColor?.text, for: .normal)
            _button?.backgroundColor = _normalColor?.bg
            let textt = _title
            let attributedString = NSMutableAttributedString(string: textt)
            _button?.setAttributedTitle(attributedString, for: .normal)
            _button?.isEnabled = true
            return
        }
        _button?.setTitleColor(_enabledColor?.text, for: .normal)
        _button?.backgroundColor = _enabledColor?.bg
        let timeStr = String(format: "%d", time)
        let textt = "\(time)s 重新获取"
        let attributedString = NSMutableAttributedString(string: textt)
        
        attributedString.addAttributes([NSForegroundColorAttributeName : UIColor.main_1], range: NSMakeRange(0, timeStr.characters.count + 1))
        
        _button?.setAttributedTitle(attributedString, for: .normal)
        //_label.attributedText = attributedString
    }
    
}
