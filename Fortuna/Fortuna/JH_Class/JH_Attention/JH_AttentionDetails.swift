//
//  JH_AttentionDetails.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/20.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import SocketIO
import SwiftyJSON
import RxCocoa
import RxSwift
class JH_AttentionDetails: SP_ParentVC {

    static var _modelsDict:[String:Y_KLineGroupModel] = [:]
    static var _selectType = JH_ChartDataType.t分时
    
    let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view_toolBar: UIView!
    @IBOutlet weak var btn_remove: UIButton!
    @IBOutlet weak var btn_placeOrder: UIButton!
    @IBOutlet weak var btn_chateau: UIButton!
    
    fileprivate enum sectionType:Int {
        case tData = 0
        case tCharts
        case tNews
    }
    lazy var _tUnfoldOpen = false
    
    lazy var _datas = M_Attention()
    lazy var _dataDetails = M_AttentionDetail()
    lazy var _datasDelegate = [M_MyDelegate]()
    lazy var _dataNews = [M_News]()
    
    //type:JH_ChartDataType, _ cell:JH_AttentionDetailsCell_Charts
    
    var _cell:JH_AttentionDetailsCell_Charts?
    
    
}

extension JH_AttentionDetails {
    override class func initSPVC() -> JH_AttentionDetails {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_AttentionDetails") as! JH_AttentionDetails
    }
    class func show(_ parentVC:UIViewController?, data:M_Attention) {
        let vc = JH_AttentionDetails.initSPVC()
        vc._datas = data
        var model = M_AttentionDetail()
        model.lastest_price = data.last_price
        vc._dataDetails = model
        vc.hidesBottomBarWhenPushed = true
        parentVC?.navigationController?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        JH_AttentionDetails._modelsDict.removeAll()
        self.makeNotification()
        self.makeNavigation()
        self.makeUI()
        self.makeTableView()
        //self.t_详情页基础数据()
        self.makeSocketIO()
        self.sp_addMJRefreshHeader()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.t_单品委托列表()
        self.t_详情页基础数据()
        
    }
    
    
    fileprivate func makeNavigation() {
        n_view._title = _datas.name
        n_view.n_btn_C1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        //n_view._detailTitle = "交易中"
        //n_view.n_label_C1.textColor = UIColor.white.withAlphaComponent(0.3)
        //n_view.n_label_C1.font = UIFont.boldSystemFont(ofSize: 12)
        //n_view.n_label_C1_H.constant = 12
        //n_view.n_label_C1_B.constant = 5
        //n_view.n_btn_R1_Image = "Attention分享"
        //n_view.n_btn_R1_R.constant = 15
    }
    
    fileprivate func makeUI() {
        
        btn_remove.setTitle(sp_localized(_datas.isFollow ? "删除自选" : "+ 自选") , for: .normal)
        btn_remove.setTitleColor(_datas.isFollow ? UIColor.mainText_3 : UIColor.mainText_1, for: .normal)
        
        
    }
    fileprivate func makeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    fileprivate func makeNotification() {
        sp_Notification.rx
            .notification(SP_User.shared.ntfName_成功登陆了)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](n) in
                
                self?.t_单品委托列表()
                
            }).addDisposableTo(disposeBag)
        sp_Notification.rx
            .notification(SP_User.shared.ntfName_退出登陆了)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](n) in
                self?._datasDelegate.removeAll()
            }).addDisposableTo(disposeBag)
        
        sp_Notification.rx
            .notification(ntf_Name_撤销委托)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](n) in
                self?.t_单品委托列表()
            }).addDisposableTo(disposeBag)
        
        sp_Notification.rx
            .notification(ntf_Name_K线选择更新)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](n) in
                self?.tableView.reloadData()
            }).addDisposableTo(disposeBag)
    }
    override func clickN_btn_R1() {
        /*
        SP_UMView.show({ [unowned self](type) in
            SP_UMShare.shared.showDefault(self,viewType:.tCustom(platformType: type), shareTitle: self._dataDetails.shareTitle, shareText: self._dataDetails.shareText, shareImage: self._dataDetails.shareImg, shareURL: self._dataDetails.shareLink,  block: { (isOk) in
                
            })
        })*/
    }
    
    @IBAction func clickToolBarBtn(_ sender: UIButton) {
        switch sender {
        case btn_placeOrder:
            guard SP_User.shared.userIsLogin else {
                SP_Login.show(self) { (isOk) in
                    
                }
                return
            }
            JH_HUD_PlaceOrder.show({ [unowned self]tag in
                switch tag {
                case 0:
                    JH_BuyAndSell.show(self, type: .t买入, data:self._datas, dataDetails:self._dataDetails)
                case 1:
                    JH_BuyAndSell.show(self, type: .t卖出, data:self._datas, dataDetails:self._dataDetails)
                case 2:
                    
                    if self._datasDelegate.count > 0 {
                        JH_MyTodayDelegate.show(self, dType:.t单品委托列表(datas: self._datasDelegate, title: self._datas.name))
                    }else{
                        UIAlertController.showAler(self, btnText: [sp_localized("取消"),sp_localized("买入")], title: sp_localized("当前没有委托单\n您可以买入"), message: "", block: { [unowned self](str) in
                            if str == sp_localized("买入") {
                                JH_BuyAndSell.show(self, type: .t买入, data:self._datas, dataDetails:self._dataDetails)
                            }
                        })
                    }
                default:break
                }
            })
        case btn_chateau:
            JH_IM.show(self, followData:_datas)
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
extension JH_AttentionDetails:UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionType.tNews.rawValue + 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case sectionType.tData.rawValue:
            return _tUnfoldOpen ? 2 : 2
        case sectionType.tCharts.rawValue:
            return 1
        case sectionType.tNews.rawValue:
            return _dataNews.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case sectionType.tNews.rawValue:
            return sp_SectionH_Top
        default:
            return sp_SectionH_Min
        }
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sp_SectionH_Foot
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case sectionType.tData.rawValue:
            return indexPath.row == 0 ? sp_fitSize((100,115,130)) : sp_fitSize((70,75,80))
        case sectionType.tCharts.rawValue:
            return sp_fitSize((288,308,338))
        case sectionType.tNews.rawValue:
            return 90 //sp_fitSize((288,308,338))
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case sectionType.tNews.rawValue:
            let view = UIView()
            view.backgroundColor = UIColor.white
            return view
        default:
            return nil
        }
    }
}
extension JH_AttentionDetails:UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case sectionType.tData.rawValue:
            if indexPath.row == 0 {
                let cell = JH_AttentionDetailsCell_Data.show(tableView, indexPath, openBlock:nil)
                //cell.btn_unfold.setImage(UIImage(named: _tUnfoldOpen ? "Attention置顶" : "Attention展开"), for: .normal)
                cell.lab_price.text = _dataDetails.lastest_price
                cell.lab_range.text = _dataDetails.increase_ratio
                cell.lab_MOL.text = _dataDetails.increase
                
                cell.lab_tall.text = _dataDetails.highest_price
                cell.lab_low.text = _dataDetails.lowest_price
                cell.lab_rate.text = _dataDetails.amplitude
                cell.lab_ratio.text = _dataDetails.ratio
                return cell
            }else{
                let cell = JH_AttentionDetailsCell_Unfold.show(tableView, indexPath)
                cell.lab_PRE.text = _dataDetails.deal_count
                cell.lab_InSize.text = _dataDetails.turnover
                cell.lab_Up.text = _dataDetails.turnover_rate
                cell.lab_MktCap.text = _dataDetails.total_market_value
                return cell
            }
        case sectionType.tCharts.rawValue:
            let cell = JH_AttentionDetailsCell_Charts.show(tableView, indexPath)
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
            cell._datas = _datas
            makeBuyAndSell(cell)
            self._cell = cell
            cell.btn_top5.imageEdgeInsets = UIEdgeInsetsMake(15, sp_fitSize((40,42,46)), 15, sp_fitSize((5,5,5)))
            cell._getDataBlock = { [weak self]type in
                JH_AttentionDetails._selectType = type
                self?.getLineData(JH_AttentionDetails._selectType, cell)
            }
            cell._blockFullScreen = {[weak self]_ in
                guard self != nil else{return}
                JH_AttentionDetailsFull.show(self, data: self!._datas, dataDetails:self!._dataDetails)
            }
            return cell
        case sectionType.tCharts.rawValue:
            let model = _dataNews[indexPath.row]
            let cell = JH_NewsCell_List.show(tableView)
            cell.img_Logo.sp_ImageName(model.thumb_img)
            cell.lab_name.text = model.title
            cell.lab_time.text = model.newsYY
            cell.lab_time2.text = model.newsMM
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == sectionType.tNews.rawValue {
            //JH_AttentionDetailsFull.show(self, data: _datas, dataDetails:_dataDetails)
            JH_NewsDetials.show(self,data:_dataNews[indexPath.row])
        }
        
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
extension JH_AttentionDetails {
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
    
    fileprivate func testReloadData(_ type:JH_ChartDataType, _ cell:JH_AttentionDetailsCell_Charts?) {
        cell?.view_charts.bringSubview(toFront: cell!.view_activi)
        cell?.view_activi.isHidden = false
        cell?.view_activi.startAnimating()
        cell?.lab_error.isHidden = true
        let param = ["type":type.testString,"symbol":"huobibtccny","size":"300"]
        SP_Alamofire.post("https://www.btc123.com/kline/klineapi", param: param) { [weak cell](isOk, res, error) in
            cell?.view_activi.isHidden = true
            cell?.view_activi.stopAnimating()
            
            if isOk {
                if let json = res as? [String:Any], let bool = json["isSuc"] as? Bool, bool {
                    if let arr = json["datas"] as? [Any] {
                        var _groupModel = Y_KLineGroupModel()
                        _groupModel = Y_KLineGroupModel.object(with: arr)
                        
                        JH_AttentionDetails._modelsDict[type.stringValue] = _groupModel
                        cell?._stockChartView.reloadData()
                        
                    }
                }
                
                
            }
            
        }
    }
}

extension JH_AttentionDetails {
    fileprivate func sp_addMJRefreshHeader() {
        tableView?.sp_headerAddMJRefresh { [weak self]_ in
            
            self?.t_详情页基础数据()
        }
    }
    fileprivate func sp_addMJRefreshFooter() {
        tableView?.sp_footerAddMJRefresh_Auto { _ in
            
        }
    }
    
    fileprivate func sp_EndRefresh()  {
        tableView?.sp_headerEndRefresh()
        tableView?.sp_footerEndRefresh()
    }
    fileprivate func t_详情页基础数据() {
        My_API.t_详情页基础数据(code: _datas.code).post(M_AttentionDetail.self) { [weak self](isOk, data, error) in
            if isOk {
                guard let datas = data as? M_AttentionDetail else{return}
                self?._dataDetails = datas
                self?._datas.proposedPrice = datas.lastest_price
                let rows = [IndexPath(row: 0, section: 0),IndexPath(row: 1, section: 0)]
                self?.tableView.reloadRows(at: rows, with: .none)
            }else{
                SP_HUD.show(text:error)
            }
        }
    }
    
    fileprivate func t_单品委托列表() {
        My_API.t_单品委托列表(code: _datas.code).post(M_MyDelegate.self) { [weak self](isOk, data, error) in
            guard self != nil else{return}
            if isOk {
                guard let datas = data as? [M_MyDelegate] else{return}
                self!._datasDelegate = datas
            }else{
                //SP_HUD.showMsg(error)
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








