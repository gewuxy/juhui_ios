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
    
    lazy var _vcType = JH_BuyAndSellType.t买入
    
    lazy var _datas = M_Attention()
    

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
            cell.lab_name.text = _datas.name
            cell.lab_no.text = _datas.code
            cell._text_price.text_field.text = _datas.proposedPrice
            cell._text_num.text_field.text = "10"
            cell._clickBlock = { [unowned self] _ in
                let model = JH_HUD_EntrustModel(type: self._vcType, no: self._datas.code, name: self._datas.name, price: cell._text_price.text_field.text!, num: cell._text_num.text_field.text!)
                JH_HUD_Entrust.show(model, block: {
                    
                })
            }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


