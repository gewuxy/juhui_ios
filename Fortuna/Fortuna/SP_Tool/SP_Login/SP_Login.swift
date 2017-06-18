//
//  SP_Login.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/12.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import YYKeyboardManager

enum SP_LoginType {
    case tFirst
    case tNormal
}


class SP_Login: SP_ParentVC {

    var _isOkBlock:((Bool)->Void)?
    lazy var _loginType = SP_LoginType.tNormal
    lazy var _keyBoardHeightRatio:CGFloat = 1.7
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var lab_error: UILabel!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var btn_signin: UIButton!
    @IBOutlet weak var btn_forgetPwd: UIButton!
    @IBOutlet weak var btn_Wx: UIButton!
    @IBOutlet weak var btn_QQ: UIButton!
    
    @IBOutlet weak var view_phone: UIView!
    @IBOutlet weak var view_pwd: UIView!
    
    
    @IBOutlet weak var img_logo_T: NSLayoutConstraint!
    @IBOutlet weak var img_logo_B: NSLayoutConstraint!
    @IBOutlet weak var btn_login_T: NSLayoutConstraint!
    @IBOutlet weak var view_other_T: NSLayoutConstraint!
    
    
    lazy var _text_pwd:SP_TextField = {
        let text = SP_TextField.show(self.view_pwd)
        text.text_field.placeholder = "请输入有效的手机号"
        text.button_L.setImage(UIImage(named:"navi_search_gray"), for: .normal)
        text.button_R.setImage(UIImage(named:"navi_search_gray"), for: .normal)
        
        return text
    }()
    lazy var _text_phone:SP_TextField = {
        let text = SP_TextField.show(self.view_phone)
        text.text_field.placeholder = "请输入密码"
        text.button_L.setImage(UIImage(named:"navi_search_gray"), for: .normal)
        text.button_R.setImage(UIImage(named:"navi_search_gray"), for: .normal)
        
        return text
    }()
    
}

extension SP_Login {
    override class func initSPVC() -> SP_Login {
        return UIStoryboard(name: "SP_Login", bundle: nil).instantiateViewController(withIdentifier: "SP_Login") as! SP_Login
    }
    
    class func show(_ parentVC:UIViewController?, type:SP_LoginType = .tNormal, animated:Bool = true, block: ((Bool) -> Void)? = nil) {
        let vc = SP_Login.initSPVC()
        vc._isOkBlock = block
        vc._loginType = type
        let navi = UINavigationController(rootViewController: vc)
        parentVC?.present(navi, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigatin()
        makeUI()
        makeRx()
        makeTextFieldDelegate()
        showKeyboard()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    override func clickN_btn_L1() {
        self.dismiss(animated: true) { 
            
        }
    }
    fileprivate func makeNavigatin(){
        n_view._title = "登录"
    }
    fileprivate func makeUI() {
        if SP_InfoOC.sp_deviceModel() == tiPhone4 {
            img_logo_T.constant = 15
            img_logo_B.constant = 15
            btn_login_T.constant = 15
            view_other_T.constant = 15
            _keyBoardHeightRatio = 2.0
        }
    }
    fileprivate func makeTextFieldDelegate() {
        _text_phone._shouldChangeCharactersBlock = { [weak self](textField,range,str) -> Bool in
            let bool = textField.sp_limitForNumbers(range,string: str, stringLength: 11, errorType:{ [weak self]type in
                switch type {
                case .tOutRange:
                    break
                case .tUnlawful:
                    self?.lab_error.text = "*请输入正确的手机号"
                case .tNormal:
                    self?.lab_error.text = ""
                }
            })
            return bool
        }
        _text_pwd._shouldChangeCharactersBlock = { [weak self](textField,range,str) -> Bool in
            let bool = textField.sp_limitForPwd(range, string: str, stringLength: 16, errorType: { (type) in
                switch type {
                case .tOutRange:
                    break
                case .tUnlawful:
                    self?.lab_error.text = "*密码限6~16位字母、数字、_"
                case .tNormal:
                    self?.lab_error.text = ""
                }
            })
            return bool
        }
        
        
    }
    fileprivate func makeRx(){
        let phoneValid_1 = _text_phone.text_field.rx.text.map { $0?.characters.count == 0 }.shareReplay(1)
        
        let phoneValid_2 = _text_phone.text_field.rx.text.map { $0?.characters.count == 11 }.shareReplay(1)
        
        let pwdValid = _text_pwd.text_field.rx.text.map { $0!.characters.count <= 16 && $0!.characters.count >= 6 }.shareReplay(1)
        
        let allValid = Observable.combineLatest(phoneValid_2, pwdValid) { $0 && $1 }.shareReplay(1)
        
        phoneValid_1
            .asObservable()
            .subscribe(onNext: { [weak self](isOk) in
                self?._text_phone.button_R_W.constant = isOk ? 0 : 30
                self?._text_phone.button_R.isHidden = isOk
        }).addDisposableTo(disposeBag)
        
        allValid
            .asObservable()
            .subscribe(onNext: { [weak self](isOk) in
                self?.btn_login.isEnabled = isOk
                self?.btn_login.backgroundColor = isOk ? UIColor.main_3 : UIColor.main_btnNotEnb
            }).addDisposableTo(disposeBag)
        
        
        
        btn_login.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self](isOK) in
                self.clickLogin()
            }).addDisposableTo(disposeBag)
        
        btn_signin.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self](isOK) in
                self.clickSignin()
            }).addDisposableTo(disposeBag)
        
        btn_forgetPwd.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self](isOK) in
                self.clickForgetPwd()
            }).addDisposableTo(disposeBag)
        
        btn_Wx.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self](isOK) in
                self.clickWeiXin()
            }).addDisposableTo(disposeBag)
        
        btn_QQ.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self](isOK) in
                self.clickQQ()
            }).addDisposableTo(disposeBag)
        
    }
    
    
    
    //MARK:--- 登录 -----------------------------
    fileprivate func clickLogin()  {
        
    }
    //MARK:--- 微信登录 -----------------------------
    fileprivate func clickWeiXin()  {
        
    }
    //MARK:--- QQ登录 -----------------------------
    fileprivate func clickQQ()  {
        
    }
    //MARK:--- 注册 -----------------------------
    fileprivate func clickSignin() {
        SP_Signin.show(self, type: .t注册) { (isOk) in
            
        }
    }
    //MARK:--- 忘记密码 -----------------------------
    fileprivate func clickForgetPwd() {
        SP_Signin.show(self, type: .t忘记密码) { (isOk) in
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:--- 键盘
    fileprivate func showKeyboard(){
        sp_Notification.rx
            .notification(sp_ntfNameKeyboardWillShow, object: nil)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](n) in
                self?.keyBoardWillShow(n)
            })
            .addDisposableTo(disposeBag)
        sp_Notification.rx
            .notification(sp_ntfNameKeyboardWillHide, object: nil)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](n) in
                self?.keyBoardWillHide(n)
            })
            .addDisposableTo(disposeBag)
    }
    
    
    @objc private func keyBoardWillShow(_ note:Notification) {
        let userInfo  = note.userInfo
        let keyBoardBounds = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        _ = self.view.convert(keyBoardBounds, to:nil)
        
        _ = self.view.frame
        
        let _keyBoardHeight = keyBoardBounds.size.height
        
        let animations:(() -> Void) = {
            self.view.transform = CGAffineTransform(translationX: 0,y: -_keyBoardHeight/self._keyBoardHeightRatio)
            
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            
            animations()
        }
    }
    
    @objc private func keyBoardWillHide(_ note:Notification)
    {
        
        let userInfo  = note.userInfo
        
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let animations:(() -> Void) = {
            self.view.transform = .identity
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            
            animations()
        }
        
        
    }
}
