//
//  SP_IM_Input.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/27.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SP_IM_Input: UIView {

    static func show(_ supView:UIView) -> SP_IM_Input {
        for item in supView.subviews {
            if let sub = item as? SP_IM_Input {
                
                return sub
            }
        }
        let view = (Bundle.main.loadNibNamed("SP_IM_Input", owner: nil, options: nil)!.first as? SP_IM_Input)!
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
        
        text_View.delegate = self
    }
    
    var _placeholderText = ""
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var text_View: UITextView!
    @IBOutlet weak var text_View_L: NSLayoutConstraint!
    @IBOutlet weak var text_View_R: NSLayoutConstraint!
    
    @IBOutlet weak var lab_phlace: UILabel!
    
    @IBOutlet weak var button_L: UIButton!
    @IBOutlet weak var button_R: UIButton!
    @IBOutlet weak var button_L_W: NSLayoutConstraint!
    @IBOutlet weak var button_R_W: NSLayoutConstraint!
    @IBOutlet weak var button_L_H: NSLayoutConstraint!
    @IBOutlet weak var button_R_H: NSLayoutConstraint!
    
    enum SP_IM_Input_Type {
        case tBegin
        case tChange
        case tEnd
        case tReturn
    }
    var _block:((_ type:SP_IM_Input_Type, _ text:String)->Void)?
    
    enum heightType {
        case tH
        case tB
    }
    var _heightBlock:((heightType,CGFloat)->Void)?
}

extension SP_IM_Input:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        changePlaceholderText()
        changeTextViewHeight()
        _block?(.tChange,textView.text)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        _block?(.tBegin,textView.text)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        _block?(.tEnd,textView.text)
    }
    
    
    func changePlaceholderText() {
        if text_View.text!.isEmpty {
            lab_phlace.text = _placeholderText
        }else{
            lab_phlace.text = ""
        }
    }
    
    func endInput() {
        text_View.resignFirstResponder()
        
        if text_View.text!.isEmpty {
            _heightBlock?(.tH,50)
        }
        changePlaceholderText()
    }
    func changeTextViewHeight() {
        var textBounds = text_View.bounds
        // 计算 text view 的高度
        let maxSize = CGSize(width:textBounds.size.width, height:CGFloat.greatestFiniteMagnitude)
        let newSize = text_View.sizeThatFits(maxSize)
        textBounds.size = newSize
        let textHeight = textBounds.size.height + 16
        //print(textBounds.size.height)
        
         _heightBlock?(.tH,textHeight)
//        if self.bounds.size.height != textHeight && textHeight >= 50 && textHeight <= 106 {
//            
//        }else{
//            
//        }
        
        
    }
    
    
    //MARK:--- 键盘
    func showNotification(){
        /*
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
        */
    }
    
    func keyBoardWillShow(_ note:NSNotification) {
        let userInfo  = note.userInfo
        let keyBoardBounds = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let _keyBoardHeight = keyBoardBounds.size.height
        
        
        _heightBlock?(.tB,_keyBoardHeight)
        self.superview?.setNeedsLayout()
        let animations:(() -> Void) = {
            //self.transform = CGAffineTransform(translationX: 0,y: -_keyBoardHeight)
            self.superview?.layoutIfNeeded()
            
            
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            
            animations()
        }
        changeTextViewHeight()
        
        
    }
    
    @objc private func keyBoardWillHide(_ note:NSNotification)
    {
        
        let userInfo  = note.userInfo
        
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        _heightBlock?(.tB,0.0)
        
        self.superview?.setNeedsLayout()
        let animations:(() -> Void) = {
            //self.transform = .identity
            self.superview?.layoutIfNeeded()
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            
            animations()
        }
        
        changeTextViewHeight()
        endInput()
    }
}



