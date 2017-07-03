//
//  SP_UMView.swift
//  carpark
//
//  Created by 刘才德 on 2017/3/29.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class SP_UMView: UIView {

    class func show(_ block:@escaping ((UMSocialPlatformType)->Void)){
        for item in sp_MainWindow.subviews {
            if let view = item as? SP_UMView {
                view._block = block
                return
            }
        }
        let mview = (Bundle.main.loadNibNamed("SP_UMView", owner: nil, options: nil)!.first as? SP_UMView)!
        sp_MainWindow.addSubview(mview)
        mview.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        mview._block = block
    }
    
    var _block:((UMSocialPlatformType)->())?
    lazy var type = [UMSocialPlatformType.QQ,UMSocialPlatformType.sina,UMSocialPlatformType.wechatSession,UMSocialPlatformType.wechatTimeLine]
    
    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var view_cancel: UIView!
    @IBOutlet weak var view_item: UIView!
    @IBOutlet weak var lab_top: UILabel!
    @IBOutlet weak var view_cancel_B: NSLayoutConstraint!
    @IBOutlet weak var btn_cancel: UIButton!
    
    @IBOutlet weak var btn_0: UIButton!
    @IBOutlet weak var btn_1: UIButton!
    @IBOutlet weak var btn_2: UIButton!
    @IBOutlet weak var btn_3: UIButton!
    @IBOutlet weak var lab_0: UILabel!
    @IBOutlet weak var lab_1: UILabel!
    @IBOutlet weak var lab_2: UILabel!
    @IBOutlet weak var lab_3: UILabel!
    
    @IBAction func buttonClick(_ sender: UIButton) {
        if sender == btn_cancel {
            hiddenUI()
            return
        }
        if sender.tag < 4 {
            _block?(type[sender.tag])
        }
        hiddenUI()
    }
    
    @IBAction func clickViewTap(_ sender: UITapGestureRecognizer) {
        hiddenUI()
    }
}

extension SP_UMView {
    override func awakeFromNib() {
        super.awakeFromNib()
        makeUI()
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        showUI()
    }
    fileprivate func makeUI(){
        view_cancel_B.constant = -190
        view_bg.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        btn_cancel.layer.cornerRadius = 6
        btn_cancel.layer.borderColor = UIColor.main_line.cgColor
        btn_cancel.layer.borderWidth = 0.5
        btn_cancel.setTitle(sp_localized("取消"), for: .normal)
        
        lab_0.text = sp_localized("QQ")
        lab_0.textColor = UIColor.mainText_1
        lab_0.font = sp_fitFont14
        lab_1.text = sp_localized("新浪微博")
        lab_1.textColor = UIColor.mainText_1
        lab_1.font = sp_fitFont14
        lab_2.text = sp_localized("微信")
        lab_2.textColor = UIColor.mainText_1
        lab_2.font = sp_fitFont14
        lab_3.text = sp_localized("微信朋友圈")
        lab_3.textColor = UIColor.mainText_1
        lab_3.font = sp_fitFont14
        lab_top.text = sp_localized("分享到")
        lab_top.textColor = UIColor.mainText_1
        lab_top.font = sp_fitFont18
    }
    fileprivate func showUI() {
        view_cancel_B.constant = 0
        self.setNeedsLayout()
        UIView.animate(withDuration: 0.3, animations: { [weak self]_ in
            self?.view_bg.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self?.layoutIfNeeded()
        }) { (isOk) in
            
        }
        
    }
    fileprivate func hiddenUI() {
        view_cancel_B.constant = -190
        self.setNeedsLayout()
        UIView.animate(withDuration: 0.2, animations: { [weak self]_ in
            self?.view_bg.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self?.layoutIfNeeded()
        }) { (isOk) in
            self.removeFromSuperview()
            
        }
    }
}
