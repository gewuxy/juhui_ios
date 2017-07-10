//
//  JH_AttentionDetails.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/20.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class JH_AttentionDetails: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view_toolBar: UIView!
    @IBOutlet weak var btn_remove: UIButton!
    @IBOutlet weak var btn_placeOrder: UIButton!
    @IBOutlet weak var btn_chateau: UIButton!
    
    fileprivate enum sectionType:Int {
        case tData = 0
        case tCharts
    }
    lazy var _tUnfoldOpen = false
    
    lazy var _datas = M_Attention()
    lazy var _dataDetails = M_AttentionDetail()
    
    
}

extension JH_AttentionDetails {
    override class func initSPVC() -> JH_AttentionDetails {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_AttentionDetails") as! JH_AttentionDetails
    }
    class func show(_ parentVC:UIViewController?, data:M_Attention) {
        let vc = JH_AttentionDetails.initSPVC()
        vc._datas = data
        vc.hidesBottomBarWhenPushed = true
        parentVC?.navigationController?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigation()
        makeUI()
        makeTableView()
        
        
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        t_详情页基础数据()
    }
    fileprivate func makeNavigation() {
        n_view._title = _datas.name
        n_view.n_btn_C1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        n_view._detailTitle = "交易中"
        n_view.n_label_C1.textColor = UIColor.white.withAlphaComponent(0.3)
        n_view.n_label_C1.font = UIFont.boldSystemFont(ofSize: 12)
        n_view.n_label_C1_H.constant = 12
        n_view.n_label_C1_B.constant = 5
        n_view.n_btn_R1_Image = "Attention分享"
        n_view.n_btn_R1_R.constant = 15
    }
    
    fileprivate func makeUI() {
        
        btn_remove.setTitle(sp_localized(_datas.isFollow ? "删除自选" : "+ 自选") , for: .normal)
        btn_remove.setTitleColor(_datas.isFollow ? UIColor.mainText_3 : UIColor.mainText_1, for: .normal)
        
        
    }
    fileprivate func makeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func clickN_btn_R1() {
        SP_UMView.show({ [unowned self](type) in
            SP_UMShare.shared.showDefault(self,viewType:.tCustom(platformType: type), shareTitle: "巨汇", shareText: "点击查看详情", shareImage: "http://shendeng.17173.com/cf_res/upload/big_img/201202070008.jpg", shareURL: "http://v1.qzone.cc/pic/201306/29/10/56/51ce4cd6e7eb1111.jpg%21600x600.jpg",  block: { (isOk) in
                
            })
        })
    }
    
    @IBAction func clickToolBarBtn(_ sender: UIButton) {
        switch sender {
        case btn_placeOrder:
            JH_HUD_PlaceOrder.show({ [unowned self]tag in
                switch tag {
                case 0:
                    JH_BuyAndSell.show(self, type: .t买入, data:self._datas)
                case 1:
                    JH_BuyAndSell.show(self, type: .t卖出, data:self._datas)
                case 2:
                    break
                default:break
                }
            })
        case btn_chateau:
            JH_IM.show(self)
        case btn_remove:
            if _datas.isFollow {
                UIAlertController.showAler(self, btnText: [sp_localized("取消"),sp_localized("确定")], title: sp_localized("您将删除此自选酒"), message: "", block: { [weak self](str) in
                    if str == sp_localized("确定") {
                        self?.t_删除自选数据()
                    }
                })
            }else{
                t_添加自选数据()
            }
        default:
            break
        }
    }
}
extension JH_AttentionDetails:UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionType.tCharts.rawValue + 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case sectionType.tData.rawValue:
            return _tUnfoldOpen ? 2 : 1
        case sectionType.tCharts.rawValue:
            return 1
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sp_SectionH_Foot
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case sectionType.tData.rawValue:
            return indexPath.row == 0 ? sp_fitSize((145,160,175)) : sp_fitSize((125,140,155))
        case sectionType.tCharts.rawValue:
            return sp_fitSize((228,248,278))
        default:
            return 0
        }
    }
}
extension JH_AttentionDetails:UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case sectionType.tData.rawValue:
            if indexPath.row == 0 {
                let cell = JH_AttentionDetailsCell_Data.show(tableView, indexPath, openBlock:{ [unowned self]_ in
                    self._tUnfoldOpen = !self._tUnfoldOpen
                    self.tableView.reloadData()
                })
                cell.btn_unfold.setImage(UIImage(named: _tUnfoldOpen ? "Attention置顶" : "Attention展开"), for: .normal)
                cell.lab_price.text = _dataDetails.lastest_price
                cell.lab_range.text = _datas.quoteChange
                
                cell.lab_tall.text = _dataDetails.highest_price
                cell.lab_low.text = _dataDetails.lowest_price
                cell.lab_rate.text = _dataDetails.turnover_rate
                cell.lab_ratio.text = _dataDetails.ratio
                return cell
            }else{
                let cell = JH_AttentionDetailsCell_Unfold.show(tableView, indexPath)
                cell.lab_VOL.text = _dataDetails.deal_count
                cell.lab_MktCap.text = _dataDetails.total_market_value
                cell.lab_swing.text = _dataDetails.amplitude
                return cell
            }
        case sectionType.tCharts.rawValue:
            let cell = JH_AttentionDetailsCell_Charts.show(tableView, indexPath)
            cell._datas = _datas
            makeBuyAndSell(cell)
            
            cell._getDataBlock = { [weak self]type in
                self?.getLineData(type, cell)
            }
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    fileprivate func makeBuyAndSell(_ cell:JH_AttentionDetailsCell_Charts) {
        guard _dataDetails.buy_5_level.count == 5 && _dataDetails.sell_5_level.count == 5  else {
            return
        }
        cell.lab_buy1_P.text = String(format:"%.2f",_dataDetails.buy_5_level[0][0])
        cell.lab_buy2_P.text = String(format:"%.2f",_dataDetails.buy_5_level[1][0])
        cell.lab_buy3_P.text = String(format:"%.2f",_dataDetails.buy_5_level[2][0])
        cell.lab_buy4_P.text = String(format:"%.2f",_dataDetails.buy_5_level[3][0])
        cell.lab_buy5_P.text = String(format:"%.2f",_dataDetails.buy_5_level[4][0])
        
        cell.lab_buy1_N.text = String(format:"%.0f",_dataDetails.buy_5_level[0][1])
        cell.lab_buy2_N.text = String(format:"%.0f",_dataDetails.buy_5_level[1][1])
        cell.lab_buy3_N.text = String(format:"%.0f",_dataDetails.buy_5_level[2][1])
        cell.lab_buy4_N.text = String(format:"%.0f",_dataDetails.buy_5_level[3][1])
        cell.lab_buy5_N.text = String(format:"%.0f",_dataDetails.buy_5_level[4][1])
        
        cell.lab_sell1_P.text = String(format:"%.2f",_dataDetails.sell_5_level[0][0])
        cell.lab_sell2_P.text = String(format:"%.2f",_dataDetails.sell_5_level[1][0])
        cell.lab_sell3_P.text = String(format:"%.2f",_dataDetails.sell_5_level[2][0])
        cell.lab_sell4_P.text = String(format:"%.2f",_dataDetails.sell_5_level[3][0])
        cell.lab_sell5_P.text = String(format:"%.2f",_dataDetails.sell_5_level[4][0])
        
        cell.lab_sell1_N.text = String(format:"%.0f",_dataDetails.sell_5_level[0][1])
        cell.lab_sell2_N.text = String(format:"%.0f",_dataDetails.sell_5_level[1][1])
        cell.lab_sell3_N.text = String(format:"%.0f",_dataDetails.sell_5_level[2][1])
        cell.lab_sell4_N.text = String(format:"%.0f",_dataDetails.sell_5_level[3][1])
        cell.lab_sell5_N.text = String(format:"%.0f",_dataDetails.sell_5_level[4][1])
    }
}

//MARK:--- 网络 -----------------------------
extension JH_AttentionDetails {
    fileprivate func getLineData(_ type:JH_ChartDataType, _ cell:JH_AttentionDetailsCell_Charts?){
        switch type {
        case .t分时,.t5日:
            t_分时数据(type,cell)
        case .t日K,.t周K,.t月K,.t1分,.t5分,.t10分,.t30分,.t60分:
            t_K线图数据(type,cell)
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
    fileprivate func t_分时数据(_ type:JH_ChartDataType, _ cell:JH_AttentionDetailsCell_Charts?) {
        cell?._ykLineChartView.isHidden = true
        cell?._ykTimeLineView.isHidden = true
        My_API.t_分时数据(code: _datas.code, period: type.periodValue).post(M_TimeLine.self) { [weak self](isOk, data, error) in
            guard self != nil else{return}
            if isOk {
                guard let datas = data as? [M_TimeLine] else{return}
                
                var array = [YKTimeLineEntity]()
                for item in datas {
                    let entity = YKTimeLineEntity()
                    entity.lastPirce = CGFloat(Double(item.last_price)!)
                    //entity.avgPirce = CGFloat(Double(item.high_price)!)
                    entity.high = CGFloat(Double(item.high_price)!)
                    entity.low = CGFloat(Double(item.low_price)!)
                    entity.rate = item.turnover_rate
                    
                    entity.preClosePx = CGFloat(Double(item.close_price)!)
                    
                    entity.currtTime = item.timestamp
                    entity.volume = CGFloat(Double(item.num)!)
                    array.append(entity)
                }
                cell?._ykLineChartView.isHidden = true
                cell?._ykTimeLineView.isHidden = false
                cell?.makeYKTimeLineView(array)
                /*
                var arr:[Double] = []
                for item in datas {
                    arr.append(Double(item.high_price)!)
                }
                cell?._lineBgView._timeLineData = arr
                */
                /*
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
                    arr.append(item.num)
                    arrs.append(arr)
                    
                }
                _groupModel = Y_KLineGroupModel.object(with: arrs)
                cell?._modelsDict[type.stringValue] = _groupModel
                cell?._stockChartView.reloadData()
                */
            }
            
        }
    }
    fileprivate func t_K线图数据(_ type:JH_ChartDataType, _ cell:JH_AttentionDetailsCell_Charts?) {
        cell?._ykLineChartView.isHidden = true
        cell?._ykTimeLineView.isHidden = true
        My_API.t_K线图数据(code: _datas.code, period: type.periodValue).post(M_TimeLine.self) { [weak self](isOk, data, error) in
            guard self != nil else{return}
            if isOk {
                guard let datas = data as? [M_TimeLine] else{return}
                
                var array = [YKLineEntity]()
                for item in datas {
                    let entity = YKLineEntity()
                    entity.high = CGFloat(Double(item.high_price)!)
                    entity.open = CGFloat(Double(item.open_price)!)
                    
                    entity.low = CGFloat(Double(item.low_price)!)
                    
                    entity.close = CGFloat(Double(item.close_price)!)
                    
                    entity.date = item.timestamp
                    //entity.ma5 = [dic[@"avg5"] doubleValue];
                    //entity.ma10 = [dic[@"avg10"] doubleValue];
                    //entity.ma20 = [dic[@"avg20"] doubleValue];
                    entity.volume = CGFloat(Double(item.deal_count)!)
                    array.append(entity)
                }
                cell?._ykLineChartView.isHidden = false
                cell?._ykTimeLineView.isHidden = true
                cell?.makeYKLineChartView(array)
                
                
                
                
                /*
                var arr:[(val:Double,high:Double,low:Double,open:Double,close:Double)] = []
                for item in datas {
                    arr.append((val:Double(item.deal_count)!,
                                high:Double(item.high_price)!,
                                low:Double(item.low_price)!,
                                open:Double(item.open_price)!,
                                close:Double(item.close_price)!))
                }
                cell?._lineBgView._kLineData = arr
                 */
                /*
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
                
                cell?._modelsDict[type.stringValue] = _groupModel
                
                cell?._stockChartView.reloadData()
                */
            }
            
        }
    }
}

extension JH_AttentionDetails {
    fileprivate func t_详情页基础数据() {
        My_API.t_详情页基础数据(code: _datas.code).post(M_AttentionDetail.self) { [weak self](isOk, data, error) in
            if isOk {
                guard let datas = data as? M_AttentionDetail else{return}
                self?._dataDetails = datas
                self?._datas.proposedPrice = datas.lastest_price
                self?.tableView.reloadData()
            }else{
                SP_HUD.show(text:error)
            }
            
        }
    }
    fileprivate func t_删除自选数据() {
        
        SP_HUD.show(view: self.view, type: .tLoading, text: sp_localized("正在删除"))
        My_API.t_删除自选数据(code:_datas.code).post(M_Attention.self) { [weak self](isOk, data, error) in
            SP_HUD.hidden()
            if isOk {
                SP_HUD.show(text: sp_localized("已删除"))
                self?.removeDatas()
            }else{
                SP_HUD.show(text:error)
            }
            
        }
    }
    fileprivate func removeDatas() {
        _datas.isFollow = false
        makeUI()
        sp_Notification.post(name: ntf_Name_自选删除, object: _datas)
        self.tableView.reloadData()
    }
    
    fileprivate func t_添加自选数据() {
        
        SP_HUD.show(view:self.view, type:.tLoading, text:sp_localized("+ 自选") )
        My_API.t_添加自选数据(code:_datas.code).post(M_Attention.self) { [weak self](isOk, data, error) in
            SP_HUD.hidden()
            if isOk {
                SP_HUD.show(text:sp_localized("已加自选"))
                self?._datas.isFollow = true
                self?.makeUI()
                sp_Notification.post(name: ntf_Name_自选添加, object: self != nil ? self!._datas : nil)
                
                self?.tableView.cyl_reloadData()
            }else{
                SP_HUD.show(text:error)
            }
            
        }
    }
    
    
    
    
}








