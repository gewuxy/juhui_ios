//
//  SP_LineBgView.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/5.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import Charts

enum SP_LineBgViewType {
    case tKLine
    case tTimeLine
}

class SP_LineBgView: UIView {
   
    lazy var _timeLineView:CombinedChartView = {
        let view = CombinedChartView()
        //view.delegate = self;
        
        view.legend.enabled = false
        view.chartDescription?.enabled = false;
        view.drawGridBackgroundEnabled = false;
        view.drawBarShadowEnabled = false;
        view.highlightFullBarEnabled = false;
        view.drawOrder = [DrawOrder.line.rawValue,
                          //DrawOrder.bar.rawValue,
                          //DrawOrder.candle.rawValue,
            
        ]
        view.isHidden = true
        view.scaleYEnabled = false
        view.scaleXEnabled = false
        view.doubleTapToZoomEnabled = false
        return view
    }()
    
    lazy var _kLineView:CombinedChartView = {
        let view = CombinedChartView()
        //view.delegate = self;
        
        view.legend.enabled = false
        view.chartDescription?.enabled = false;
        view.drawGridBackgroundEnabled = false;
        view.drawBarShadowEnabled = false;
        view.highlightFullBarEnabled = false;
        
        view.drawOrder = [//DrawOrder.bar.rawValue,
                          DrawOrder.candle.rawValue,
                          //DrawOrder.line.rawValue,
        ]
        view.isHidden = true
        view.scaleYEnabled = false
        view.scaleXEnabled = false
        view.doubleTapToZoomEnabled = false
        return view
    }()

    var _lineType:SP_LineBgViewType = .tTimeLine {
        didSet{
            switch _lineType {
            case .tTimeLine:
                _timeLineView.isHidden = false
                _kLineView.isHidden = true
                
            case .tKLine:
                _timeLineView.isHidden = true
                _kLineView.isHidden = false
            }
        }
    }
    
    lazy var chartData:CombinedChartData = {
        return CombinedChartData()
    }()
    
    
    var _timeLineData:[Double] = [] {
        didSet{
            makeChartView(_timeLineView)
            makeTimeLineData(_timeLineView)
        }
    }
    
    var _kLineData:[(val:Double,high:Double,low:Double,open:Double,close:Double)] = [] {
        didSet{
            makeChartView(_kLineView)
            makeKLineData(_kLineView)
        }
    }
    
}
extension SP_LineBgView {
    class func show() -> SP_LineBgView {
        let view = (Bundle.main.loadNibNamed("SP_LineBgView", owner: nil, options: nil)!.first as? SP_LineBgView)!
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addSubview(_timeLineView)
        _timeLineView.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(-10)
            make.bottom.trailing.equalToSuperview().offset(10)
        }
//        self.addSubview(_kLineView)
//        _kLineView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
    }
    
    
    func makeChartView(_ chartView:CombinedChartView){
        
        let l = chartView.legend;
        l.wordWrapEnabled = true
        l.horizontalAlignment = .center;
        l.verticalAlignment = .bottom;
        l.orientation = .horizontal;
        l.drawInside = false;
        
        
        let xAxis = chartView.xAxis;
        xAxis.enabled = false
        xAxis.drawGridLinesEnabled = false;
        xAxis.labelPosition = .bottom
        xAxis.axisMinimum = 0.0;
        xAxis.granularity = 0.0;
        
        //xAxis.valueFormatter = self;
        
        
        let leftAxis = chartView.leftAxis;
        leftAxis.drawGridLinesEnabled = false;
        leftAxis.axisMinimum = 0.0
        leftAxis.enabled = false
        leftAxis.gridAntialiasEnabled = true
        leftAxis.forceLabelsEnabled = true
        
        
        let rightAxis = chartView.rightAxis;
        rightAxis.drawGridLinesEnabled = false;
        rightAxis.axisMinimum = 0.0
        rightAxis.enabled = false
        
        
        //let limitLine = ChartLimitLine()
        
        
    }
    
    func makeTimeLineData(_ chartView:CombinedChartView) {
        
        chartData.lineData = getLineData()
        
        //chartData.barData = getLineBarData()
        //chartData.candleData = getCandleData()
        
        chartView.xAxis.axisMaximum = chartData.xMax + 0.25;
        chartView.data = chartData;
        
        
        /*
         data.barData = [self generateBarData];
         data.bubbleData = [self generateBubbleData];
         data.scatterData = [self generateScatterData];
         data.candleData = [self generateCandleData];
         
         _chartView.xAxis.axisMaximum = data.xMax + 0.25;
         
         _chartView.data = data;*/
    }
    func makeKLineData(_ chartView:CombinedChartView) {
        
        //chartData.lineData = getLineData()
        //chartData.barData = getBarData()
        chartData.candleData = getCandleData()
        
        chartView.xAxis.axisMaximum = chartData.xMax + 0.25;
        chartView.data = chartData;
        
        
        /*
         data.barData = [self generateBarData];
         data.bubbleData = [self generateBubbleData];
         data.scatterData = [self generateScatterData];
         data.candleData = [self generateCandleData];
         
         _chartView.xAxis.axisMaximum = data.xMax + 0.25;
         
         _chartView.data = data;*/
    }
    
    func getLineData() -> LineChartData {
        let d = LineChartData()
        
        var entries = [ChartDataEntry]()
        
        for (index,item) in _timeLineData.enumerated()
        {
            entries.append(ChartDataEntry(x: Double(index) + 0.5,
                                          y: item))
            
        }
        
        let set = LineChartDataSet()
        set.values = entries
        
        set.setColor(UIColor.main_btnNormal)
        set.lineWidth = 0.5;
        //拐点
        set.drawCirclesEnabled = false
        //空心
        set.drawCircleHoleEnabled = false
        //set.setCircleColor(UIColor.clear)
        //set.circleRadius = 0.0;
        //set.circleHoleRadius = 0;
        
        
        set.mode = .linear;
        
        set.drawValuesEnabled = false;//是否在拐点显示数据
        //set.valueFont = UIFont.systemFont(ofSize: 0)
        //set.valueTextColor = UIColor.clear
        set.drawFilledEnabled = true
        set.fillColor = UIColor.main_btnNormal
        set.fillAlpha = 0.3
        set.axisDependency = .left;
        d.addDataSet(set)
        
        return d;
    }
    
    func getLineBarData() -> BarChartData {
        let d = BarChartData()
        return d
    }
    
    
    func getKLineBarData() -> BarChartData {
        let d = BarChartData()
        
        var entries1 = [BarChartDataEntry]()
        for (index,item) in _timeLineData.enumerated()
        {
            entries1.append(BarChartDataEntry(x: Double(index) + 0.5,
                                          y: item))
            
        }
        
        let set1 = BarChartDataSet()
        set1.values = entries1
        set1.setColor(UIColor(red: 60/255, green: 220/255, blue: 78/255, alpha: 1.0))
        
        set1.valueTextColor = UIColor(red: 60/255, green: 220/255, blue: 78/255, alpha: 1.0)
        set1.valueFont = UIFont.systemFont(ofSize: 10)
        set1.axisDependency = .left
        
        let groupSpace = 0.06;
        let barSpace = 0.02;
        let barWidth = 0.45;
        d.barWidth = barWidth
        d.groupBars(fromX: 0.0, groupSpace: groupSpace, barSpace: barSpace)
        return d
    }
    
    
    func getCandleData() -> CandleChartData {
        let d = CandleChartData()
        
        var yVals1 = [CandleChartDataEntry]()
        
        for (index,item) in _kLineData.enumerated()
        {
            
            let val = item.val
            let high = item.high
            let low = item.low
            let open = item.open
            let close = item.close
            let even = open - close > 0;
            
            yVals1.append(CandleChartDataEntry(x: Double(index), shadowH: val + high, shadowL: val - low, open: even ? val + open : val - open, close: even ? val - close : val + close))
        }
        
        let set1 = CandleChartDataSet()
        set1.values = yVals1
        set1.axisDependency = .left;
        set1.setColor(UIColor(white: 80/255, alpha: 1.0))
        
        
        set1.drawIconsEnabled = false;
        
        set1.shadowColor = UIColor.darkGray;
        set1.shadowWidth = 0.7;
        set1.decreasingColor = UIColor.red;
        set1.decreasingFilled = true;
        set1.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1.0)
        
        set1.increasingFilled = false;
        set1.neutralColor = UIColor.blue;
        
        d.addDataSet(set1)
        return d;
    }
    
}
