//
//  SP_HtmlEdit.swift
//  Fortuna
//
//  Created by LCD on 2017/8/22.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class SP_RichTextEdit: RichTextImageEditorBaseViewCtrl {

    


}

extension SP_RichTextEdit {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

//MARK:--- 键盘功能栏 ----------
fileprivate extension UITextView {
    func showToolbar() {
        let toolBar = UIToolbar(frame: CGRect(x: 0,y: 0, width: sp_ScreenWidth,height: 30))
        toolBar.backgroundColor = UIColor.main_bg
        
        let button = UIButton(frame: CGRect(x: sp_ScreenWidth - 40,y: 0,width: 40,height: 30))
        button.setTitle("完成", for: UIControlState())
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(UIColor.main_1, for: .normal)
        button.addTarget(self, action: #selector(UITextField.resignFirstResponder), for: .touchUpInside)
        toolBar.addSubview(button)
        
        self.inputAccessoryView = toolBar
        
    }
}
