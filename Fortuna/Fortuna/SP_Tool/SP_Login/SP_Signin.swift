//
//  SP_Signin.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/12.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum SP_SigninType {
    case t注册
    case t忘记密码
}

class SP_Signin: SP_ParentVC {
    
    var _isOkBlock:((Bool,String,String)->Void)?
    lazy var _vcType = SP_SigninType.t注册
    lazy var _keyBoardHeightRatio:CGFloat = 1.7
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var lab_error: UILabel!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var btn_agreement: UIButton!
    @IBOutlet weak var btn_agreementSelect: UIButton!
    @IBOutlet weak var lab_agreement: UILabel!
    
    @IBOutlet weak var view_phone: UIView!
    @IBOutlet weak var view_pwd: UIView!
    @IBOutlet weak var view_verification: UIView!
    @IBOutlet weak var view_agreement: UIView!
    
    @IBOutlet weak var img_logo_T: NSLayoutConstraint!
    @IBOutlet weak var img_logo_B: NSLayoutConstraint!
    @IBOutlet weak var btn_login_T: NSLayoutConstraint!
    
    
    
    lazy var _text_phone:SP_TextField = {
        let text = SP_TextField.show(self.view_phone)
        text.text_field.placeholder = sp_localized("手机号",from: "SP_Login")
        text.text_field.textColor = UIColor.mainText_1
        text.text_field.keyboardType = .phonePad
        //text.text_field.showOkButton()
        text.button_L.setImage(UIImage(named:"sp_login手机"), for: .normal)
        text.button_R.setImage(UIImage(named:"sp_login删除"), for: .normal)
        text.text_field_L.constant = 15
        text.text_field_R.constant = 15
        text.view_Line_L.constant = 5
        text.view_Line_R.constant = 5
        
        return text
    }()
    lazy var _text_pwd:SP_TextField = {
        let text = SP_TextField.show(self.view_pwd)
        text.text_field.placeholder = sp_localized("密码",from: "SP_Login")
        text.text_field.textColor = UIColor.mainText_1
        text.text_field.keyboardType = .asciiCapable
        text.text_field.isSecureTextEntry = true
        text.button_L.setImage(UIImage(named:"sp_login密码"), for: .normal)
        text.button_R.setImage(UIImage(named:"sp_login闭眼"), for: .selected)
        text.button_R.setImage(UIImage(named:"sp_login可见"), for: .normal)
        text.button_R.isSelected = true
        text.backgroundColor = UIColor.clear
        text.text_field_L.constant = 15
        text.text_field_R.constant = 15
        text.view_Line_L.constant = 5
        text.view_Line_R.constant = 5
        
        return text
    }()
    lazy var _text_verifi:SP_TextField = {
        let text = SP_TextField.show(self.view_verification)
        text.text_field.placeholder = sp_localized("请输入验证码",from: "SP_Login")
        text.text_field.textColor = UIColor.mainText_1
        text.text_field.keyboardType = .decimalPad
        //text.text_field.showOkButton()
        text.button_R.setTitle(sp_localized("发送验证码",from: "SP_Login"),for:.normal)
        text.button_R.setTitleColor(UIColor.mainText_2,for:.normal)
        text.button_R.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        text.button_R.layer.cornerRadius = 6.0
        text.button_R.clipsToBounds = true
        text.button_R.backgroundColor = UIColor.main_string("#e5e5e5")
        text.button_R_W.constant = 100
        text.button_L_W.constant = 0
        text.text_field_L.constant = 0
        return text
    }()
}

extension SP_Signin {
    
    override class func initSPVC() -> SP_Signin {
        return UIStoryboard(name: "SP_Login", bundle: nil).instantiateViewController(withIdentifier: "SP_Signin") as! SP_Signin
    }
    
    class func show(_ parentVC:UIViewController?, type:SP_SigninType = .t注册, block: ((Bool,String,String) -> Void)? = nil) {
        let vc = SP_Signin.initSPVC()
        vc._isOkBlock = block
        vc._vcType = type
        parentVC?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigatin()
        makeUI()
        makeRx()
        makeTextFieldDelegate()
        //showKeyboard()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyBoardHidden()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    override func clickN_btn_R1() {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    fileprivate func makeNavigatin(){
        n_view.backgroundColor = UIColor.clear
        n_view.n_view_NaviLine.isHidden = true
        n_view._title = ""
        n_view.n_btn_L1_Image = ""
        n_view.n_btn_R1_Image = "sp_login叉"
        n_view.n_btn_R1_R.constant = 15
        
    }
    fileprivate func makeUI() {
        
        if SP_InfoOC.sp_deviceModel() == tiPhone4 {
            img_logo_T.constant = 68
            img_logo_B.constant = 15
            _keyBoardHeightRatio = 2.0
        }
        lab_agreement.text = sp_localized("注册代表您已同意",from: "SP_Login")
        btn_agreement.setTitle(sp_localized("用户协议",from: "SP_Login"), for: .normal)
        btn_login.setTitle(_vcType == .t注册 ? sp_localized("注  册",from: "SP_Login") : sp_localized("重置密码",from: "SP_Login"), for: .normal)
        view_agreement.isHidden = _vcType != .t注册
        btn_login_T.constant = _vcType == .t注册 ? 60 : 30
        
        view_phone.backgroundColor = UIColor.clear
        view_pwd.backgroundColor = UIColor.clear
        view_verification.backgroundColor = UIColor.clear
        view_agreement.backgroundColor = UIColor.clear
        
        //btn_agreementSelect.setImage(UIImage(named:"sp_login没选中"), for: .normal)
        //btn_agreementSelect.setImage(UIImage(named:"sp_login勾"), for: .selected)
        btn_agreementSelect.isSelected = true
    }
    fileprivate func makeTextFieldDelegate() {
        _text_phone._shouldChangeCharactersBlock = { [weak self](textField,range,str) -> Bool in
            let bool = textField.sp_limitForNumbers(range,string: str, stringLength: 11, errorType:{ [weak self]type in
                switch type {
                case .tOutRange:
                    break
                case .tUnlawful:
                    self?.lab_error.text = sp_localized("*请输入正确的手机号",from: "SP_Login")
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
                    self?.lab_error.text = sp_localized("*密码限6~16位字母、数字、_",from: "SP_Login")
                case .tNormal:
                    self?.lab_error.text = ""
                }
            })
            return bool
        }
        
        _text_verifi._shouldChangeCharactersBlock = { [weak self](textField,range,str) -> Bool in
            let bool = textField.sp_limitForNumbers(range, string: str, stringLength: 6, errorType: { (type) in
                switch type {
                case .tOutRange:
                    break
                case .tUnlawful:
                    self?.lab_error.text = sp_localized("*请输入正确的验证码",from: "SP_Login")
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
        let verifiValid = _text_verifi.text_field.rx.text.map { $0!.characters.count > 0 }.shareReplay(1)
        
        let allValid = Observable.combineLatest(phoneValid_2, pwdValid,verifiValid) { $0 && $1 && $2}.shareReplay(1)
        
        phoneValid_1
            .asObservable()
            .subscribe(onNext: { [weak self](isOk) in
                self?._text_phone.button_R_W.constant = isOk ? 0 : 30
                self?._text_phone.button_R.isHidden = isOk
            }).addDisposableTo(disposeBag)
        phoneValid_2
            .asObservable()
            .subscribe(onNext: { [weak self](isOk) in
                self?._text_verifi.button_R.isEnabled = isOk
                self?._text_verifi.button_R.setTitleColor(isOk ? UIColor.mainText_2 : UIColor.mainText_3, for: .normal)
            }).addDisposableTo(disposeBag)
        
        allValid
            .asObservable()
            .subscribe(onNext: { [weak self](isOk) in
                self?.btn_login.isEnabled = isOk
                self?.btn_login.backgroundColor = isOk ? UIColor.main_btnNormal : UIColor.main_btnNotEnb
            }).addDisposableTo(disposeBag)
        
        _text_phone.button_R.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self](isOK) in
                self._text_phone.text_field.text = ""
                self._text_phone.text_field.becomeFirstResponder()
            }).addDisposableTo(disposeBag)
        _text_pwd.button_R.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self](isOK) in
                self._text_pwd.button_R.isSelected = !self._text_pwd.button_R.isSelected
                self._text_pwd.text_field.isSecureTextEntry = self._text_pwd.button_R.isSelected
            }).addDisposableTo(disposeBag)
        
        btn_login.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self](isOK) in
                self.clickLogin()
            }).addDisposableTo(disposeBag)
        _text_verifi.button_R.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self](isOK) in
                self.clickVerifi()
            }).addDisposableTo(disposeBag)
        btn_agreement.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self](isOK) in
                self.clickAgreement()
            }).addDisposableTo(disposeBag)
        
    }
    func makeEnabled(_ bool:Bool){
        btn_login.isEnabled = bool
        _text_phone.button_R.isEnabled = bool
        _text_phone.text_field.isEnabled = bool
        _text_pwd.text_field.isEnabled = bool
    }
    //MARK:--- 注册、忘记密码 -----------------------------
    fileprivate func clickLogin()  {
        keyBoardHidden()
        SP_HUD.show(view:self.view,type:.tLoading)
        makeEnabled(false)
        switch _vcType {
        case .t注册:
            
            SP_User.shared.signin((mobile: _text_phone.text_field.text!, pwd: _text_pwd.text_field.text!, code: _text_verifi.text_field.text!)) { [weak self](isOk, error) in
                self?.makeEnabled(true)
                if isOk {
                    SP_HUD.show(text:sp_localized("注册成功,正在登录",from: "SP_Login"))
                    
                    self?._isOkBlock?(true,self!._text_phone.text_field.text!,self!._text_pwd.text_field.text!)
                    self?.clickN_btn_R1()
                }else{
                    SP_HUD.show(detailText:error)
                }
            }
        case .t忘记密码:
            SP_User.shared.resetPwd((mobile: _text_phone.text_field.text!, pwd: _text_pwd.text_field.text!, code: _text_verifi.text_field.text!)) { [weak self](isOk, error) in
                self?.makeEnabled(true)
                if isOk {
                    SP_HUD.show(text:sp_localized("修改成功,重新登录",from: "SP_Login"))
                    
                    //self?._isOkBlock?(true,self!._text_phone.text_field.text!,self!._text_pwd.text_field.text!)
                    self?.clickN_btn_R1()
                }else{
                    SP_HUD.show(detailText:error)
                }
            }
        }
        
    }
    //MARK:--- 发送验证码 -----------------------------
    fileprivate func clickVerifi()  {
        keyBoardHidden()
        SP_HUD.show(view:self.view,type:.tLoading)
        SP_User.shared.sendSMS((mobile: _text_phone.text_field.text!, type: _vcType == .t注册 ? "1" : "2")) { (isOk, error) in
            if isOk {
                SP_HUD.show(detailText:sp_localized("验证码已发送,60秒后过期",from: "SP_Login"))
                SP_TimeSingleton.shared.starCountDown(self._text_verifi.button_R,countTime: 60,enabText: sp_localized("重新获取",from: "SP_Login"),enabledColor:(bg:self._text_verifi.button_R.backgroundColor!,text:UIColor.mainText_3))
            }else{
                SP_HUD.show(detailText:error)
            }
        }
    }
    
    
    //MARK:--- 用户协议 -----------------------------
    fileprivate func clickAgreement()  {
        keyBoardHidden()
    }
    
    
    //MARK:--- 键盘
    fileprivate func keyBoardHidden(){
        _text_phone.text_field.resignFirstResponder()
        _text_pwd.text_field.resignFirstResponder()
        _text_verifi.text_field.resignFirstResponder()
    }
    fileprivate func showKeyboard(){
        sp_Notification.rx
            .notification(sp_ntfNameKeyboardWillShow, object: nil)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](notification) in
                self?.keyBoardWillShow(notification)
            })
            .addDisposableTo(disposeBag)
        sp_Notification.rx
            .notification(sp_ntfNameKeyboardWillHide, object: nil)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](notification) in
                self?.keyBoardWillHide(notification)
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
