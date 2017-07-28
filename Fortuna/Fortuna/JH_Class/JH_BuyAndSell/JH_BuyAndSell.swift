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
import IQKeyboardManager
import SocketIO
import SwiftyJSON

enum JH_BuyAndSellType {
    case t买入
    case t卖出
    case t撤销买入
    case t撤销卖出
}
class JH_BuyAndSell: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView_B: NSLayoutConstraint!
    
    lazy var _vcType = JH_BuyAndSellType.t买入
    
    lazy var _datas = M_Attention()
    lazy var _dataDetails = M_AttentionDetail()
    
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
    class func show(_ parentVC:UIViewController?, type:JH_BuyAndSellType, data:M_Attention, dataDetails:M_AttentionDetail) {
        let vc = JH_BuyAndSell.initSPVC()
        vc._vcType = type
        vc._datas = data
        vc._dataDetails = dataDetails
        vc.hidesBottomBarWhenPushed = true
        parentVC?.show(vc, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigation()
        makeUI()
        makeSocketIO()
    }
    fileprivate func makeNavigation() {
        n_view._title = self._datas.name
    }
    
    fileprivate func makeUI() {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        makeTableView()
    }
    fileprivate func makeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    //MARK:--- SocketIO -----------------------------
    func makeSocketIO() {
        JH_Attention.socket.on(clientEvent: .connect) { (data, ack) in
            //iOS客户端上线
            //self?.socket.emit("login", self!._followData.code)
        }
        JH_Attention.socket.on("last_price") { [weak self](res, ack) in
            //接收到广播
            let json:[JSON] = JSON(res).arrayValue
            print_SP("json ==> \(json)")
            guard json.count > 0 else{return}
            let model = M_AttentionDetail(json[0])
            guard self?._datas.code == model.code else{return}
            self?.t_详情页基础数据()
            //self?._dataDetails = model
            //self?.tableView.reloadData()
        }
        /*
        self.socket.on(clientEvent: .disconnect) { (data, ack) in
            
        }*/
        
        JH_Attention.socket.connect()
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
            self.makeBuyAndSell(cell)
            return cell
        default:
            let cell = JH_BuyAndSellCell_Deal.show(tableView, indexPath)
            cell.makeUI(_vcType)
            cell._model = _datas
            cell._clickBlock = { [unowned self] _ in
                let model = JH_HUD_EntrustModel(type: self._vcType, no: self._datas.code, name: self._datas.name, price: cell._text_price.text_field.text!, num: cell._text_num.text_field.text!)
                JH_HUD_Entrust.show(model, block: {[weak self] _ in
                    //SP_HUD.show(text:"模块开发中，下面是模拟")
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
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    fileprivate func toRowTop(_ animated:Bool = false){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [weak self] _ in
            let indexPath = IndexPath(row: 0, section: 1)
            self?.tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
        }
        
    }
    
    fileprivate func makeBuyAndSell(_ cell:JH_BuyAndSellCell_Data) {
        guard _dataDetails.buy_5_level.count == 5 && _dataDetails.sell_5_level.count == 5  else {
            return
        }
        cell.lab_buy1_P.text = _dataDetails.buy_5_level[0][0]
        cell.lab_buy2_P.text = _dataDetails.buy_5_level[1][0]
        cell.lab_buy3_P.text = _dataDetails.buy_5_level[2][0]
        cell.lab_buy4_P.text = _dataDetails.buy_5_level[3][0]
        cell.lab_buy5_P.text = _dataDetails.buy_5_level[4][0]
        
        cell.lab_buy1_N.text = _dataDetails.buy_5_level[0][1]
        cell.lab_buy2_N.text = _dataDetails.buy_5_level[1][1]
        cell.lab_buy3_N.text = _dataDetails.buy_5_level[2][1]
        cell.lab_buy4_N.text = _dataDetails.buy_5_level[3][1]
        cell.lab_buy5_N.text = _dataDetails.buy_5_level[4][1]
        
        cell.lab_sell1_P.text = _dataDetails.sell_5_level[0][0]
        cell.lab_sell2_P.text = _dataDetails.sell_5_level[1][0]
        cell.lab_sell3_P.text = _dataDetails.sell_5_level[2][0]
        cell.lab_sell4_P.text = _dataDetails.sell_5_level[3][0]
        cell.lab_sell5_P.text = _dataDetails.sell_5_level[4][0]
        
        cell.lab_sell1_N.text = _dataDetails.sell_5_level[0][1]
        cell.lab_sell2_N.text = _dataDetails.sell_5_level[1][1]
        cell.lab_sell3_N.text = _dataDetails.sell_5_level[2][1]
        cell.lab_sell4_N.text = _dataDetails.sell_5_level[3][1]
        cell.lab_sell5_N.text = _dataDetails.sell_5_level[4][1]
    }
}
//MARK:--- 网络 -----------------------------
extension JH_BuyAndSell {
    fileprivate func t_详情页基础数据() {
        My_API.t_详情页基础数据(code: _datas.code).post(M_AttentionDetail.self) { [weak self](isOk, data, error) in
            if isOk {
                guard let datas = data as? M_AttentionDetail else{return}
                self?._dataDetails = datas
                self?._datas.proposedPrice = datas.lastest_price
                self?.tableView.reloadSections([0], animationStyle: .none)
            }else{
                SP_HUD.show(text:error)
            }
            //30秒轮询
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(30*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) { [weak self]_ in
                //self?.t_详情页基础数据()
            }
            
        }
    }
    
    fileprivate func goBuyOrSell(){
        SP_HUD.show(view:self.view, type:.tLoading)
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
                _ = self?.navigationController?.popViewController(animated: true)
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
                _ = self?.navigationController?.popViewController(animated: true)
            }else{
                SP_HUD.show(text:error)
            }
            
        }
    }
    
}

