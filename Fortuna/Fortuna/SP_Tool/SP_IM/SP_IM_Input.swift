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
import YYKeyboardManager

class SP_IM_Input: UIView {

    class func show(_ supView:UIView) -> SP_IM_Input {
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
    deinit {
        //removekeyBoard()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        text_View.delegate = self
        lab_phlace.text = _placeholderText
        
        btn_voice.setTitle(sp_localized("按住 说话"), for: .normal)
        btn_voice.setTitleColor(UIColor.mainText_1, for: .normal)
        btn_voice.isHidden = true
        //showkeyBoard()
    }
    
    var _placeholderText = "" {
        didSet{
            lab_phlace.text = _placeholderText
        }
    }
    var _isTalk:Bool = false {
        didSet{
            btn_voice.isHidden = !_isTalk
            button_L.setImage(UIImage(named:_isTalk ? "IM键盘" : "IM语音"), for: .normal)
            if _isTalk {
                self.text_View.resignFirstResponder()
                self._heightBlock?(.tH,40)
            }else{
                self.text_View.becomeFirstResponder()
                self.changeTextViewHeight()
            }
        }
    }
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var text_View: UITextView!
    @IBOutlet weak var text_View_L: NSLayoutConstraint!
    @IBOutlet weak var text_View_R: NSLayoutConstraint!
    @IBOutlet weak var btn_voice: UIButton!
    
    
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
        case tBtn_L
        case tBtn_R
    }
    var _block:((_ type:SP_IM_Input_Type, _ text:String)->Void)?
    var _shouldReturnBlock:(()->Void)?
    enum heightType {
        case tH
        case tB
    }
    var _heightBlock:((heightType,CGFloat)->Void)?
    
    
    @IBAction func clickButton(_ sender: UIButton) {
        switch sender {
        case button_L:
            _block?(.tBtn_L,"")
        case button_R:
            _block?(.tBtn_R,"")
        default:
            break
        }
    }
    var _recordBlock:((UIControlEvents)->Void)?
    
    // 开始录音
    @IBAction func startRecordVoice(_ sender: UIButton) {
        self.btn_voice.backgroundColor = UIColor.main_line
        self.btn_voice.setTitle(sp_localized("松开 发送"), for: .normal)
        
        self._recordBlock?(.touchDown)
        
    }
    // 取消录音
    @IBAction func cancelRecordVoice(_ sender: UIButton) {
        self.btn_voice.backgroundColor = UIColor.main_bg
        self.btn_voice.setTitle(sp_localized("按住 说话"), for: .normal)
        self._recordBlock?(.touchUpOutside)
    }
    // 录音结束
    @IBAction func confirmRecordVoice(_ sender: UIButton) {
        self.btn_voice.backgroundColor = UIColor.main_bg
        self.btn_voice.setTitle(sp_localized("按住 说话"), for: .normal)
        self._recordBlock?(.touchUpInside)
    }
    // 更新录音显示状态,手指向上滑动后 提示松开取消录音
    @IBAction func updateCancelRecordVoice(_ sender: UIButton) {
        self.btn_voice.setTitle(sp_localized("松开 取消"), for: .normal)
        
        self._recordBlock?(.touchDragExit)
    }
    //更新录音状态,手指重新滑动到范围内,提示向上取消录音
    @IBAction func updateContinueRecordVoice(_ sender: UIButton) {
        self.btn_voice.setTitle(sp_localized("松开 发送"), for: .normal)
        
        self._recordBlock?(.touchDragEnter)
    }
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print_Json(text)
        if text == "\n" {
            _shouldReturnBlock?()
            //text_View.resignFirstResponder()
            return false
        }
        return true
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
        
        changePlaceholderText()
    }
    func changeTextViewHeight() {
        var textBounds = text_View.bounds
        // 计算 text view 的高度
        let maxSize = CGSize(width:textBounds.size.width, height:CGFloat.greatestFiniteMagnitude)
        let newSize = text_View.sizeThatFits(maxSize)
        textBounds.size = newSize
        let textHeight = textBounds.size.height
        //print(textBounds.size.height)
         _heightBlock?(.tH,textHeight)

    }
    
    /*
    //MARK:--- 键盘
    func showkeyBoard(){
        sp_Notification.addObserver(self, selector:#selector(SP_IM_Input.keyBoardWillShow(_:)), name:sp_ntfNameKeyboardWillShow, object: nil)
        sp_Notification.addObserver(self, selector:#selector(SP_IM_Input.keyBoardWillHide(_:)), name:sp_ntfNameKeyboardWillHide, object: nil)
    }
    func removekeyBoard() {
        sp_Notification.removeObserver(self, name: sp_ntfNameKeyboardWillShow, object: nil)
        sp_Notification.removeObserver(self, name:sp_ntfNameKeyboardWillHide, object: nil)
        sp_Notification.removeObserver(self)
    }
    
    func keyBoardWillShow(_ note:NSNotification) {
        let userInfo  = note.userInfo
        let keyBoardBounds = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let _keyBoardHeight = keyBoardBounds.size.height
        
        
        _heightBlock?(.tB,_keyBoardHeight)
//        self.superview?.setNeedsLayout()
//        let animations:(() -> Void) = {
//            //self.transform = CGAffineTransform(translationX: 0,y: -_keyBoardHeight)
//            self.superview?.layoutIfNeeded()
//            
//            
//        }
        
//        if duration > 0 {
//            let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
//            
//            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: { _ in
//                
//            })
//        }else{
//            
//            animations()
//        }
//        changeTextViewHeight()
//        _heightBlock?(.tFinish,0)
        
    }
    
    @objc private func keyBoardWillHide(_ note:NSNotification)
    {
        
        //let userInfo  = note.userInfo
        
        //let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        _heightBlock?(.tB,0.0)
        
        
        //changeTextViewHeight()
        //endInput()
    }*/
}



