//
//  SP_HUD.swift
//  iexbuy
//
//  Created by 刘才德 on 2016/11/10.
//  Copyright © 2016年 Friends-Home. All rights reserved.
//
/**
 *这是自己写的HUD类
 *
 *
 */

import UIKit
import MBProgressHUD
import SVProgressHUD
enum SP_HUDBG {
    case tME
    case tMB
    case tSV
}
enum SP_HUDType {
    case tNone
    case tLoading
    case tSuccess
    case tInfo
    case tError
    case tProgress
    case tBg
}
class SP_HUD: UIView {

    static func shows(_ supView:(UIView,Bool) = (sp_MainWindow,false),
                    type:SP_HUDType = .tBg,
                    text:String = "",
                    textMake:(UIColor,(Int,Int),UIColor) = (UIColor.mainText_1,(0,0),UIColor.main_1),
                    block:(()->Void)? = nil) {
        for item in supView.0.subviews {
            if let view = item as? SP_HUD {
                view.isHidden = supView.1
                view._block = block
                view.makeText(text, textMake: textMake)
                return
            }
        }
        let view = (Bundle.main.loadNibNamed("SP_HUD_Bg", owner: nil, options: nil)!.first as? SP_HUD)!
        supView.0.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        view.makeText(text, textMake: textMake)
        view.isHidden = supView.1
        
        view._block = block
        
    }
    var _block:(()->Void)?
    @IBOutlet weak var image_bg: UIImageView!

    @IBOutlet weak var label_text: UILabel!
    
    @IBAction func textClick(_ sender: UIButton) {
        _block?()
    }
    
    func makeText(_ text:String,textMake:(UIColor,(Int,Int),UIColor)) {
        label_text.text = text
        label_text.textColor = textMake.0
        
        let textt = text
        let attributedString = NSMutableAttributedString(string: textt)
        attributedString.addAttributes([NSForegroundColorAttributeName : UIColor.main_1], range: NSMakeRange(textMake.1.0, textMake.1.1))
        label_text.attributedText = attributedString
    }
    
    
    
    
    
    
}

extension SP_HUD {
    static func show(_ bg:SP_HUDBG = .tMB,view:UIView = sp_MainWindow, type:SP_HUDType = .tNone, text:String = "", detailText:String="", image:String = "", time:TimeInterval = 20, block:(()->Void)? = nil) {
        switch bg {
        case .tMB:
            SP_MBHUD.showHUD(view: view, type: type, text: text, detailText: detailText, image: image, time: time) {
                block?()
            }
        case .tSV:
            SP_SVHUD.show(type, text:text, time:time, block:{
                block?()
            })
        default:
            break
        }
        
    }
}


