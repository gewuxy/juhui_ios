//
//  AlbumToolbarView.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/8.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import UIKit

protocol AlbumToolbarViewDelegate: class{
    func onFinishedButtonClicked()
}

class AlbumToolbarView: UIView {
    
    var doneNumberAnimationLayer: UIView?
    var labelTextView: UILabel?
    var buttonDone: UIButton?
    var doneNumberContainer: UIView?
    
    weak var delegate: AlbumToolbarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    fileprivate func setupView(){
        self.backgroundColor = UIColor.white
        let bounds = self.bounds
        let width = bounds.width
        let toolbarHeight = bounds.height
        let buttonWidth: CGFloat = 40
        let buttonHeight: CGFloat = 40
        let padding:CGFloat = 5
        
        // button
        self.buttonDone = UIButton(type: .custom)
        buttonDone!.frame = CGRect(x: width - buttonWidth - padding, y: (toolbarHeight - buttonHeight) / 2, width: buttonWidth, height: buttonHeight)
        buttonDone!.setTitle(PhotoPickerConfig.ButtonDone, for: UIControlState())
        buttonDone!.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        buttonDone!.setTitleColor(UIColor.black, for: UIControlState())
        buttonDone!.addTarget(self, action: #selector(AlbumToolbarView.eventDoneClicked), for: .touchUpInside)
        buttonDone!.isEnabled = true
        buttonDone!.setTitleColor(UIColor.gray, for: .disabled)
        
        self.addSubview(self.buttonDone!)
        
        // done number
        let labelWidth:CGFloat = 20
        let labelX = buttonDone!.frame.minX - labelWidth
        let labelY = (toolbarHeight - labelWidth) / 2
        
        self.doneNumberContainer = UIView(frame: CGRect(x: labelX, y: labelY, width: labelWidth, height: labelWidth))
        let labelRect = CGRect(x: 0, y: 0, width: labelWidth, height: labelWidth)
        self.doneNumberAnimationLayer = UIView.init(frame: labelRect)
        self.doneNumberAnimationLayer!.backgroundColor = UIColor.init(red: 7/255, green: 179/255, blue: 20/255, alpha: 1)
        self.doneNumberAnimationLayer!.layer.cornerRadius = labelWidth / 2
        doneNumberContainer!.addSubview(self.doneNumberAnimationLayer!)
        
        self.labelTextView = UILabel(frame: labelRect)
        self.labelTextView!.textAlignment = .center
        self.labelTextView!.backgroundColor = UIColor.clear
        self.labelTextView!.textColor = UIColor.white
        doneNumberContainer!.addSubview(self.labelTextView!)
        
        
        doneNumberContainer?.isHidden = true
        
        self.addSubview(self.doneNumberContainer!)
        
        // 添加分割线
        let divider = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 1))
        divider.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.15)
        self.addSubview(divider)
    }
    
    // MARK: -  toolbar delegate  完成
    func eventDoneClicked(){
        SP_MBHUD.showHUD()
        if let delegate = self.delegate {
            
            delegate.onFinishedButtonClicked()
        }
    }
    
    func changeNumber(_ number:Int){
        self.labelTextView?.text = String(number)
        if number > 0 {
            self.buttonDone?.isEnabled = true
            self.doneNumberContainer?.isHidden = false
            self.doneNumberAnimationLayer!.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: UIViewAnimationOptions.curveEaseIn, animations: { [weak self]() -> Void in
                self?.doneNumberAnimationLayer!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion: nil)
        } else {
            self.buttonDone?.isEnabled  = false
            self.doneNumberContainer?.isHidden = true
        }
    }
    
}
