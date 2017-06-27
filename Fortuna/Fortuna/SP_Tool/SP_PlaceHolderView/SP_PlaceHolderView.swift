//
//  SP_PlaceHolderView.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/27.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class SP_PlaceHolderView: UIView {

    static func show() -> SP_PlaceHolderView {
        let view = (Bundle.main.loadNibNamed("SP_PlaceHolderView", owner: nil, options: nil)!.first as? SP_PlaceHolderView)!
        return view
    }

    @IBOutlet weak var btn_Image: UIButton!
    @IBOutlet weak var btn_title: UIButton!
    @IBOutlet weak var lab_title: UILabel!
    @IBOutlet weak var lab_detalTitle: UILabel!
    
    @IBOutlet weak var lab_title_T: NSLayoutConstraint!
    @IBOutlet weak var lab_detalTitle_T: NSLayoutConstraint!
    @IBOutlet weak var btn_title_T: NSLayoutConstraint!
    @IBOutlet weak var btn_Image_T: NSLayoutConstraint!
    
    var _imgBlock:(()->Void)?
    var _titleBlock:(()->Void)?
    var _tapBlock:(()->Void)?
    @IBAction func clickButton(_ sender: UIButton) {
        switch sender {
        case btn_title:
            _titleBlock?()
        case btn_Image:
            _imgBlock?()
        default:
            break
        }
        
    }
    @IBAction func clickTap(_ sender: UITapGestureRecognizer) {
        _tapBlock?()
    }
    
}
