//
//  JH_AttentionDetailsFull.swift
//  Fortuna
//
//  Created by LCD on 2017/7/31.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import SwiftyJSON
class JH_AttentionDetailsFull: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btn_dismiss: UIButton!
    lazy var _datas = M_Attention()
    lazy var _dataDetails = M_AttentionDetail()
    
    var _cell:JH_AttentionDetailsCell_Charts?
    
    
    @IBAction func clickDismiss(_ sender: UIButton) {
        self.dismiss(animated: true) { 
            
        }
    }
}

extension JH_AttentionDetailsFull {
    override class func initSPVC() -> JH_AttentionDetailsFull {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_AttentionDetailsFull") as! JH_AttentionDetailsFull
    }
    class func show(_ parentVC:UIViewController?, data:M_Attention, dataDetails:M_AttentionDetail) {
        let vc = JH_AttentionDetailsFull.initSPVC()
        vc._datas = data
        vc._dataDetails = dataDetails
        vc.modalTransitionStyle = .crossDissolve
        parentVC?.present(vc, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI*0.5))
        
        self.makeTableView()
        self.makeSocketIO()
        self.t_详情页基础数据()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    fileprivate func makeTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
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
            //print_SP("json ==> \(json)")
            guard json.count > 0 else{return}
            let model = M_AttentionDetail(json[0])
            guard self?._datas.code == model.code else{return}
            self?.t_详情页基础数据()
            //self?._dataDetails = model
            //self?.tableView.reloadData()
            guard self != nil else{return}
            if self!._cell != nil {
                self?.getLineData(JH_AttentionDetails._selectType,self!._cell!,false)
            }
        }
        /*
         self.socket.on(clientEvent: .disconnect) { (data, ack) in
         
         }*/
        
        JH_Attention.socket.connect()
    }
}

extension JH_AttentionDetailsFull:UITableViewDelegate,UITableViewDataSource {
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
            return sp_fitSize((100,115,130))
        case 1:
            return sp_ScreenWidth - sp_fitSize((105,120,135)) - sp_SectionH_Foot
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = JH_AttentionDetailsCell_DataFull.show(tableView)
            //cell.btn_unfold.setImage(UIImage(named: _tUnfoldOpen ? "Attention置顶" : "Attention展开"), for: .normal)
            cell.lab_price.text = _dataDetails.lastest_price
            cell.lab_range.text = _dataDetails.increase_ratio
            cell.lab_MOL.text = _dataDetails.increase
            
            cell.lab_tall.text = _dataDetails.highest_price
            cell.lab_low.text = _dataDetails.lowest_price
            cell.lab_rate.text = _dataDetails.amplitude
            cell.lab_ratio.text = _dataDetails.ratio
            
            cell.lab_PRE.text = _dataDetails.deal_count
            cell.lab_InSize.text = _dataDetails.turnover
            cell.lab_Up.text = _dataDetails.turnover_rate
            cell.lab_MktCap.text = _dataDetails.total_market_value
            return cell
        case 1:
            let cell = JH_AttentionDetailsCell_Charts.show(tableView, indexPath)
            cell._stockChartView.reloadData()
            for item in cell.view_top.subviews {
                if let btn = item as? UIButton, btn.tag == JH_AttentionDetails._selectType.rawValue  {
                    cell.clickBtnTop(btn)
                }
            }
            for item in cell.view_time.subviews {
                if let btn = item as? UIButton, btn.tag + 5 == JH_AttentionDetails._selectType.rawValue  {
                    cell.clickBtnTop(cell.btn_top5)
                    cell.clickTimeButton(btn)
                    
                }
            }
            cell.btn_fullScreen.isHidden = true
            cell._datas = _datas
            makeBuyAndSell(cell)
            self._cell = cell
            cell.btn_top5.imageEdgeInsets = UIEdgeInsetsMake(15, sp_fitSize((60,70,80)), 15, sp_fitSize((25,25,25)))
            cell._getDataBlock = { [weak self]type in
                JH_AttentionDetails._selectType = type
                sp_Notification.post(name: ntf_Name_K线选择更新, object: nil)
                self?.getLineData(JH_AttentionDetails._selectType, cell)
            }
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    fileprivate func makeBuyAndSell(_ cell:JH_AttentionDetailsCell_Charts) {
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
extension JH_AttentionDetailsFull {
    fileprivate func getLineData(_ type:JH_ChartDataType, _ cell:JH_AttentionDetailsCell_Charts?, _ loading:Bool = true){
        
        //testReloadData(type,cell)
        
        switch type {
        case .t分时,.t5日:
            t_分时数据(type,cell,loading)
        case .t日K,.t周K,.t月K,.t1分,.t5分,.t10分,.t30分,.t60分:
            t_K线图数据(type,cell,loading)
        }
    }
    /*
     _Date = arr[0];
     _Open = @([arr[1] floatValue]);
     _High = @([arr[2] floatValue]);
     _Low = @([arr[3] floatValue]);
     _Close = @([arr[4] floatValue]);
     _Volume = [arr[5] floatValue];
     */
    fileprivate func t_分时数据(_ type:JH_ChartDataType, _ cell:JH_AttentionDetailsCell_Charts?, _ loading:Bool = true) {
        guard cell != nil else {return}
        if loading {
            if JH_AttentionDetails._modelsDict[type.stringValue] == nil {
                cell?.view_activi.isHidden = false
                cell?.view_activi.startAnimating()
                cell?.lab_error.isHidden = true
                cell?._stockChartView.isHidden = true
                
            }
            
        }
        My_API.t_分时数据(code: _datas.code, period: type.periodValue).post(M_TimeLine.self) { [weak self](isOk, data, error) in
            guard self != nil else{return}
            cell?.view_activi.isHidden = true
            cell?.view_activi.stopAnimating()
            
            if isOk {
                guard let data0 = data as? [M_TimeLine] else{return}
                guard data0.count > 0 else{
                    cell?.lab_error.text = sp_localized("9011110")
                    cell?.lab_error.isHidden = false
                    return
                }
                
                cell?.lab_error.isHidden = true
                DispatchQueue.global().async {
                    
                    let datas = makeKTimeLineData(type, timeLines: data0)
                    
                    var arr:[Any] = []
                    var arrs:[Any] = []
                    var _groupModel = Y_KLineGroupModel()
                    for item in datas {
                        arr.removeAll()
                        arr.append(item.timestamp)
                        arr.append(item.open_price)
                        arr.append(item.high_price)
                        arr.append(item.low_price)
                        arr.append(item.close_price)
                        arr.append(item.num)
                        arrs.append(arr)
                        
                    }
                    _groupModel = Y_KLineGroupModel.object(with: arrs)
                    
                    DispatchQueue.main.async { [weak cell]_ in
                        JH_AttentionDetails._modelsDict[type.stringValue] = _groupModel
                        cell?._stockChartView.isHidden = false
                        cell?._stockChartView.reloadData()
                        
                    }
                }
                
                
                
                
                
            }
            
        }
    }
    
    
    fileprivate func t_K线图数据(_ type:JH_ChartDataType, _ cell:JH_AttentionDetailsCell_Charts?, _ loading:Bool = true) {
        guard cell != nil else {return}
        if loading {
            if JH_AttentionDetails._modelsDict[type.stringValue] == nil {
                cell?.view_activi.isHidden = false
                cell?.view_activi.startAnimating()
                cell?.lab_error.isHidden = true
                cell?._stockChartView.isHidden = true
                cell?._stockChartView.isReloadDataStop = true
            }
            
        }
        My_API.t_K线图数据(code: _datas.code, period: type.periodValue).post(M_TimeLine.self) { [weak self](isOk, data, error) in
            guard self != nil else{return}
            cell?.view_activi.isHidden = true
            cell?.view_activi.stopAnimating()
            if isOk {
                guard let data0 = data as? [M_TimeLine] else{return}
                guard data0.count > 0 else{
                    cell?.lab_error.text = sp_localized("9011110")
                    cell?.lab_error.isHidden = false
                    return
                }
                
                cell?.lab_error.isHidden = true
                
                DispatchQueue.global().async {
                    
                    let datas = makeKTimeLineData(type, timeLines: data0)
                    
                    guard datas.count > 0 else{return}
                    var arr:[Any] = []
                    var arrs:[Any] = []
                    var _groupModel = Y_KLineGroupModel()
                    for item in datas {
                        arr.removeAll()
                        arr.append(item.timestamp)
                        arr.append(item.open_price)
                        arr.append(item.high_price)
                        arr.append(item.low_price)
                        arr.append(item.close_price)
                        arr.append(item.deal_count)
                        arrs.append(arr)
                    }
                    print_Json(arrs)
                    _groupModel = Y_KLineGroupModel.object(with: arrs)
                    DispatchQueue.main.async { [weak cell]_ in
                        JH_AttentionDetails._modelsDict[type.stringValue] = _groupModel
                        cell?._stockChartView.isHidden = false
                        cell?._stockChartView.reloadData()
                        
                    }
                    
                }
            }
            
        }
    }
    
    fileprivate func t_详情页基础数据() {
        My_API.t_详情页基础数据(code: _datas.code).post(M_AttentionDetail.self) { [weak self](isOk, data, error) in
            if isOk {
                guard let datas = data as? M_AttentionDetail else{return}
                self?._dataDetails = datas
                self?._datas.proposedPrice = datas.lastest_price
                let rows = [IndexPath(row: 0, section: 0)]
                self?.tableView.reloadRows(at: rows, with: .none)
            }else{
                SP_HUD.show(text:error)
            }
        }
    }
}
