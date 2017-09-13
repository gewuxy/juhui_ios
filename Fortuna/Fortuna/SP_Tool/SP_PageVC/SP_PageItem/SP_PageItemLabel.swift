//
//  SP_PageItemLabel.swift
//  carpark
//
//  Created by 刘才德 on 2016/12/30.
//  Copyright © 2016年 Friends-Home. All rights reserved.
//

import UIKit

class SP_PageItemLabel: UILabel {

    var scale : CGFloat = 0 {
        didSet {
            // 通过scale的改变来改变各种参数
            if _selectedColor != _normalColor {
            
                // 通过scale的不断改变来改变控件 textLabel 视觉效果
                let r = _normalRed + (_selectedRed - _normalRed) * scale
                let g = _normalGreen + (_selectedGreen - _normalGreen) * scale
                let b = _normalBlue + (_selectedBlue - _normalBlue) * scale
                let a = _normalAlpha + (_selectedAlpha - _normalAlpha) * scale
                textColor = UIColor(red: r, green: g, blue: b, alpha: a)
            }
            let minScale : CGFloat = normalTextFont / selectedTextFont
            let trueScale = minScale + (1 - minScale) * scale
            transform = CGAffineTransform(scaleX: trueScale, y: trueScale)
            
            //底部线条效果
//            let minScale2 : CGFloat = 0
//            let trueScale2 = minScale2 + (1.0 - minScale2) * scale
//            bottomLine.transform = CGAffineTransform(scaleX: trueScale2, y: 1.0)
        }
    }
    
    private var _selectedRed:CGFloat   = 0.0
    private var _selectedGreen:CGFloat = 0.0
    private var _selectedBlue:CGFloat  = 0.0
    private var _selectedAlpha:CGFloat = 0.0
    private var _normalRed:CGFloat     = 0.0
    private var _normalGreen:CGFloat   = 0.0
    private var _normalBlue:CGFloat    = 0.0
    private var _normalAlpha:CGFloat   = 0.0
    private var _selectedColor: UIColor?
    private var _normalColor: UIColor?
    
    ///选中颜色
    var selectedColor:UIColor {
        set{
            _selectedColor = newValue
            _selectedColor?.getRed(&_selectedRed, green: &_selectedGreen, blue: &_selectedBlue, alpha: &_selectedAlpha)
            
            bottomLine.backgroundColor = newValue
        }
        get{
            return _selectedColor ?? UIColor.black
        }
    }
    ///未选中颜色
    var normalColor:UIColor {
        set{
            _normalColor = newValue
            _normalColor?.getRed(&_normalRed, green: &_normalGreen, blue: &_normalBlue, alpha: &_normalAlpha)
            
            //verticalLine.backgroundColor = newValue
        }
        get{
            return _normalColor ?? UIColor.gray
        }
    }
    ///选中字体大小
    var selectedTextFont: CGFloat = 17
    
    ///未选中字体大小
    var normalTextFont: CGFloat = 16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textAlignment = .center
        textColor = UIColor.white
        //self.backgroundColor = UIColor.white
        
        //self.addSubview(bottomLine)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    lazy var bottomLine:UIView = {
        let view = UIView()
        view.backgroundColor = self.selectedColor
        view.layer.cornerRadius = 1.0
        view.clipsToBounds = true
        return view
    }()
    
    lazy var verticalLine:UIView = {
        let view = UIView()
        
        return view
    }()

}
