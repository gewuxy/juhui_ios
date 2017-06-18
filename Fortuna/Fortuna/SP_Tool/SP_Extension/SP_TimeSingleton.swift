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
    fileprivate lazy var _color:UIColor = {
        let color = UIColor.clear
        return color
    }()
    weak var _button:UIButton?
    
    
    
    
    func starCountDown(_ button:UIButton, countTime:Int, color:(normal:UIColor,select:UIColor)) {
        _button = button
        _color = color.normal
        _label.textColor = color.select
        _countTime = countTime
        _time = 0
        _button?.isEnabled = false
        _button?.isSelected = true
        _button?.tintColor = UIColor.clear
        _button?.backgroundColor = _color
        
        //_label.text = "\(countTime)s 重新获取"
        makeLabelText(countTime)
        _label.font = button.titleLabel?.font
        _button?.addSubview(_label)
        _label.frame = button.bounds
        _button?.setTitle("", for: .normal)
        RunLoop.current.add(_timer!, forMode: .commonModes)
    }
    @objc private func timerClosure(_ timer: Timer) {
        _time += 1
        if _time >= _countTime{
            _timer?.invalidate()
            //_timer = nil
            _button?.isEnabled = true
            _button?.isSelected = false
            _button?.backgroundColor = _color
            _button?.setTitle("点击获取验证码", for: .normal)
            _label.text = ""
        }
        else{
            makeLabelText(_countTime - _time)
            //_label.text = "\(_countTime - _time)s 重新获取"
            
            //self.setTitle("\(_countTime - _time) 重新获取", for: .normal)
        }
    }
    
    func makeLabelText(_ time:Int) {
        let timeStr = String(format: "%d", time)
        let textt = "\(time)s 重新获取"
        let attributedString = NSMutableAttributedString(string: textt)
        attributedString.addAttributes([NSForegroundColorAttributeName : UIColor.main_1], range: NSMakeRange(0, timeStr.characters.count + 1))
        
        _label.attributedText = attributedString
    }
    
}
