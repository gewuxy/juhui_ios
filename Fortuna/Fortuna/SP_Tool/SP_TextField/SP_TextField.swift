//
//  SP_LoginView.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/6.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit


class SP_TextField: UIView {

    class func show(_ supView:UIView) -> SP_TextField {
        for item in supView.subviews {
            if let sub = item as? SP_TextField {
                return sub
            }
        }
        let view = (Bundle.main.loadNibNamed("SP_TextField", owner: nil, options: nil)!.first as? SP_TextField)!
        supView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        text_field.showOkButton()
        text_field.delegate = self
        view_Line.backgroundColor = UIColor.main_line
        text_field.tintColor = UIColor.main_1
    }
    
    enum SP_TextField_Type {
        case tBegin
        case tChange
        case tEnd
        case tReturn
    }
    
    @IBOutlet weak var label_L: UILabel!
    
    @IBOutlet weak var label_error: UILabel!
    
    @IBOutlet weak var button_L: UIButton!
    @IBOutlet weak var button_R: UIButton!
    @IBOutlet weak var button_L_W: NSLayoutConstraint!
    @IBOutlet weak var button_R_W: NSLayoutConstraint!
    @IBOutlet weak var button_L_H: NSLayoutConstraint!
    @IBOutlet weak var button_R_H: NSLayoutConstraint!
    
    @IBOutlet weak var text_field: UITextField!
    @IBOutlet weak var text_field_L: NSLayoutConstraint!
    @IBOutlet weak var text_field_R: NSLayoutConstraint!
    
    @IBOutlet weak var view_textBg: UIView!
    @IBOutlet weak var view_textBg_L: NSLayoutConstraint!
    @IBOutlet weak var view_textBg_R: NSLayoutConstraint!
    
    @IBOutlet weak var view_Line: UIView!
    @IBOutlet weak var view_Line_L: NSLayoutConstraint!
    @IBOutlet weak var view_Line_R: NSLayoutConstraint!
    
    var _block:((_ type:SP_TextField_Type, _ text:String)->Void)?
    var _shouldChangeCharactersBlock:((_ textField: UITextField, _ range: NSRange, _ string: String)->Bool)?
    var _shouldReturnBlock:((_ textField: UITextField)->Bool)?
    var _shouldClearBlock:((_ textField: UITextField)->Bool)?
    @IBAction func begin(_ sender: UITextField) {
        _block?(.tBegin,sender.text!)
    }
    @IBAction func changed(_ sender: UITextField) {
        _block?(.tChange,sender.text!)
    }
    @IBAction func end(_ sender: UITextField) {
        _block?(.tEnd,sender.text!)
    }
    
}

extension SP_TextField:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return _shouldReturnBlock?(textField) ?? true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        return _shouldClearBlock?(textField) ?? true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return _shouldChangeCharactersBlock?(textField,range,string) ?? true
    }
}
