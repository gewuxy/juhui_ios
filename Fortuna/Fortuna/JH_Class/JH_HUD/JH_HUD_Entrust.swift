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
            lab_pice.text = model.price
            lab_num.text = model.num
            
            lab_title.text = model.type == .t买入 ? "买入委托" : "卖出委托"
            
            btn_ok.setTitle(model.type == .t买入 ? "确定买入" : "确定卖出", for: .normal)
            
        }
    }
    @IBAction func btnClick(_ sender: UIButton) {
        switch sender {
        case btn_cancel:
            hiddenUI()
        default:
            _clickBlock?()
        }
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
        
        btn_cancel.setTitleColor(UIColor.main_btnNotEnb, for: .normal)
        btn_ok.setTitleColor(UIColor.main_btnNormal, for: .normal)
        
        lab_title.font = UIFont.boldSystemFont(ofSize: SP_InfoOC.sp_fit(withSize: 20))
        
        lab_No.font = UIFont.systemFont(ofSize: SP_InfoOC.sp_fit(withSize: 15))
        lab_No0.font = UIFont.systemFont(ofSize: SP_InfoOC.sp_fit(withSize: 15))
        lab_name.font = UIFont.systemFont(ofSize: SP_InfoOC.sp_fit(withSize: 15))
        lab_name0.font = UIFont.systemFont(ofSize: SP_InfoOC.sp_fit(withSize: 15))
        lab_pice.font = UIFont.systemFont(ofSize: SP_InfoOC.sp_fit(withSize: 15))
        lab_pice0.font = UIFont.systemFont(ofSize: SP_InfoOC.sp_fit(withSize: 15))
        lab_num.font = UIFont.systemFont(ofSize: SP_InfoOC.sp_fit(withSize: 15))
        lab_num0.font = UIFont.systemFont(ofSize: SP_InfoOC.sp_fit(withSize: 15))
        
        view_hud_W.constant = sp_ScreenWidth-(0+SP_InfoOC.sp_fit(withSize: 1)*30)
        
        view_hud_B.constant = 20+SP_InfoOC.sp_fit(withSize: 0)*2
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




