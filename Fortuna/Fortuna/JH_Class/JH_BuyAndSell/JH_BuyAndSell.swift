//
//  JH_BuyAndSell.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/18.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum JH_BuyAndSellType {
    case t买入
    case t卖出
}
class JH_BuyAndSell: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView_B: NSLayoutConstraint!
    
    lazy var _vcType = JH_BuyAndSellType.t买入
    
    lazy var _datas = M_Attention()
    
    
    @IBAction func clickViewTap(_ sender: UITapGestureRecognizer) {
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? JH_BuyAndSellCell_Deal {
            cell.keyBoardHidden()
        }
        
    }
}

extension JH_BuyAndSell {
    override class func initSPVC() -> JH_BuyAndSell {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_BuyAndSell") as! JH_BuyAndSell
    }
    class func show(_ parentVC:UIViewController?, type:JH_BuyAndSellType, data:M_Attention) {
        let vc = JH_BuyAndSell.initSPVC()
        vc._vcType = type
        vc._datas = data
        vc.hidesBottomBarWhenPushed = true
        parentVC?.show(vc, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigation()
        makeUI()
    }
    fileprivate func makeNavigation() {
        n_view._title = "名称"
    }
    
    fileprivate func makeUI() {
        
        makeTableView()
    }
    fileprivate func makeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}
extension JH_BuyAndSell:UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sp_SectionH_Foot
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 170
        default:
            return 290
        }
    }
}
extension JH_BuyAndSell:UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = JH_BuyAndSellCell_Data.show(tableView, indexPath)
            return cell
        default:
            let cell = JH_BuyAndSellCell_Deal.show(tableView, indexPath)
            cell.makeUI(_vcType)
            cell._model = _datas
            cell._clickBlock = { [unowned self] _ in
                let model = JH_HUD_EntrustModel(type: self._vcType, no: self._datas.code, name: self._datas.name, price: cell._text_price.text_field.text!, num: cell._text_num.text_field.text!)
                JH_HUD_Entrust.show(model, block: {[weak self] _ in
                    SP_HUD.show(text:"模块开发中，下面是模拟")
                    self?.goBuyOrSell()
                })
            }
            cell._heightBlock = { [weak self](type,height) in
                switch type {
                case .tB:
                    self?.tableView_B.constant = height
                case .tFinish:
                    self?.toRowTop()
                default:break
                }
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    fileprivate func toRowTop(_ animated:Bool = false){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [weak self] _ in
            let indexPath = IndexPath(row: 0, section: 1)
            self?.tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
        }
        
    }
}
//MARK:--- 网络 -----------------------------
extension JH_BuyAndSell {
    fileprivate func goBuyOrSell(){
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? JH_BuyAndSellCell_Deal {
            if _vcType == .t买入 {
                t_买入(cell._text_price.text_field.text!,cell._text_num.text_field.text!)
            }else{
                t_卖出(cell._text_price.text_field.text!,cell._text_num.text_field.text!)
            }
        }
        
    }
    fileprivate func t_买入(_ price:String, _ num:String) {
        SP_HUD.show(view:self.view, type:.tLoading, text:sp_localized("正在买入") )
        My_API.t_买入(code: _datas.code, price: price, num: num).post(M_Attention.self) { [weak self](isOk, data, error) in
            SP_HUD.hidden()
            if isOk {
                SP_HUD.show(text:sp_localized("已买入"))
                
            }else{
                SP_HUD.show(text:error)
            }
            
        }
    }
    fileprivate func t_卖出(_ price:String, _ num:String) {
        SP_HUD.show(view:self.view, type:.tLoading, text:sp_localized("正在卖出") )
        My_API.t_卖出(code: _datas.code, price: price, num: num).post(M_Attention.self) { [weak self](isOk, data, error) in
            SP_HUD.hidden()
            if isOk {
                SP_HUD.show(text:sp_localized("已卖出"))
                
            }else{
                SP_HUD.show(text:error)
            }
            
        }
    }
    
}

