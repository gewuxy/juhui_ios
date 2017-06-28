//
//  JH_HUD_PlaceOrder.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/21.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class JH_HUD_PlaceOrder: UIView {

    var _clickBlock:((Int)->Void)?
    
    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var view_bottom: UIView!
    @IBOutlet weak var btn_buy: UIButton!
    @IBOutlet weak var btn_sell: UIButton!
    @IBOutlet weak var btn_Revoke: UIButton!
    @IBOutlet weak var view_bottom_B: NSLayoutConstraint!

    @IBAction func clickTap(_ sender: UITapGestureRecognizer) {
        hiddenUI()
    }
    @IBAction func clickBtn(_ sender: UIButton) {
        hiddenUI()
        _clickBlock?(sender.tag)
    }
}
extension JH_HUD_PlaceOrder {
    static func show(_ block:((Int)->Void)? = nil) {
        for item in sp_MainWindow.subviews {
            if let view = item as? JH_HUD_PlaceOrder {
                view._clickBlock = block
                return
            }
        }
        let view = (Bundle.main.loadNibNamed("JH_HUD_PlaceOrder", owner: nil, options: nil)!.first as? JH_HUD_PlaceOrder)!
        sp_MainWindow.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        view._clickBlock = block
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeUI()
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        showUI()
    }
    fileprivate func makeUI(){
        view_bg.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        view_bottom_B.constant = -85
        
        btn_buy.setTitle(sp_localized("买入"), for: .normal)
        btn_sell.setTitle(sp_localized("卖出"), for: .normal)
        btn_Revoke.setTitle(sp_localized("撤单"), for: .normal)
    }
    fileprivate func showUI() {
        view_bottom_B.constant = 0
        view_bottom.setNeedsLayout()
        UIView.animate(withDuration: 0.3, animations: { [weak self]_ in
            self?.view_bg.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self?.view_bottom.layoutIfNeeded()
        }) { (isOk) in
            
        }
    
    }
    fileprivate func hiddenUI() {
        view_bottom_B.constant = -85
        view_bottom.setNeedsLayout()
        UIView.animate(withDuration: 0.2, animations: { [weak self]_ in
            self?.view_bg.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self?.view_bottom.layoutIfNeeded()
        }) { (isOk) in
            self.removeFromSuperview()
            
        }
    }
    

}
