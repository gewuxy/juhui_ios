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
    
    @IBOutlet weak var view_phone: UIView!
    @IBOutlet weak var view_pwd: UIView!
    
    @IBOutlet weak var img_logo_T: NSLayoutConstraint!
    @IBOutlet weak var img_logo_B: NSLayoutConstraint!
    @IBOutlet weak var btn_login_T: NSLayoutConstraint!
    
    @IBOutlet weak var view_other: UIView!
    
    @IBOutlet weak var lab_otherAccount: UILabel!
    @IBOutlet weak var btn_Wx: UIButton!
    @IBOutlet weak var btn_QQ: UIButton!
    
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
        self.dismiss(animated: true) {
            
        }
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
            btn_login_T.constant = 20
            _keyBoardHeightRatio = 2.0
        }
        
        view_phone.backgroundColor = UIColor.clear
        view_pwd.backgroundColor = UIColor.clear
        lab_otherAccount.backgroundColor = UIColor.main_bg
        lab_otherAccount.textColor = UIColor.mainText_3
        btn_signin.setTitleColor(UIColor.mainText_2, for: .normal)
        btn_forgetPwd.setTitleColor(UIColor.mainText_2, for: .normal)
        btn_login.setTitle(sp_localized("登  录",from: "SP_Login"), for: .normal)
        btn_signin.setTitle(sp_localized("新用户注册",from: "SP_Login"), for: .normal)
        btn_forgetPwd.setTitle(sp_localized("忘记密码？",from: "SP_Login"), for: .normal)
        lab_otherAccount.text = sp_localized("社交账号直接登录",from: "SP_Login")
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
    
    func makeEnabled(_ bool:Bool){
        btn_login.isEnabled = bool
        btn_QQ.isEnabled = bool
        btn_Wx.isEnabled = bool
        _text_phone.button_R.isEnabled = bool
        _text_phone.text_field.isEnabled = bool
        _text_pwd.text_field.isEnabled = bool
    }
    
    //MARK:--- 登录 -----------------------------
    fileprivate func clickLogin()  {
        keyBoardHidden()
        makeEnabled(false)
        SP_User.shared.setUser(userAccount: _text_phone.text_field.text!, pwd: _text_pwd.text_field.text!)
        SP_HUD.show(view:self.view,type:.tLoading)
        SP_User.shared.login( { [weak self](isOk, error) in
            self?.makeEnabled(true)
            if isOk {
                SP_HUD.show(text:sp_localized("登录成功",from: "SP_Login"))
                self?.clickN_btn_R1()
            }else{
                SP_HUD.show(detailText:error)
            }
        })
    }
    //MARK:--- 微信登录 -----------------------------
    fileprivate func clickWeiXin()  {
        keyBoardHidden()
        SP_HUD.show(view:self.view,type:.tLoading)
        makeEnabled(false)
        SP_UMShare.shared.login(self, isLogin: true, platformType: .wechatSession, block: { [weak self](result, isOK) in
            self?.makeEnabled(true)
            if isOK {
                guard let res = result as? UMSocialUserInfoResponse else{return}
                SP_HUD.show(type: .tSuccess, text: "授权成功,"+res.name)
            }else{
                SP_MBHUD.showHUD(type: .tError, text: "授权失败，请重试！")
            }
        })
    }
    //MARK:--- QQ登录 -----------------------------
    fileprivate func clickQQ()  {
        keyBoardHidden()
        makeEnabled(false)
        SP_UMShare.shared.login(self, isLogin: true, platformType: .QQ, block: { [weak self](result, isOK) in
            self?.makeEnabled(true)
            if isOK {
                guard let res = result as? UMSocialUserInfoResponse else{return}
                SP_HUD.show(type: .tSuccess, text: "授权成功,"+res.name)
            }else{
                SP_MBHUD.showHUD(type: .tError, text: "授权失败，请重试！")
            }
        })
    }
    //MARK:--- 注册 -----------------------------
    fileprivate func clickSignin() {
        keyBoardHidden()
        SP_Signin.show(self, type: .t注册) { [weak self](isOk,phone,pwd) in
            self?._text_phone.text_field.text = phone
            self?._text_pwd.text_field.text = pwd
            self?.clickLogin()
        }
    }
    //MARK:--- 忘记密码 -----------------------------
    fileprivate func clickForgetPwd() {
        keyBoardHidden()
        SP_Signin.show(self, type: .t忘记密码) { [weak self](isOk,phone,pwd) in
            self?._text_phone.text_field.text = phone
            self?._text_pwd.text_field.text = pwd
            self?.clickLogin()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:--- 键盘
    fileprivate func keyBoardHidden(){
        _text_phone.text_field.resignFirstResponder()
        _text_pwd.text_field.resignFirstResponder()
    }
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
    
    
    private func keyBoardWillShow(_ note:Notification) {
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
    
    private func keyBoardWillHide(_ note:Notification)
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
