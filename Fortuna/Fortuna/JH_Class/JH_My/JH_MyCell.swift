//
//  JH_MyCell.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/9.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
//MARK:--- 持仓 -----------------------------
class JH_MyPositionsCell: UITableViewCell {
    class func show(_ tableView: UITableView, _ indexPath: IndexPath)->JH_MyPositionsCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JH_MyPositionsCell", for: indexPath) as! JH_MyPositionsCell
        return cell
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    @IBOutlet weak var lab_code: UILabel!
    @IBOutlet weak var lab_yk: UILabel!
    @IBOutlet weak var lab_ratio: UILabel!
    @IBOutlet weak var lab_num: UILabel!
    
    fileprivate func makeUI() {
        self.lab_code.textColor = UIColor.mainText_1
        self.lab_yk.textColor = UIColor.mainText_4
        self.lab_ratio.textColor = UIColor.mainText_4
        self.lab_num.textColor = UIColor.mainText_1
    }
}

//MARK:--- 当日成交 -----------------------------
class JH_MyTodayDealCell: UITableViewCell {
    class func show(_ tableView: UITableView, _ indexPath: IndexPath)->JH_MyTodayDealCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JH_MyTodayDealCell", for: indexPath) as! JH_MyTodayDealCell
        return cell
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.makeUI()
    }
    
    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var view_line: UIView!
    
    @IBOutlet weak var lab_name: UILabel!
    
    @IBOutlet weak var lab_allPrice0: UILabel!
    @IBOutlet weak var lab_price0: UILabel!
    @IBOutlet weak var lab_num0: UILabel!
    @IBOutlet weak var lab_time0: UILabel!
    
    @IBOutlet weak var lab_allPrice: UILabel!
    @IBOutlet weak var lab_price: UILabel!
    @IBOutlet weak var lab_num: UILabel!
    @IBOutlet weak var lab_time: UILabel!
    
    @IBOutlet weak var btn_look: UIButton!
    var _block:(()->Void)?
    @IBAction func clickBtnLook(_ sender: UIButton) {
        self._block?()
    }
    
    
    fileprivate func makeUI(){
        self.view_bg.backgroundColor = UIColor.white
        self.view_line.backgroundColor = UIColor.main_line
        
        self.lab_name.font = sp_fitFont18
        self.lab_name.textColor = UIColor.mainText_1
        
        self.lab_allPrice0.font = sp_fitFont16
        self.lab_allPrice0.textColor = UIColor.mainText_2
        self.lab_price0.font = sp_fitFont16
        self.lab_price0.textColor = UIColor.mainText_2
        self.lab_num0.font = sp_fitFont16
        self.lab_num0.textColor = UIColor.mainText_2
        self.lab_time0.font = sp_fitFont16
        self.lab_time0.textColor = UIColor.mainText_2
        
        self.lab_allPrice.font = sp_fitFont30
        self.lab_allPrice.textColor = UIColor.mainText_1
        self.lab_price.font = sp_fitFont16
        self.lab_price.textColor = UIColor.mainText_1
        self.lab_num.font = sp_fitFont16
        self.lab_num.textColor = UIColor.mainText_1
        self.lab_time.font = sp_fitFont16
        self.lab_time.textColor = UIColor.mainText_1
        
        self.btn_look.setTitleColor(UIColor.mainText_1, for: .normal)
        self.btn_look.titleLabel?.font = sp_fitFont18
        
        self.lab_allPrice0.text = sp_localized("成交额：")
        self.lab_price0.text = sp_localized("成交价：")
        self.lab_num0.text = sp_localized("成交量：")
        self.lab_time0.text = sp_localized("成交时间：")
        self.btn_look.setTitle(sp_localized("查看详情"), for: .normal)
    }
}

//MARK:--- 委托单-----------------------------
class JH_MyTodayDelegateCell: UITableViewCell {
    class func show(_ tableView: UITableView, _ indexPath: IndexPath)->JH_MyTodayDelegateCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JH_MyTodayDelegateCell", for: indexPath) as! JH_MyTodayDelegateCell
        return cell
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.makeUI()
    }
    
    
    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var view_line: UIView!
    
    
    @IBOutlet weak var lab_name: UILabel!
    
    @IBOutlet weak var lab_status0: UILabel!
    @IBOutlet weak var lab_price0: UILabel!
    @IBOutlet weak var lab_num0: UILabel!
    @IBOutlet weak var lab_time0: UILabel!
    
    @IBOutlet weak var lab_status: UILabel!
    @IBOutlet weak var lab_price: UILabel!
    @IBOutlet weak var lab_num: UILabel!
    @IBOutlet weak var lab_time: UILabel!
    
    @IBOutlet weak var btn_look: UIButton!
    var _block:(()->Void)?
    @IBAction func clickBtnLook(_ sender: UIButton) {
        self._block?()
    }
    
    
    fileprivate func makeUI(){
        self.view_bg.backgroundColor = UIColor.white
        self.view_line.backgroundColor = UIColor.main_line
        
        self.lab_name.font = sp_fitFont18
        self.lab_name.textColor = UIColor.mainText_1
        
        self.lab_status0.font = sp_fitFont16
        self.lab_status0.textColor = UIColor.mainText_2
        self.lab_price0.font = sp_fitFont16
        self.lab_price0.textColor = UIColor.mainText_2
        self.lab_num0.font = sp_fitFont16
        self.lab_num0.textColor = UIColor.mainText_2
        self.lab_time0.font = sp_fitFont16
        self.lab_time0.textColor = UIColor.mainText_2
        
        self.lab_status.font = sp_fitFont16
        self.lab_status.textColor = UIColor.mainText_1
        self.lab_price.font = sp_fitFont16
        self.lab_price.textColor = UIColor.mainText_1
        self.lab_num.font = sp_fitFont16
        self.lab_num.textColor = UIColor.mainText_1
        self.lab_time.font = sp_fitFont16
        self.lab_time.textColor = UIColor.mainText_1
        
        self.btn_look.setTitleColor(UIColor.mainText_1, for: .normal)
        self.btn_look.titleLabel?.font = sp_fitFont18
        
        self.lab_status0.text = sp_localized("状态：")
        self.lab_price0.text = sp_localized("委托/均价：")
        self.lab_num0.text = sp_localized("委托/成交：")
        self.lab_time0.text = sp_localized("委托时间：")
        self.btn_look.setTitle(sp_localized("点击撤单"), for: .normal)
    }
    
}

//MARK:--- 历史成交 -----------------------------
class JH_MyHistoryDealCell: UITableViewCell {
    class func show(_ tableView: UITableView, _ indexPath: IndexPath)->JH_MyHistoryDealCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JH_MyHistoryDealCell", for: indexPath) as! JH_MyHistoryDealCell
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.makeUI()
    }
    
    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var view_line: UIView!
    
    @IBOutlet weak var lab_name: UILabel!
    
    @IBOutlet weak var lab_allPrice0: UILabel!
    @IBOutlet weak var lab_price0: UILabel!
    @IBOutlet weak var lab_num0: UILabel!
    @IBOutlet weak var lab_time0: UILabel!
    
    @IBOutlet weak var lab_allPrice: UILabel!
    @IBOutlet weak var lab_price: UILabel!
    @IBOutlet weak var lab_num: UILabel!
    @IBOutlet weak var lab_time: UILabel!
    
    @IBOutlet weak var btn_look: UIButton!
    var _block:(()->Void)?
    @IBAction func clickBtnLook(_ sender: UIButton) {
        self._block?()
    }
    
    
    fileprivate func makeUI(){
        self.view_bg.backgroundColor = UIColor.white
        self.view_line.backgroundColor = UIColor.main_line
        
        self.lab_name.font = sp_fitFont18
        self.lab_name.textColor = UIColor.mainText_1
        
        self.lab_allPrice0.font = sp_fitFont16
        self.lab_allPrice0.textColor = UIColor.mainText_2
        
        self.lab_num0.font = sp_fitFont16
        self.lab_num0.textColor = UIColor.mainText_2
        self.lab_time0.font = sp_fitFont16
        self.lab_time0.textColor = UIColor.mainText_2
        
        self.lab_allPrice.font = sp_fitFont30
        self.lab_allPrice.textColor = UIColor.mainText_1
        
        self.lab_num.font = sp_fitFont16
        self.lab_num.textColor = UIColor.mainText_1
        self.lab_time.font = sp_fitFont16
        self.lab_time.textColor = UIColor.mainText_1
        
        self.btn_look.setTitleColor(UIColor.mainText_1, for: .normal)
        self.btn_look.titleLabel?.font = sp_fitFont18
        
        self.lab_allPrice0.text = sp_localized("成交价：")
        self.lab_num0.text = sp_localized("成交量：")
        self.lab_time0.text = sp_localized("成交时间：")
        self.btn_look.setTitle(sp_localized("查看详情"), for: .normal)
    }
    
}

//MARK:--- 成交详情 -----------------------------
class JH_MyDealDetailsCell: UITableViewCell {
    class func show(_ tableView: UITableView, _ indexPath: IndexPath)->JH_MyDealDetailsCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JH_MyDealDetailsCell", for: indexPath) as! JH_MyDealDetailsCell
        return cell
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.makeUI()
    }
    
    
    
    @IBOutlet weak var lab_L: UILabel!
    @IBOutlet weak var lab_R: UILabel!
    
    
    fileprivate func makeUI() {
        
        self.lab_L.textColor = UIColor.mainText_2
        self.lab_R.textColor = UIColor.mainText_2
        
        self.lab_L.font = sp_fitFont18
        self.lab_R.font = sp_fitFont18
    }
}

