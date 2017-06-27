//
//  JH_Attention_Cell.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/13.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
//MARK:--- 自选页面 -----------------------------
class JH_AttentionCell_Normal: UITableViewCell {
    class func show(_ tableView:UITableView, _ indexPath:IndexPath) -> JH_AttentionCell_Normal {
        return tableView.dequeueReusableCell(withIdentifier: "JH_AttentionCell_Normal", for: indexPath) as! JH_AttentionCell_Normal
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
        return tableView.dequeueReusableCell(withIdentifier: "JH_AttentionCell_Edit", for: indexPath) as! JH_AttentionCell_Edit
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view_line.backgroundColor = UIColor.main_line
        lab_name.textColor = UIColor.mainText_1
        
        lab_name.font = sp_fitFont20
        
        btn_select.setTitleColor(UIColor.mainText_1, for: .normal)
        btn_select.titleLabel?.font = sp_fitFont20
    }
    
    @IBOutlet weak var view_line: UIView!
    @IBOutlet weak var lab_name: UILabel!
    @IBOutlet weak var btn_select: UIButton!
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "JH_AttentionDetailsCell_Data", for: indexPath) as! JH_AttentionDetailsCell_Data
        cell._clickBlock = openBlock
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
    
    @IBOutlet weak var lab_price: UILabel!
    @IBOutlet weak var lab_MOL: UILabel!
    @IBOutlet weak var lab_range: UILabel!
    
    @IBOutlet weak var lab_open: UILabel!
    @IBOutlet weak var lab_turnover: UILabel!
    @IBOutlet weak var lab_tall: UILabel!
    @IBOutlet weak var lab_low: UILabel!
    @IBOutlet weak var lab_rate: UILabel!
    @IBOutlet weak var lab_ratio: UILabel!
    
    @IBOutlet weak var lab_open0: UILabel!
    @IBOutlet weak var lab_turnover0: UILabel!
    @IBOutlet weak var lab_tall0: UILabel!
    @IBOutlet weak var lab_low0: UILabel!
    @IBOutlet weak var lab_rate0: UILabel!
    @IBOutlet weak var lab_ratio0: UILabel!
    
    @IBOutlet weak var btn_unfold: UIButton!
    
    var _clickBlock:(()->Void)?
    @IBAction func clickBtn(_ sender: UIButton) {
        _clickBlock?()
    }
    
    
    fileprivate func makeUI() {
        view_price.backgroundColor = UIColor.clear
        view_data.backgroundColor = UIColor.clear
        view_unfold.backgroundColor = UIColor.clear
        view_price_W.constant = (sp_ScreenWidth-30)/2-20
        
        lab_price.font = UIFont.systemFont(ofSize: SP_InfoOC.sp_fit(withSize: 30))
        lab_MOL.font = UIFont.systemFont(ofSize: SP_InfoOC.sp_fit(withSize: 15))
        lab_range.font = UIFont.systemFont(ofSize: SP_InfoOC.sp_fit(withSize: 15))
        
        
        for item in view_data.subviews {
            if let lab = item as? UILabel {
                lab.font = sp_fitFont16
            }
        }
    }
    
}
class JH_AttentionDetailsCell_Unfold: UITableViewCell {
    class func show(_ tableView:UITableView, _ indexPath:IndexPath) -> JH_AttentionDetailsCell_Unfold {
        return tableView.dequeueReusableCell(withIdentifier: "JH_AttentionDetailsCell_Unfold", for: indexPath) as! JH_AttentionDetailsCell_Unfold
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeUI()
    }
    
    @IBOutlet weak var view_line: UIView!
    @IBOutlet weak var view_bg: UIView!
    
    @IBOutlet weak var lab_PRE: UILabel!
    @IBOutlet weak var lab_VOL: UILabel!
    
    @IBOutlet weak var lab_InSize: UILabel!
    @IBOutlet weak var lab_OutSize: UILabel!
    
    @IBOutlet weak var lab_Up: UILabel!
    @IBOutlet weak var lab_Down: UILabel!
    
    @IBOutlet weak var lab_MktCap: UILabel!
    @IBOutlet weak var lab_swing: UILabel!
    
    @IBOutlet weak var lab_PRE0: UILabel!
    @IBOutlet weak var lab_VOL0: UILabel!
    
    @IBOutlet weak var lab_InSize0: UILabel!
    @IBOutlet weak var lab_OutSize0: UILabel!
    
    @IBOutlet weak var lab_Up0: UILabel!
    @IBOutlet weak var lab_Down0: UILabel!
    
    @IBOutlet weak var lab_MktCap0: UILabel!
    @IBOutlet weak var lab_swing0: UILabel!
    
    fileprivate func makeUI() {
        view_line.backgroundColor = UIColor.main_bg
        
        for item in view_bg.subviews {
            if let lab = item as? UILabel {
                lab.font = sp_fitFont16
            }
        }
    }
}

class JH_AttentionDetailsCell_Charts: UITableViewCell {
    class func show(_ tableView:UITableView, _ indexPath:IndexPath) -> JH_AttentionDetailsCell_Charts {
        return tableView.dequeueReusableCell(withIdentifier: "JH_AttentionDetailsCell_Charts", for: indexPath) as! JH_AttentionDetailsCell_Charts
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        makeUI()
        clickBtnTop(btn_top0)
        clickBtnDetails(btn_dtsL)
    }
    
    fileprivate func makeUI() {
        view_topLine.backgroundColor = UIColor.main_1
        // --- 顶部分段
        view_top_H.constant = sp_fitSize((35, 40, 45))
        btn_top6_W.constant = sp_fitSize((40, 50, 60))
        // --- 右侧下拉时间
        view_time_H.constant = 0
        view_time_W.constant = sp_fitSize((40, 50, 60))
        btn_time1_H.constant = sp_fitSize((35, 40, 45))
        view_time.isHidden = true
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
                lab.textColor = UIColor.mainText_1
                lab.font = sp_fitFont12
            }
        }
        for item in view_dtsLbottom.subviews {
            if let lab = item as? UILabel {
                lab.textColor = UIColor.mainText_1
                lab.font = sp_fitFont12
            }
        }
        
        for item in view_detailsTop.subviews {
            if let btn = item as? UIButton {
                btn.setTitleColor(UIColor.mainText_1, for: .normal)
                btn.titleLabel?.font = sp_fitFont12
            }
        }
        
        
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
        case btn_top6:
            _isOpen = !_isOpen
            showViewTime(_isOpen)
            sender.setImage(UIImage(named:_isOpen ? "Attention置顶" : "Attention展开"), for: .normal)
        default:
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
            UIView.animate(withDuration: 0.2, animations: { [weak self]_ in
                self?.view_time.layoutIfNeeded()
            }) { (isOk) in
                
            }
        }else{
            view_time_H.constant = 0
            view_time.setNeedsLayout()
            UIView.animate(withDuration: 0.2, animations: { [weak self]_ in
                self?.view_time.layoutIfNeeded()
            }) { [weak self](isOk) in
                self?.view_time.isHidden = true
            }
        }
        
    }
    //MARK:--- 右侧五档明细 -----------------------------
    @IBOutlet weak var view_details: UIView!
    @IBOutlet weak var view_detailsTop: UIView!
    @IBOutlet weak var view_detailsLine: UIView!
    @IBOutlet weak var view_details_W: NSLayoutConstraint!
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
        sender.titleLabel?.font = sp_fitFontB12
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
                btn.titleLabel?.font = sp_fitFont12
            }
        }
    }
    //MARK:--- 图表 -----------------------------
    @IBOutlet weak var view_charts: UIView!
    
}
