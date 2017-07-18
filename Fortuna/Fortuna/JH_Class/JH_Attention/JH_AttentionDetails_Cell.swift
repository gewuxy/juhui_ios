//
//  JH_AttentionDetails_Cell.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/3.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
/*
extension JH_AttentionDetailsCell_Charts:YKLineChartViewDelegate {
    func makeYKLineChartView(_ array:[YKLineEntity]) {
        let dataset = YKLineDataSet()
        let arr:NSMutableArray = NSMutableArray(array: array)
        dataset.data = arr
        //经纬线
        dataset.highlightLineColor = UIColor.main_btnNormal
        dataset.highlightLineWidth = 0.7;
        //涨
        dataset.candleRiseColor = UIColor.red
        //跌
        dataset.candleFallColor = UIColor.green
        dataset.avgLineWidth = 1
        //        dataset.avgMA10Color = [UIColor colorWithRed:252/255.0 green:85/255.0 blue:198/255.0 alpha:1.0];
        //        dataset.avgMA5Color = [UIColor colorWithRed:67/255.0 green:85/255.0 blue:109/255.0 alpha:1.0];
        //        dataset.avgMA20Color = [UIColor colorWithRed:216/255.0 green:192/255.0 blue:44/255.0 alpha:1.0];
        dataset.candleTopBottmLineWidth = 1
        _ykLineChartView.setupChartOffset(withLeft: 5, top: 5, right: 5, bottom: 5)
        _ykLineChartView.gridBackgroundColor = UIColor.white
        
        _ykLineChartView.borderColor = UIColor.main_string("#CBD7E0")
        _ykLineChartView.borderWidth = 0.5;
        _ykLineChartView.candleWidth = 8;
        _ykLineChartView.candleMaxWidth = 30;
        _ykLineChartView.candleMinWidth = 1;
        _ykLineChartView.uperChartHeightScale = 0.7;
        _ykLineChartView.xAxisHeitht = 25;
        _ykLineChartView.delegate = self;
        _ykLineChartView.highlightLineShowEnabled = true;
        _ykLineChartView.zoomEnabled = true;
        _ykLineChartView.scrollEnabled = true;
        _ykLineChartView.setupData(dataset)
    }
    
    func makeYKTimeLineView(_ array:[YKTimeLineEntity]) {
        let dataset = YKTimeDataset()
        let arr:NSMutableArray = NSMutableArray(array: array)
        dataset.data = arr
        dataset.avgLineCorlor = UIColor.main_string("#FDB308")
        dataset.priceLineCorlor = UIColor.main_3
        dataset.volumeTieColor = UIColor.main_1
        dataset.volumeRiseColor = UIColor.main_1
        dataset.volumeFallColor = UIColor.main_1
        dataset.fillStartColor = UIColor.main_3
        dataset.fillStopColor = UIColor.white
        dataset.fillAlpha = 0.5
        dataset.drawFilledEnabled = true
        
        dataset.lineWidth = 1
        dataset.highlightLineColor = UIColor.main_string("#3C4C6D")
        dataset.highlightLineWidth = 0.7;
        
        
        _ykTimeLineView.setupChartOffset(withLeft: 5, top: 5, right: 5, bottom: 5)
        _ykTimeLineView.gridBackgroundColor = UIColor.white
        
        _ykTimeLineView.borderColor = UIColor.main_string("#CBD7E0")
        _ykTimeLineView.borderWidth = 0.5;
        _ykTimeLineView.uperChartHeightScale = 0.7;
        _ykTimeLineView.countOfTimes = array.count + 1
        _ykTimeLineView.minTime = "123"
        _ykTimeLineView.xAxisHeitht = 25
        _ykTimeLineView.endPointShowEnabled = true
        _ykTimeLineView.delegate = self;
        _ykTimeLineView.highlightLineShowEnabled = true;
        //_ykTimeLineView.zoomEnabled = true;
        //_ykTimeLineView.scrollEnabled = true;
        _ykTimeLineView.setupData(dataset)
    }
    
    func chartKlineScrollLeft(_ chartView: YKViewBase!) {
        
    }
    func chartValueNothingSelected(_ chartView: YKViewBase!) {
        
    }
    func chartValueSelected(_ chartView: YKViewBase!, entry: Any!, entryIndex: Int) {
        
    }
}
*/
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







/*
 cell?.ccTimeLineChart.isHidden = false
 cell?.ccKLineChart.isHidden = true
 var arr = [CCLTimeModel]();
 for item in datas {
 let model = CCLTimeModel()
 model.mAvgData = String(format:"%.2f",(CGFloat(Double(item.open_price) ?? 0)+CGFloat(Double(item.close_price) ?? 0))/2)
 model.barTime = item.timestamp
 model.closePrice = CGFloat(Double(item.close_price) ?? 0)
 model.highPrice = CGFloat(Double(item.high_price) ?? 0)
 model.lowPrice = CGFloat(Double(item.low_price) ?? 0)
 model.openPrice = CGFloat(Double(item.open_price) ?? 0)
 model.totalVolume = CGFloat(Double(item.num) ?? 0)
 arr.append(model)
 }
 cell?.ccTimeLineChart.aboveView.dataArr = NSMutableArray.init(array: arr)
 cell?.ccTimeLineChart.belowView.dataArr = NSMutableArray.init(array: arr)
 cell?.ccTimeLineChart.aboveView.sp_reloadData()
 cell?.ccTimeLineChart.belowView.sp_reloadData()
 */
/*
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
 cell?.makeYKTimeLineView(array)*/
/*
 var arr:[Double] = []
 for item in datas {
 arr.append(Double(item.high_price)!)
 }
 cell?._lineBgView._timeLineData = arr
 */





/*
 cell?.ccKLineChart.isHidden = false
 cell?.ccTimeLineChart.isHidden = true
 
 var arr = [CCLKLineData]();
 for item in datas {
 let model = CCLKLineData()
 //model.mAvgData = String(format:"%.2f",(CGFloat(Double(item.open_price) ?? 0)+CGFloat(Double(item.close_price) ?? 0))/2)
 model.tradedate = item.timestamp
 model.closeprice = CGFloat(Double(item.close_price) ?? 0)
 model.highestprice = CGFloat(Double(item.high_price) ?? 0)
 model.lowestprice = CGFloat(Double(item.low_price) ?? 0)
 model.openprice = CGFloat(Double(item.open_price) ?? 0)
 model.total_value_trade = CGFloat(Double(item.turnover_rate) ?? 0)
 arr.append(model)
 }
 cell?.ccKLineChart.aboveView.dataArr = NSMutableArray.init(array: arr)
 cell?.ccKLineChart.belowView.dataArr = NSMutableArray.init(array: arr)
 
 cell?.ccKLineChart.aboveView.sp_reloadData()
 cell?.ccKLineChart.belowView.sp_reloadData()
 */
/*
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
 */

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

