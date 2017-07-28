//
//  JH_HUD_Entrust.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/18.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class JH_HUD_Entrust: UIView {

    @IBOutlet weak var img_bg: UIImageView!
    
    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var view_hud: UIView!
    @IBOutlet weak var view_hud_W: NSLayoutConstraint!
    @IBOutlet weak var view_hud_B: NSLayoutConstraint!
    
    @IBOutlet weak var lab_No0: UILabel!
    @IBOutlet weak var lab_name0: UILabel!
    @IBOutlet weak var lab_pice0: UILabel!
    @IBOutlet weak var lab_num0: UILabel!
    
    @IBOutlet weak var lab_title: UILabel!
    @IBOutlet weak var lab_No: UILabel!
    @IBOutlet weak var lab_name: UILabel!
    @IBOutlet weak var lab_pice: UILabel!
    @IBOutlet weak var lab_num: UILabel!
    
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_ok: UIButton!
    
    let disposeBag = DisposeBag()
    var _clickBlock:(()->Void)?

    var model:JH_HUD_EntrustModel = JH_HUD_EntrustModel() {
        didSet{
            lab_No.text = model.no
            lab_name.text = model.name
            lab_pice.text = "¥ "+model.price
            lab_num.text = model.num
            
            
            switch model.type {
            case .t买入:
                lab_title.text = sp_localized("买入委托")
            case .t卖出:
                lab_title.text = sp_localized("卖出委托")
            case .t撤销买入:
                lab_title.text = sp_localized("撤销买入")
            case .t撤销卖出:
                lab_title.text = sp_localized("撤销卖出")
            }
            
            
            var title = ""
            switch model.type {
            case .t买入:
                title = sp_localized("确定买入")
            case .t卖出:
                title = sp_localized("确定卖出")
            case .t撤销买入, .t撤销卖出:
                title = sp_localized("确定撤销")
            }
            btn_ok.setTitle(title, for: .normal)
            
            
        }
    }
    @IBAction func btnClick(_ sender: UIButton) {
        switch sender {
        case btn_ok:
            _clickBlock?()
        default:
            break
        }
        hiddenUI()
    }
}

extension JH_HUD_Entrust {
    class func show(_ model:JH_HUD_EntrustModel, block:(()->Void)? = nil) {
        for item in sp_MainWindow.subviews {
            if let view = item as? JH_HUD_Entrust {
                view.model = model
                view._clickBlock = block
                return
            }
        }
        let view = (Bundle.main.loadNibNamed("JH_HUD_Entrust", owner: nil, options: nil)!.first as? JH_HUD_Entrust)!
        sp_MainWindow.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        view.model = model
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
        btn_cancel.titleLabel?.font = sp_fitFont18
        btn_ok.titleLabel?.font = sp_fitFont18
        
        btn_cancel.setTitleColor(UIColor.main_btnNotEnb, for: .normal)
        btn_ok.setTitleColor(UIColor.main_btnNormal, for: .normal)
        btn_cancel.setTitle(sp_localized("取消"), for: .normal)
        
        lab_No0.text = sp_localized("代码：")
        lab_name0.text = sp_localized("名称：")
        lab_pice0.text = sp_localized("价格：")
        lab_num0.text = sp_localized("数量：")
        
        lab_title.font = sp_fitFont20
        lab_No0.font = sp_fitFont15
        lab_name0.font = sp_fitFont15
        lab_pice0.font = sp_fitFont15
        lab_num0.font = sp_fitFont15
        
        
        lab_No.font = sp_fitFont15
        lab_name.font = sp_fitFont15
        lab_pice.font = sp_fitFont15
        lab_num.font = sp_fitFont15
        
        
        view_hud_W.constant = sp_ScreenWidth - sp_fitSize((30,60,90))
        
        view_hud_B.constant = 20 //+ sp_fitSize((0,5,10))
    }
    
    
    
    fileprivate func showUI() {
        UIView.animate(withDuration: 0, animations: { [weak self]_ in
            self?.view_bg.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        }) { (isOk) in
        }
        
    }
    fileprivate func hiddenUI() {
        UIView.animate(withDuration: 0, animations: { [weak self]_ in
            self?.view_bg.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }) { (isOk) in
            self.removeFromSuperview()
        }
    }
}


struct JH_HUD_EntrustModel {
    var type = JH_BuyAndSellType.t买入
    var no = ""
    var name = ""
    var price = ""
    var num = ""
}




