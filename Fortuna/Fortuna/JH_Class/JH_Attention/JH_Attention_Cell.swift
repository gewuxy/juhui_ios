//
//  JH_Attention_Cell.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/13.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import SwiftyJSON


enum JH_ChartDataType:Int {
    case t分时 = 0
    case t5日
    case t日K
    case t周K
    case t月K
    case t1分
    case t5分
    case t10分
    case t30分
    case t60分
    
    var stringValue:String {
        switch self {
        case .t分时:return "分时"
        case .t5日:return "5日"
        case .t日K:return "日K"
        case .t周K:return "周K"
        case .t月K:return "月K"
        case .t1分:return "1分"
        case .t5分:return "5分"
        case .t10分:return "10分"
        case .t30分:return "30分"
        case .t60分:return "60分"
            
        }
    }
    
    var periodValue:String {
        switch self {
        case .t分时:return "1d"
        case .t5日:return "5d"
        case .t日K:return "1d"
        case .t周K:return "7d"
        case .t月K:return "30d"
        case .t1分:return "1m"
        case .t5分:return "5m"
        case .t10分:return "10m"
        case .t30分:return "30m"
        case .t60分:return "60m"
            
        }
    }
    
    var testString:String {
        switch self {
        case .t分时:return "1min"
        case .t5日:return "1min"
        case .t日K:return "1day"
        case .t周K:return "1week"
        case .t月K:return "1min"
        case .t1分:return "1min"
        case .t5分:return "5min"
        case .t10分:return "1min"
        case .t30分:return "30min"
        case .t60分:return "1hour"
            
        }
    }
}

//MARK:--- 自选页面 -----------------------------
class JH_AttentionCell_Normal: UITableViewCell {
    class func show(_ tableView:UITableView) -> JH_AttentionCell_Normal {
        return tableView.dequeueReusableCell(withIdentifier: "JH_AttentionCell_Normal") as! JH_AttentionCell_Normal
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view_line.backgroundColor = UIColor.main_line
        lab_name.textColor = UIColor.mainText_1
        lab_code.textColor = UIColor.mainText_3
        
        lab_range.textColor = UIColor.mainText_4
        
        lab_name.font = SP_InfoOC.sp_fontFit(withSize: 20, weightType: tRegular)
        lab_code.font = SP_InfoOC.sp_fontFit(withSize: 18, weightType: tMedium)
        lab_price.font = SP_InfoOC.sp_fontFit(withSize: 20, weightType: tRegular)
        lab_range.font = SP_InfoOC.sp_fontFit(withSize: 20, weightType: tMedium)
        
        
        lab_price_W.constant = sp_fitSize((80,90,100))
        lab_range_W.constant = sp_fitSize((80,90,100))
        
        
    }
    @IBOutlet weak var view_line: UIView!
    @IBOutlet weak var lab_name: UILabel!
    @IBOutlet weak var lab_code: UILabel!
    @IBOutlet weak var lab_price: UILabel!
    @IBOutlet weak var lab_range: UILabel!
    @IBOutlet weak var lab_price_W: NSLayoutConstraint!
    @IBOutlet weak var lab_range_W: NSLayoutConstraint!
    
}
//MARK:--- 编辑页面 -----------------------------
class JH_AttentionCell_Edit: UITableViewCell {
    class func show(_ tableView:UITableView, _ indexPath:IndexPath) -> JH_AttentionCell_Edit {
        return tableView.dequeueReusableCell(withIdentifier: "JH_AttentionCell_Edit") as! JH_AttentionCell_Edit
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view_line.backgroundColor = UIColor.main_line
        lab_name.textColor = UIColor.mainText_1
        
        lab_name.font = sp_fitFont18
        
        btn_select.setTitleColor(UIColor.mainText_1, for: .normal)
        btn_select.titleLabel?.font = sp_fitFont18
        
        btn_tap.setTitleColor(UIColor.mainText_1, for: .normal)
        btn_tap.titleLabel?.font = sp_fitFont18
    }
    
    @IBOutlet weak var view_line: UIView!
    @IBOutlet weak var lab_name: UILabel!
    @IBOutlet weak var btn_select: UIButton!
    @IBOutlet weak var btn_tap: UIButton!
    @IBOutlet weak var btn_toTop: UIButton!
    enum clickType {
        case tSelect
        case tToTop
    }
    var _block:((clickType)->Void)?
    @IBAction func clickBtn(_ sender: UIButton) {
        switch sender {
        case btn_select:
            _block?(.tSelect)
        case btn_tap:
            _block?(.tSelect)
        case btn_toTop:
            _block?(.tToTop)
        default:
            break
        }
    }
    
}
//MARK:--- 详情页面 -----------------------------
class JH_AttentionDetailsCell_Data: UITableViewCell {
    class func show(_ tableView:UITableView, _ indexPath:IndexPath, openBlock:(()->Void)? = nil) -> JH_AttentionDetailsCell_Data {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JH_AttentionDetailsCell_Data") as! JH_AttentionDetailsCell_Data
        //cell._clickBlock = openBlock
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeUI()
        
        
        
        
    }
    
    @IBOutlet weak var view_price: UIView!
    @IBOutlet weak var view_data: UIView!
    @IBOutlet weak var view_unfold: UIView!
    @IBOutlet weak var view_price_W: NSLayoutConstraint!
    
    @IBOutlet weak var lab_price: UILabel!//最新价
    @IBOutlet weak var lab_MOL: UILabel!//涨幅值
    @IBOutlet weak var lab_range: UILabel!//涨幅比例
    
    @IBOutlet weak var lab_tall: UILabel!//最高
    @IBOutlet weak var lab_low: UILabel!//最低
    @IBOutlet weak var lab_rate: UILabel!//振幅
    @IBOutlet weak var lab_ratio: UILabel!//量比
    
    @IBOutlet weak var lab_tall0: UILabel!
    @IBOutlet weak var lab_low0: UILabel!
    @IBOutlet weak var lab_rate0: UILabel!
    @IBOutlet weak var lab_ratio0: UILabel!
    
    fileprivate func makeUI() {
        view_price.backgroundColor = UIColor.clear
        view_data.backgroundColor = UIColor.clear
        view_unfold.backgroundColor = UIColor.clear
        view_price_W.constant = (sp_ScreenWidth-30)/2 //+20
        
        lab_price.font = UIFont.systemFont(ofSize: SP_InfoOC.sp_fit(withSize: 35))
        lab_MOL.font = UIFont.systemFont(ofSize: SP_InfoOC.sp_fit(withSize: 16))
        lab_range.font = UIFont.systemFont(ofSize: SP_InfoOC.sp_fit(withSize: 16))
        
        
        for item in view_data.subviews {
            if let lab = item as? UILabel {
                lab.font = sp_fitFont15
            }
        }
    }
    
}
class JH_AttentionDetailsCell_Unfold: UITableViewCell {
    class func show(_ tableView:UITableView, _ indexPath:IndexPath) -> JH_AttentionDetailsCell_Unfold {
        return tableView.dequeueReusableCell(withIdentifier: "JH_AttentionDetailsCell_Unfold") as! JH_AttentionDetailsCell_Unfold
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeUI()
    }
    
    @IBOutlet weak var view_line: UIView!
    @IBOutlet weak var view_bg: UIView!
    
    @IBOutlet weak var lab_PRE: UILabel!//成交量
    @IBOutlet weak var lab_InSize: UILabel!//成交额
    @IBOutlet weak var lab_Up: UILabel!//换手率
    @IBOutlet weak var lab_MktCap: UILabel!//总市值
    @IBOutlet weak var lab_PRE0: UILabel!
    @IBOutlet weak var lab_InSize0: UILabel!
    @IBOutlet weak var lab_Up0: UILabel!
    @IBOutlet weak var lab_MktCap0: UILabel!
    
    fileprivate func makeUI() {
        view_line.backgroundColor = UIColor.main_bg
        
        for item in view_bg.subviews {
            if let lab = item as? UILabel {
                lab.font = sp_fitFont16
            }
        }
    }
}

//MARK:--- 详情页面 全屏 -----------------------------
class JH_AttentionDetailsCell_DataFull: UITableViewCell {
    class func show(_ tableView:UITableView) -> JH_AttentionDetailsCell_DataFull {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JH_AttentionDetailsCell_DataFull") as! JH_AttentionDetailsCell_DataFull
        //cell._clickBlock = openBlock
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeUI()
        
        
        
        
    }
    
    @IBOutlet weak var view_price: UIView!
    @IBOutlet weak var view_data: UIView!
    @IBOutlet weak var view_unfold: UIView!
    @IBOutlet weak var view_price_W: NSLayoutConstraint!
    
    @IBOutlet weak var lab_price: UILabel!//最新价
    @IBOutlet weak var lab_MOL: UILabel!//涨幅值
    @IBOutlet weak var lab_range: UILabel!//涨幅比例
    
    @IBOutlet weak var lab_tall: UILabel!//最高
    @IBOutlet weak var lab_low: UILabel!//最低
    @IBOutlet weak var lab_rate: UILabel!//振幅
    @IBOutlet weak var lab_ratio: UILabel!//量比
    
    @IBOutlet weak var lab_tall0: UILabel!
    @IBOutlet weak var lab_low0: UILabel!
    @IBOutlet weak var lab_rate0: UILabel!
    @IBOutlet weak var lab_ratio0: UILabel!
    
    @IBOutlet weak var lab_PRE: UILabel!//成交量
    @IBOutlet weak var lab_InSize: UILabel!//成交额
    @IBOutlet weak var lab_Up: UILabel!//换手率
    @IBOutlet weak var lab_MktCap: UILabel!//总市值
    
    @IBOutlet weak var lab_PRE0: UILabel!
    @IBOutlet weak var lab_InSize0: UILabel!
    @IBOutlet weak var lab_Up0: UILabel!
    @IBOutlet weak var lab_MktCap0: UILabel!
    
    fileprivate func makeUI() {
        view_price.backgroundColor = UIColor.clear
        view_data.backgroundColor = UIColor.clear
        view_unfold.backgroundColor = UIColor.clear
        view_price_W.constant = (sp_ScreenWidth-30)/2 //+20
        
        lab_price.font = UIFont.systemFont(ofSize: SP_InfoOC.sp_fit(withSize: 35))
        lab_MOL.font = UIFont.systemFont(ofSize: SP_InfoOC.sp_fit(withSize: 16))
        lab_range.font = UIFont.systemFont(ofSize: SP_InfoOC.sp_fit(withSize: 16))
        
        
        for item in view_data.subviews {
            if let lab = item as? UILabel {
                lab.font = sp_fitFont15
            }
        }
    }
    
}



class JH_AttentionDetailsCell_Charts: UITableViewCell {
    class func show(_ tableView:UITableView, _ indexPath:IndexPath) -> JH_AttentionDetailsCell_Charts {
        return tableView.dequeueReusableCell(withIdentifier: "JH_AttentionDetailsCell_Charts") as! JH_AttentionDetailsCell_Charts
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        makeUI()
        //clickBtnTop(btn_top0)
        clickBtnDetails(btn_dtsL)
    }
    
    fileprivate func makeUI() {
        view_topLine.backgroundColor = UIColor.main_1
        // --- 顶部分段
        view_top_H.constant = sp_fitSize((35, 40, 45))
        btn_top6_W.constant = sp_fitSize((0,0, 0))
        // --- 右侧下拉时间
        view_time_H.constant = 0
        view_time_W.constant = sp_ScreenWidth/6//sp_fitSize((40, 50, 60))
        btn_time1_H.constant = sp_fitSize((35, 40, 45))
        view_time.isHidden = true
        //阴影
        view_time.backgroundColor = UIColor.white
        view_time.layer.shadowColor = UIColor.black.cgColor
        view_time.layer.shadowOffset = CGSize(width: 0, height: 5)
        view_time.layer.shadowOpacity = 0.9
        
        
        
        
        for item in view_time.subviews {
            if let btn = item as? UIButton {
                btn.setTitleColor(UIColor.mainText_1, for: .normal)
                btn.titleLabel?.font = sp_fitFont16
            }
        }
        // --- 右侧五档明细
        view_details_W.constant = sp_fitSize((105,120,135))
        view_detailsTop_H.constant = sp_fitSize((16,18,20))
        lab_sell5_W.constant = sp_fitSize((30,34,38))
        lab_buy1_W.constant = sp_fitSize((30,34,38))
        lab_sell5N_W.constant = sp_fitSize((22,26,30))
        lab_buy1N_W.constant = sp_fitSize((22,26,30))
        view_detailsLine.backgroundColor = UIColor.main_1
        for item in view_dtsLtop.subviews {
            if let lab = item as? UILabel {
                //lab.textColor = UIColor.main_1
                lab.font = sp_fitFont14
            }
        }
        for item in view_dtsLbottom.subviews {
            if let lab = item as? UILabel {
                //lab.textColor = UIColor.main_1
                lab.font = sp_fitFont14
            }
        }
        
        for item in view_detailsTop.subviews {
            if let btn = item as? UIButton {
                btn.setTitleColor(UIColor.mainText_1, for: .normal)
                btn.titleLabel?.font = sp_fitFont14
            }
        }
        
        // --- 图表
        makeChartsView()
    }
    //MARK:--- 顶部分段控件 -----------------------------
    @IBOutlet weak var view_top: UIView!
    @IBOutlet weak var view_top_H: NSLayoutConstraint!
    @IBOutlet weak var view_topLine: UIView!
    @IBOutlet weak var btn_top0: UIButton!
    @IBOutlet weak var btn_top1: UIButton!
    @IBOutlet weak var btn_top2: UIButton!
    @IBOutlet weak var btn_top3: UIButton!
    @IBOutlet weak var btn_top4: UIButton!
    @IBOutlet weak var btn_top5: UIButton!
    @IBOutlet weak var btn_top6: UIButton!
    @IBOutlet weak var btn_top6_W: NSLayoutConstraint!
    
    @IBAction func clickBtnTop(_ sender: UIButton) {
        
        
        switch sender {
        case btn_top5:
            _isOpen = !_isOpen
            
            
            showViewTime(_isOpen)
            btn_top5.setImage(UIImage(named:_isOpen ? "Attention置顶" : "Attention展开"), for: .normal)
            
        
        default:
            //隐藏或显示5挡图
            switch sender {
            case btn_top0:
                view_details_W.constant = sp_fitSize((105,120,135))
                view_details_L.constant = 10
                view_details_R.constant = 10
            default:
                view_details_W.constant = 0
                view_details_L.constant = 0
                view_details_R.constant = 0
            }
            if _isOpen {
                _isOpen = !_isOpen
                showViewTime(_isOpen)
                btn_top5.setImage(UIImage(named:_isOpen ? "Attention置顶" : "Attention展开"), for: .normal)
            }
            
            updateViewTopUI()
            sender.setTitleColor(UIColor.main_1, for: .normal)
            sender.titleLabel?.font = sp_fitFontB16
            view_topLine.snp.removeConstraints()
            view_topLine.snp.makeConstraints({ (make) in
                make.bottom.equalToSuperview()
                make.centerX.equalTo(sender)
                make.width.equalTo(sp_fitSize((28, 32, 36)))
                make.height.equalTo(2)
            })
            _type = JH_ChartDataType(rawValue: sender.tag)!
            _getDataBlock?(JH_ChartDataType(rawValue: sender.tag)!)
            _stockChartView.segmentView.selectedIndex =  UInt(sender.tag + 1)
            
        }
        
    }
    
    fileprivate func updateViewTopUI() {
        for item in view_top.subviews {
            if let btn = item as? UIButton {
                btn.setTitleColor(UIColor.mainText_1, for: .normal)
                btn.titleLabel?.font = sp_fitFont16
            }
        }
    }
    
    //MARK:--- 右侧分钟控件 -----------------------------
    @IBOutlet weak var view_time: UIView!
    @IBOutlet weak var view_time_H: NSLayoutConstraint!
    @IBOutlet weak var view_time_W: NSLayoutConstraint!
    @IBOutlet weak var btn_time1_H: NSLayoutConstraint!
    @IBOutlet weak var btn_time1: UIButton!
    @IBOutlet weak var btn_time5: UIButton!
    @IBOutlet weak var btn_time10: UIButton!
    @IBOutlet weak var btn_time30: UIButton!
    @IBOutlet weak var btn_time60: UIButton!
    lazy var _isOpen = false
    fileprivate func showViewTime(_ open:Bool) {
        if open {
            view_time.isHidden = false
            view_time_H.constant = sp_fitSize((175, 200, 225))
            view_time.setNeedsLayout()
            UIView.animate(withDuration: 0, animations: { [weak self]_ in
                self?.view_time.layoutIfNeeded()
            }) { [weak self](isOk) in
                //阴影
                self?.view_time.backgroundColor = UIColor.white
                self?.view_time.layer.shadowColor = UIColor.black.cgColor
                self?.view_time.layer.shadowOffset = CGSize(width: 0, height: 5)
                self?.view_time.layer.shadowOpacity = 0.9
            }
            //btn_top5.isEnabled = false
        }else{
            view_time_H.constant = 0
            view_time.setNeedsLayout()
            UIView.animate(withDuration: 0, animations: { [weak self]_ in
                self?.view_time.layoutIfNeeded()
            }) { [weak self](isOk) in
                self?.view_time.isHidden = true
            }
            //btn_top5.isEnabled = true
        }
        
    }
    var _timeBtnTag = -1
    @IBAction func clickTimeButton(_ sender: UIButton) {
        _timeBtnTag = sender.tag
        for item in view_time.subviews {
            if let btn = item as? UIButton {
                btn.setTitleColor(UIColor.mainText_1, for: .normal)
            }
        }
        sender.setTitleColor(UIColor.main_1, for: .normal)
        btn_top5.setTitle(sender.titleLabel!.text, for: .normal)
        _isOpen = !_isOpen
        showViewTime(_isOpen)
        btn_top5.setImage(UIImage(named:_isOpen ? "Attention置顶" : "Attention展开"), for: .normal)
        _type = JH_ChartDataType(rawValue: _timeBtnTag + 5)!
        _getDataBlock?(JH_ChartDataType(rawValue: _timeBtnTag + 5)!)
        
        _stockChartView.segmentView.selectedIndex = UInt(_timeBtnTag + 5 + 1)
        
        updateViewTopUI()
        btn_top5.setTitleColor(UIColor.main_1, for: .normal)
        btn_top5.titleLabel?.font = sp_fitFontB16
        view_topLine.snp.removeConstraints()
        view_topLine.snp.makeConstraints({ (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalTo(btn_top5).offset(-10)
            make.width.equalTo(sp_fitSize((28, 32, 36)))
            make.height.equalTo(2)
        })
        
        view_details_W.constant = 0
        view_details_L.constant = 0
        view_details_R.constant = 0
    }
    
    
    //MARK:--- 右侧五档明细 -----------------------------
    @IBOutlet weak var view_details: UIView!
    @IBOutlet weak var view_detailsTop: UIView!
    @IBOutlet weak var view_detailsLine: UIView!
    @IBOutlet weak var view_details_W: NSLayoutConstraint!
    @IBOutlet weak var view_details_L: NSLayoutConstraint!
    @IBOutlet weak var view_details_R: NSLayoutConstraint!
    @IBOutlet weak var view_detailsTop_H: NSLayoutConstraint!
    
    @IBOutlet weak var btn_dtsL: UIButton!
    @IBOutlet weak var btn_dtsR: UIButton!
    @IBOutlet weak var view_dtsL: UIView!
    @IBOutlet weak var view_dtsLtop: UIView!
    @IBOutlet weak var view_dtsLbottom: UIView!
    @IBOutlet weak var view_dtsR: UIView!
    
    @IBOutlet weak var lab_sell5_W: NSLayoutConstraint!
    @IBOutlet weak var lab_buy1_W: NSLayoutConstraint!
    @IBOutlet weak var lab_sell5N_W: NSLayoutConstraint!
    @IBOutlet weak var lab_buy1N_W: NSLayoutConstraint!
    
    @IBOutlet weak var lab_sell5: UILabel!
    @IBOutlet weak var lab_sell5_P: UILabel!
    @IBOutlet weak var lab_sell5_N: UILabel!
    
    @IBOutlet weak var lab_sell4: UILabel!
    @IBOutlet weak var lab_sell4_P: UILabel!
    @IBOutlet weak var lab_sell4_N: UILabel!
    
    @IBOutlet weak var lab_sell3: UILabel!
    @IBOutlet weak var lab_sell3_P: UILabel!
    @IBOutlet weak var lab_sell3_N: UILabel!
    
    @IBOutlet weak var lab_sell2: UILabel!
    @IBOutlet weak var lab_sell2_P: UILabel!
    @IBOutlet weak var lab_sell2_N: UILabel!
    
    @IBOutlet weak var lab_sell1: UILabel!
    @IBOutlet weak var lab_sell1_P: UILabel!
    @IBOutlet weak var lab_sell1_N: UILabel!
    
    @IBOutlet weak var lab_buy1: UILabel!
    @IBOutlet weak var lab_buy1_P: UILabel!
    @IBOutlet weak var lab_buy1_N: UILabel!
    
    @IBOutlet weak var lab_buy2: UILabel!
    @IBOutlet weak var lab_buy2_P: UILabel!
    @IBOutlet weak var lab_buy2_N: UILabel!
    
    @IBOutlet weak var lab_buy3: UILabel!
    @IBOutlet weak var lab_buy3_P: UILabel!
    @IBOutlet weak var lab_buy3_N: UILabel!
    
    @IBOutlet weak var lab_buy4: UILabel!
    @IBOutlet weak var lab_buy4_P: UILabel!
    @IBOutlet weak var lab_buy4_N: UILabel!
    
    @IBOutlet weak var lab_buy5: UILabel!
    @IBOutlet weak var lab_buy5_P: UILabel!
    @IBOutlet weak var lab_buy5_N: UILabel!
    
    @IBAction func clickBtnDetails(_ sender: UIButton) {
        updateViewDetailsTopUI()
        sender.setTitleColor(UIColor.main_1, for: .normal)
        sender.titleLabel?.font = sp_fitFontB14
        view_detailsLine.snp.removeConstraints()
        view_detailsLine.snp.makeConstraints({ (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalTo(sender)
            make.width.equalTo(sp_fitSize((20, 24, 28)))
            make.height.equalTo(1)
        })
    }
    fileprivate func updateViewDetailsTopUI() {
        for item in view_detailsTop.subviews {
            if let btn = item as? UIButton {
                btn.setTitleColor(UIColor.mainText_1, for: .normal)
                btn.titleLabel?.font = sp_fitFont14
            }
        }
    }
    
    
    //MARK:--- 图表 -----------------------------
    @IBOutlet weak var view_charts: UIView!
    
    @IBOutlet weak var view_activi: UIActivityIndicatorView!
    @IBOutlet weak var lab_chartsL: UILabel!
    @IBOutlet weak var lab_chartsR: UILabel!
    @IBOutlet weak var lab_error: UILabel!
    @IBOutlet weak var btn_fullScreen: UIButton!
    var _blockFullScreen:(()->Void)?
    @IBAction func clickFullScreen(_ sender: UIButton) {
        _blockFullScreen?()
    }
    
    
    
    
    
    var _getDataBlock:((JH_ChartDataType)->Void)?
    var _datas = M_Attention() {
        didSet{
            
        }
    }
    
    var _type = JH_ChartDataType.t分时
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        view_activi.startAnimating()
    }
    
    //MARK:--- Y_StockChartView -----------------------------
    
    var _currentIndex = -1
    
    lazy var _stockChartView:Y_StockChartView = {
        let view = Y_StockChartView()
        view.itemModels = [Y_StockChartViewItemModel.init(title: "指标", type: .chartcenterViewTypeOther, fiveDay:false),
                           Y_StockChartViewItemModel.init(title: JH_ChartDataType.t分时.stringValue, type: .chartcenterViewTypeTimeLine, fiveDay:false),
                           Y_StockChartViewItemModel.init(title: JH_ChartDataType.t5日.stringValue, type: .chartcenterViewTypeTimeLine, fiveDay:true),
                           Y_StockChartViewItemModel.init(title: JH_ChartDataType.t日K.stringValue, type: .chartcenterViewTypeKline, fiveDay:true),
                           Y_StockChartViewItemModel.init(title: JH_ChartDataType.t周K.stringValue, type: .chartcenterViewTypeKline, fiveDay:true),
                           Y_StockChartViewItemModel.init(title: JH_ChartDataType.t月K.stringValue, type: .chartcenterViewTypeKline, fiveDay:true),
                           Y_StockChartViewItemModel.init(title: JH_ChartDataType.t1分.stringValue, type: .chartcenterViewTypeKline, fiveDay:true),
                           Y_StockChartViewItemModel.init(title: JH_ChartDataType.t5分.stringValue, type: .chartcenterViewTypeKline, fiveDay:true),
                           Y_StockChartViewItemModel.init(title: JH_ChartDataType.t10分.stringValue, type: .chartcenterViewTypeKline, fiveDay:true),
                           Y_StockChartViewItemModel.init(title: JH_ChartDataType.t30分.stringValue, type: .chartcenterViewTypeKline, fiveDay:true),
                           Y_StockChartViewItemModel.init(title: JH_ChartDataType.t60分.stringValue, type: .chartcenterViewTypeKline, fiveDay:true)
            
        ]
        
        view.dataSource = self
        self.view_charts.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        return view
    }()
    
    
    
    
    //MARK:--- SP_TimeLine -----------------------------
    lazy var _lineBgView:SP_LineBgView = {
        let view = SP_LineBgView.show()
        return view
    }()
}





extension JH_AttentionDetailsCell_Charts:Y_StockChartViewDataSource {
 
    
    fileprivate func makeChartsView() {
        
        
        _currentIndex = -1
        _stockChartView.backgroundColor = UIColor.background()
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) { [weak self]_ in
            self?.pollingGetLineData()
            
        }
        
        self.view_charts.bringSubview(toFront: view_activi)
        self.view_charts.bringSubview(toFront: lab_error)
        lab_error.textColor = UIColor.mainText_2
        lab_error.isHidden = true
    }
    fileprivate func pollingGetLineData(){
        self._getDataBlock?(self._type)
        //60秒轮询
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(600*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) { [weak self]_ in
            self?.pollingGetLineData()
        }
    }
    func stockDatas(with index: Int) -> Any! {
        _type = JH_ChartDataType(rawValue: index-1)!
        
        _currentIndex = index
        
        if let model = JH_AttentionDetails._modelsDict[_type.stringValue] {
            return model.models
        }else{
            sp_Notification.post(name: Notification.Name(rawValue: "YKStockChartViewReloadDataStop"), object: "开启")
            //self._stockChartView.isReloadDataStop = false
            _getDataBlock?(_type)
        }
        return nil
    }
    
    
    
}



