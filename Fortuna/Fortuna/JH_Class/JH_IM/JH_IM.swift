//
//  JH_IM.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/27.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class JH_IM: SP_ParentVC {

    
    @IBOutlet weak var view_Top: UIView!
    @IBOutlet weak var view_Tab: UIView!
    @IBOutlet weak var view_Bot: UIView!
    @IBOutlet weak var view_Bot_H: NSLayoutConstraint!
    @IBOutlet weak var view_Bot_B: NSLayoutConstraint!

    fileprivate lazy var _tableView:SP_IM_Tab = {
        let view = SP_IM_Tab.show(self.view_Tab)
        return view
    }()
    
    fileprivate lazy var _inputView:SP_IM_Input = {
        let view = SP_IM_Input.show(self.view_Bot)
        return view
    }()

}

extension JH_IM {
    override class func initSPVC() -> JH_IM {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_IM") as! JH_IM
    }
    static func show(_ parentVC:UIViewController?) {
        let vc = JH_IM.initSPVC()
        vc.hidesBottomBarWhenPushed = true
        parentVC?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigation()
        makeUI()
        makeTextInput()
    }
    fileprivate func makeNavigation() {
        
    }
    fileprivate func makeUI() {
        
    }
    
    
}
extension JH_IM {
    fileprivate func makeTextInput(){
        _inputView._block = { [weak self](type,text) in
            
        }
        _inputView._heightBlock = { [weak self](type,height) in
            switch type {
            case .tH:
                self?.view_Bot_H.constant = height
            case .tB:
                self?.view_Bot_B.constant = height
            }
        }
    }
}
extension JH_IM {
    fileprivate func makeTableViewDelegate() {
        _tableView._numberOfSections = { _ -> Int in
            return 1
        }
    }
}
