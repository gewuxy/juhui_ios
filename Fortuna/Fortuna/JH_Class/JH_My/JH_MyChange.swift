//
//  JH_MyChange.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/20.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import IQKeyboardManager
class JH_MyChange: SP_ParentVC {

    @IBOutlet weak var text_field: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    enum JH_MyChangeType:String {
        case t昵称 = "昵称"
        case t电话号码 = "电话号码"
        var stringValue:String {
            switch self {
            case .t昵称:
                return sp_localized("昵称")
            case .t电话号码:
                return sp_localized("电话号码")
            }
        }
    }
    var _type:JH_MyChangeType = JH_MyChangeType.t昵称
    
    deinit {
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        
    }
    
}

extension JH_MyChange {
    override class func initSPVC() -> JH_MyChange {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_MyChange") as! JH_MyChange
    }
    class func show(_ parentVC:UIViewController?, type:JH_MyChangeType) {
        let vc = JH_MyChange.initSPVC()
        vc.hidesBottomBarWhenPushed = true
        vc._type = type
        parentVC?.navigationController?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigation()
        self.change()
    }
    
    fileprivate func makeNavigation() {
        self.n_view.n_btn_R1_Text = sp_localized("保存")
        self.n_view.n_btn_R1_R.constant = 15
        self.n_view._title = self._type.rawValue
        
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        self.text_field.text = SP_UserModel.read().nickname
        self.text_field.font = sp_fitFont18
        self.text_field.becomeFirstResponder()
        
    }
    override func clickN_btn_R1() {
        self.text_field.resignFirstResponder()
        self.url_用户信息修改()
    }
    fileprivate func url_用户信息修改() {
        SP_HUD.show(view: self.view, type: .tLoading)
        My_API.t_用户信息修改(nickname: self.text_field.text!, email: "", img_url: SP_UserModel.read().imgUrl).post(M_MyCommon.self) { [weak self](isOk, data, error) in
            SP_HUD.hidden()
            if isOk {
                SP_HUD.show(text:sp_localized("保存成功"))
                SP_User.shared.url_用户信息()
                _ = self?.navigationController?.popViewController(animated: true)
            }else{
                SP_HUD.show(text:error)
            }
        }
    }
    
    @IBAction func textChange(_ sender: UITextField) {
        self.change()
    }
    func change() {
        if text_field.text == SP_UserModel.read().nickname || text_field.text!.isEmpty {
            n_view.n_btn_R1.isHidden = true
        }else{
            n_view.n_btn_R1.isHidden = false
        }
    }
}

extension JH_MyChange:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
