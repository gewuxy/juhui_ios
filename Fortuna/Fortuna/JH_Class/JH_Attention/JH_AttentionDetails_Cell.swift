//
//  JH_AttentionDetails_Cell.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/3.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
/*
extension JH_AttentionDetailsCell_Charts {
    lazy var _stock:YYStock = {
        YYStockVariable.setStockLineWidthArray([6,6,6,6])
        let stock = YYStock(frame: self.view_charts.frame, dataSource: self)
        
        self.view_charts.addSubview(stock!.mainView)
        stock!.mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(JH_AttentionDetailsCell_Charts.stock_enterFullScreen(_:)))
        tap.numberOfTapsRequired = 1
        stock!.containerView.addGestureRecognizer(tap)
        for item in stock!.containerView.subviews {
            item.isUserInteractionEnabled = false
        }
        //stock!.containerView.subviews.set
        return stock!
    }()
    
    lazy var fullScreenView:YYStockFullScreenView = {
        let view = YYStockFullScreenView.show()
        return view
    }()
    
    let fiveRecordModel = YYFiveRecordModel()
    
    var stockDatadict:[String:[Any]] = [:]
    let stockDataKeyArray = ["分时","五日","日K","周K","月K"]
    let stockTopBarTitleArray = ["分时","五日","日K","周K","月K"]
    fileprivate func makeChartsView() {
        
    }
    // -- 进入全屏
    func stock_enterFullScreen(_ tap: UITapGestureRecognizer) {
        for item in _stock.containerView.subviews {
            item.isUserInteractionEnabled = true
        }
        tap.isEnabled = false
        
        UIApplication.shared.isStatusBarHidden = true
        fullScreenView.addSubview(_stock.mainView)
        _stock.mainView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(66)
        }
        fullScreenView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        _stock.draw()
    }
    // -- 退出全屏
    func stock_exitFullScreen() {
        for item in _stock.containerView.subviews {
            item.isUserInteractionEnabled = false
        }
        
        //fullScreenView.snapshotView(afterScreenUpdates: false)
        //fullScreenView.addSubview(<#T##view: UIView##UIView#>)
        
        _stock.mainView.layoutSubviews()
        YYStockVariable.setStockLineWidthArray([6,6,6,6])
        _stock.draw()
        UIView.animate(withDuration: 0.3, animations: {
            self.fullScreenView.alpha = 0
        }) { (bool) in
            self.fullScreenView.removeFromSuperview()
        }
        
        UIApplication.shared.isStatusBarHidden = false
        _stock.containerView.gestureRecognizers?.first?.isEnabled = true
    }
    
    
}
extension JH_AttentionDetailsCell_Charts:YYStockDataSource {
    func titleItems(of stock: YYStock!) -> [String]! {
        return stockTopBarTitleArray
    }
    func yyStock(_ stock: YYStock!, stockDatasOf index: Int) -> [Any]! {
        return index < self.stockDataKeyArray.count ? self.stockDatadict[self.stockDataKeyArray[index]] : nil
    }
    func stockType(of index: Int) -> YYStockType {
        return index == 0 ? YYStockType.timeLine : YYStockType.timeLine
    }
    func fiveRecordModel(of index: Int) -> YYStockFiveRecordProtocol! {
        return fiveRecordModel
    }
    func isShowfiveRecordModel(of index: Int) -> Bool {
        return false
    }
}
*/
/*
extension JH_AttentionDetailsCell_Charts:Y_StockChartViewDataSource {
    
    var _type = ""
    var _currentIndex = -1
    lazy var _stockChartView:Y_StockChartView = {
        let view = Y_StockChartView()
        view.itemModels = [Y_StockChartViewItemModel.init(title: "指标", type: .chartcenterViewTypeOther),
                           Y_StockChartViewItemModel.init(title: "分时", type: .chartcenterViewTypeTimeLine),
                           Y_StockChartViewItemModel.init(title: "1分", type: .chartcenterViewTypeKline),
                           Y_StockChartViewItemModel.init(title: "5分", type: .chartcenterViewTypeKline),
                           Y_StockChartViewItemModel.init(title: "30分", type: .chartcenterViewTypeKline),
                           Y_StockChartViewItemModel.init(title: "60分", type: .chartcenterViewTypeKline),
                           Y_StockChartViewItemModel.init(title: "日线", type: .chartcenterViewTypeKline),
                           Y_StockChartViewItemModel.init(title: "周线", type: .chartcenterViewTypeKline),
        ]
        
        view.dataSource = self
        self.view_charts.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return view
    }()
    
    var _groupModel = Y_KLineGroupModel()
    var _modelsDict:[String:Y_KLineGroupModel] = [:]
    fileprivate func makeChartsView() {
        _currentIndex = -1
        _stockChartView.backgroundColor = UIColor.background()
    }
    
    fileprivate func reloadData(){
        let param = ["type":_type,"symbol":"huobibtccny","size":"300"]
        SP_Alamofire.post("https://www.btc123.com/kline/klineapi", param: param) { [weak self](isOk, res, error) in
            if isOk {
                if let json = res as? [String:Any], let bool = json["isSuc"] as? Bool, bool {
                    if let arr = json["datas"] as? [Any] {
                        
                        self?._groupModel = Y_KLineGroupModel.object(with: arr)
                        
                        self?._modelsDict[self!._type] = self!._groupModel
                        self?._stockChartView.reloadData()
                        
                    }
                }
                
                
            }
            
        }
    }
    func stockDatas(with index: Int) -> Any! {
        switch index {
        case 0:
            _type = "1min";
            
        case 1:
            _type = "1min";
            
        case 2:
            _type = "1min";
            
        case 3:
            _type = "5min";
            
        case 4:
            _type = "30min";
            
        case 5:
            _type = "1hour";
            
        case 6:
            _type = "1day";
            
        case 7:
            _type = "1week";
            
        default:
            break
        }
        _currentIndex = index
        if (_modelsDict[_type] == nil) {
            reloadData()
        }else{
            if let model = _modelsDict[_type] {
                return model.models
            }
            
        }
        return nil
    }
}
 */
