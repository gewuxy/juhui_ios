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
    
    var _isOkBlock:((Bool)->Void)?
    lazy var _vcType = SP_SigninType.t注册
    lazy var _keyBoardHeightRatio:CGFloat = 1.7
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var lab_error: UILabel!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var btn_agreement: UIButton!
    @IBOutlet weak var btn_agreementSelect: UIButton!
    
    @IBOutlet weak var view_phone: UIView!
    @IBOutlet weak var view_pwd: UIView!
    @IBOutlet weak var view_verification: UIView!
    @IBOutlet weak var view_agreement: UIView!
    
    @IBOutlet weak var img_logo_T: NSLayoutConstraint!
    @IBOutlet weak var img_logo_B: NSLayoutConstraint!
    @IBOutlet weak var btn_login_T: NSLayoutConstraint!
    @IBOutlet weak var view_other_T: NSLayoutConstraint!
    
    
    lazy var _text_phone:SP_TextField = {
        let text = SP_TextField.show(self.view_phone)
        text.text_field.placeholder = "请输入有效的手机号"
        text.button_L.setImage(UIImage(named:"navi_search_gray"), for: .normal)
        text.button_R.setImage(UIImage(named:"navi_search_gray"), for: .normal)
        
        return text
    }()
    lazy var _text_pwd:SP_TextField = {
        let text = SP_TextField.show(self.view_pwd)
        text.text_field.placeholder = "请输入密码"
        text.button_L.setImage(UIImage(named:"navi_search_gray"), for: .normal)
        text.button_R.setImage(UIImage(named:"navi_search_gray"), for: .normal)
        
        return text
    }()
    lazy var _text_verifi:SP_TextField = {
        let text = SP_TextField.show(self.view_verification)
        text.text_field.placeholder = "请输入验证码"
        text.button_L.setImage(UIImage(named:"navi_search_gray"), for: .normal)
        text.button_R.setTitle("发送验证码",for:.normal)
        text.button_R_W.constant = 100
        return text
    }()
}

extension SP_Signin {
    
    override class func initSPVC() -> SP_Signin {
        return UIStoryboard(name: "SP_Login", bundle: nil).instantiateViewController(withIdentifier: "SP_Signin") as! SP_Signin
    }
    
    class func show(_ parentVC:UIViewController?, type:SP_SigninType = .t注册, block: ((Bool) -> Void)? = nil) {
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
        _ = self.navigationController?.popViewController(animated: true)
    }
    fileprivate func makeNavigatin(){
        n_view._title = _vcType == .t注册 ? "注册" : "忘记密码"
        
    }
    fileprivate func makeUI() {
        if SP_InfoOC.sp_deviceModel() == tiPhone4 {
            img_logo_T.constant = 15
            img_logo_B.constant = 15
            btn_login_T.constant = 15
            view_other_T.constant = 15
            _keyBoardHeightRatio = 2.0
        }
        btn_login.setTitle(_vcType == .t注册 ? "注册" : "重置密码", for: .normal)
        view_agreement.isHidden = _vcType != .t注册
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
        
        _text_verifi._shouldChangeCharactersBlock = { [weak self](textField,range,str) -> Bool in
            let bool = textField.sp_limitForPwd(range, string: str, stringLength: 16, errorType: { (type) in
                switch type {
                case .tOutRange:
                    break
                case .tUnlawful:
                    self?.lab_error.text = "*请输入正确的验证码"
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
    //MARK:--- 注册、忘记密码 -----------------------------
    fileprivate func clickLogin()  {
        
    }
    //MARK:--- 发送验证码 -----------------------------
    fileprivate func clickVerifi()  {
        SP_TimeSingleton.shared.starCountDown(self._text_verifi.button_R,countTime: 60,color:(normal:UIColor.white,select:UIColor.mainText_2))
    }
    //MARK:--- 用户协议 -----------------------------
    fileprivate func clickAgreement()  {
        
    }
    
    
    //MARK:--- 键盘
    
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
