//
//  JH_BuyAndSell_Cell.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/18.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import IQKeyboardManager
class JH_BuyAndSellCell_Data: UITableViewCell {
    class func show(_ tableView:UITableView, _ indexPath:IndexPath) -> JH_BuyAndSellCell_Data {
        return tableView.dequeueReusableCell(withIdentifier: "JH_BuyAndSellCell_Data", for: indexPath) as! JH_BuyAndSellCell_Data
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        makeUI()
    }
    
    
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
    
    @IBOutlet weak var view_L: UIView!
    @IBOutlet weak var view_R: UIView!
    @IBOutlet weak var lab_sell5_W: NSLayoutConstraint!
    @IBOutlet weak var lab_buy1_W: NSLayoutConstraint!
    @IBOutlet weak var lab_sell5N_W: NSLayoutConstraint!
    @IBOutlet weak var lab_buy1N_W: NSLayoutConstraint!
    
    func makeUI() {
        lab_sell5_W.constant = sp_fitSize((37,40,45))
        lab_buy1_W.constant = sp_fitSize((37,40,45))
        lab_sell5N_W.constant = sp_fitSize((40,45,50))
        lab_buy1N_W.constant = sp_fitSize((40,45,50))
        for item in view_L.subviews {
            if let lab = item as? UILabel {
                lab.font = sp_fitFont15
                lab.textColor = UIColor.mainText_1
            }
        }
        for item in view_R.subviews {
            if let lab = item as? UILabel {
                lab.font = sp_fitFont15
                lab.textColor = UIColor.mainText_1
            }
        }
    }
    
}

class JH_BuyAndSellCell_Deal: UITableViewCell {
    
    let disposeBag = DisposeBag()
    @IBOutlet weak var view_name: UIView!
    @IBOutlet weak var view_pice: UIView!
    @IBOutlet weak var view_num: UIView!
    
    @IBOutlet weak var lab_name: UILabel!
    @IBOutlet weak var lab_no: UILabel!
    
    @IBOutlet weak var lab_down: UILabel!
    @IBOutlet weak var lab_up: UILabel!
    
    @IBOutlet weak var btn_deal: UIButton!
    
    var _clickBlock:(()->Void)?
    
    enum heightType {
        case tH
        case tB
        case tFinish
    }
    var _heightBlock:((heightType,CGFloat)->Void)?
    
    lazy var _text_price:SP_TextField = {
        let text = SP_TextField.show(self.view_pice)
        text.text_field.placeholder = "0.0"
        text.text_field.textColor = UIColor.mainText_1
        text.text_field.keyboardType = .decimalPad
        text.text_field.textAlignment = .center
        //text.text_field.showOkButton()
        text.label_error.font = UIFont.systemFont(ofSize: 8)
        text.button_L.setImage(UIImage(named:"Attention减N"), for: .normal)
        text.button_R.setImage(UIImage(named:"Attention加N"), for: .normal)
        text.button_L_W.constant = 50
        text.button_R_W.constant = 50
        text.text_field_L.constant = 1
        text.text_field_R.constant = 1
        text.view_Line_L.constant = 0
        text.view_Line_R.constant = 0
        text.button_L_H.constant = 40
        text.button_R_H.constant = 40
        text.view_Line.isHidden = true
        text.layer.cornerRadius = 8
        text.layer.borderWidth = 1.0
        text.clipsToBounds = true
        text.layer.borderColor = UIColor.main_line.cgColor
        text.backgroundColor = UIColor.main_line
        text.button_L.backgroundColor = UIColor.white
        text.button_R.backgroundColor = UIColor.white
        text.text_field.backgroundColor = UIColor.white
        return text
    }()
    lazy var _text_num:SP_TextField = {
        let text = SP_TextField.show(self.view_num)
        text.text_field.placeholder = "0"
        text.text_field.textColor = UIColor.mainText_1
        text.text_field.keyboardType = .numberPad
        text.text_field.textAlignment = .center
        //text.text_field.showOkButton()
        text.label_error.font = UIFont.systemFont(ofSize: 8)
        text.button_L.setImage(UIImage(named:"Attention减N"), for: .normal)
        text.button_R.setImage(UIImage(named:"Attention加N"), for: .normal)
        text.button_L_W.constant = 50
        text.button_R_W.constant = 50
        text.text_field_L.constant = 1
        text.text_field_R.constant = 1
        text.view_Line_L.constant = 0
        text.view_Line_R.constant = 0
        text.button_L_H.constant = 40
        text.button_R_H.constant = 40
        text.view_Line.isHidden = true
        text.layer.cornerRadius = 8
        text.layer.borderWidth = 1.0
        text.clipsToBounds = true
        text.layer.borderColor = UIColor.main_line.cgColor
        text.backgroundColor = UIColor.main_line
        text.button_L.backgroundColor = UIColor.white
        text.button_R.backgroundColor = UIColor.white
        text.text_field.backgroundColor = UIColor.white
        return text
    }()
    
    var _type = JH_BuyAndSellType.t买入
    var _model:M_Attention = M_Attention() {
        didSet{
            lab_name.text = _model.name
            lab_no.text = _model.code
            _text_price.text_field.text = _model.proposedPrice
            _text_num.text_field.text = _text_num.text_field.text!.isEmpty ? "10" : _text_num.text_field.text!
        }
    }
    
}
extension JH_BuyAndSellCell_Deal {
    class func show(_ tableView:UITableView, _ indexPath:IndexPath) -> JH_BuyAndSellCell_Deal {
        return tableView.dequeueReusableCell(withIdentifier: "JH_BuyAndSellCell_Deal", for: indexPath) as! JH_BuyAndSellCell_Deal
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        makeUI()
        makeTextFieldDelegate()
        makeRx()
        IQKeyboardManager.shared().shouldShowTextFieldPlaceholder = false
        
        
    }
    @IBAction func btnClick(_ sender: UIButton) {
        keyBoardHidden()
        _clickBlock?()
    }
    
    
    func makeUI(_ type:JH_BuyAndSellType = .t买入) {
        _type = type
        lab_down.textColor = UIColor.mainText_5
        lab_up.textColor = UIColor.mainText_4
        
        lab_no.textColor = UIColor.mainText_1
        lab_name.textColor = UIColor.mainText_3
        
        view_name.backgroundColor = UIColor.clear
        view_name.layer.borderWidth = 1.0
        view_name.layer.borderColor = UIColor.main_line.cgColor
        
        view_pice.backgroundColor = UIColor.white
        view_num.backgroundColor = UIColor.white
        
        
        btn_deal.setTitle(sp_localized(type == .t买入 ? "买入" : "卖出") , for: .normal)
        btn_deal.backgroundColor = type == .t买入 ? UIColor.main_1 : UIColor.main_btnNormal
        //阴影
        btn_deal.layer.shadowColor = (type == .t买入 ? UIColor.main_1 : UIColor.main_btnNormal).cgColor
        btn_deal.layer.shadowOffset = CGSize(width: 0, height: 1)
        btn_deal.layer.shadowOpacity = 0.5
        
        _text_price.text_field.text = "0.0"
        _text_num.text_field.text = "10"
    }
    
    
    
    
}
//MARK:--- 输入操作 -----------------------------
extension JH_BuyAndSellCell_Deal {
    fileprivate func makeTextFieldDelegate() {
        _text_price._shouldChangeCharactersBlock = { [weak self](textField,range,str) -> Bool in
            let bool = textField.sp_limitForPrice(range, string: str, stringLength: 10, errorType: { (type) in
                switch type {
                case .tOutRange:
                    break
                case .tUnlawful:
                    self?._text_price.label_error.text = "*请输入正确的价格"
                case .tNormal:
                    self?._text_price.label_error.text = ""
                }
            })
            return bool
        }
        
        _text_num._shouldChangeCharactersBlock = { [weak self](textField,range,str) -> Bool in
            let bool = textField.sp_limitForNumbers(range,string: str, stringLength: 8, errorType:{ [weak self]type in
                switch type {
                case .tOutRange:
                    break
                case .tUnlawful:
                    self?._text_num.label_error.text = "*请输入正确的数量"
                case .tNormal:
                    self?._text_num.label_error.text = ""
                }
            })
            
            return bool
        }
        
    }
    
    fileprivate func makeRx(){
        let priceValid_1 = _text_price.text_field.rx.text.map { $0?.characters.count != 0 }.shareReplay(1)
        let numValid_1 = _text_num.text_field.rx.text.map { $0?.characters.count != 0 }.shareReplay(1)
        let allValid = Observable.combineLatest(priceValid_1, numValid_1) { $0 && $1 }.shareReplay(1)
        allValid
            .asObservable()
            .subscribe(onNext: { [unowned self](isOk) in
                self.btn_deal.isEnabled = isOk
                self.btn_deal.backgroundColor = isOk ? (self._type == .t买入 ? UIColor.main_1 : UIColor.main_btnNormal) : UIColor.main_btnNotEnb
            }).addDisposableTo(disposeBag)
        
        
        
        
        _text_price.button_R.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self](isOK) in
                self.textPriceAdd()
            }).addDisposableTo(disposeBag)
        
        _text_price.button_L.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self](isOK) in
                self.textPriceSubtract()
            }).addDisposableTo(disposeBag)
        
        
        _text_num.button_R.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self](isOK) in
                self.textNumAdd()
                
            }).addDisposableTo(disposeBag)
        
        _text_num.button_L.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self](isOK) in
                self.textNumSubtract()
                
            }).addDisposableTo(disposeBag)
    }
    
    fileprivate func textPriceAdd() {
        let price = Double(_text_price.text_field.text!)! + 10.0
        _text_price.text_field.text = String(format: "%.2f", price)
    }
    fileprivate func textPriceSubtract() {
        if _type == .t买入 {
            guard !_text_num.text_field.text!.isEmpty else {
                _text_num.text_field.text = _model.proposedPrice
                return
            }
            //买入价格不得低于现在的价格
//            guard Double(_text_num.text_field.text!) == Double(_model.proposedPrice) else {
//                _text_num.label_error.text = "*买入价格不得低于当前价格"
//                return
//            }
        }else{
            guard !_text_num.text_field.text!.isEmpty else {
                _text_num.text_field.text = "0.0"
                return
            }
            //买入价格不得低于现在的价格
//            guard Double(_text_num.text_field.text!)! > 10.0 else {
//                _text_num.label_error.text = "*买入价格不得低于 0"
//                return
//            }
            
        }
        
        let price = Double(_text_price.text_field.text!)! - 10.0
        _text_price.text_field.text = String(format: "%.2f", price)
    }
    fileprivate func textNumAdd() {
//        guard !_text_num.text_field.text!.isEmpty else {
//            _text_num.text_field.text = "1"
//            return
//        }
        let price = Int(_text_num.text_field.text!)! + 1
        _text_num.text_field.text = String(format: "%d", price)
    }
    fileprivate func textNumSubtract() {
//        guard !_text_num.text_field.text!.isEmpty else {
//            _text_num.text_field.text = "1"
//            return
//        }
//        guard Int(_text_num.text_field.text!) == 1 else {
//            _text_num.label_error.text = "*数量不能小于 1"
//            return
//        }
        let price = Double(_text_num.text_field.text!)! - 1
        _text_num.text_field.text = String(format: "%d", price)
    }
    
}

//MARK:--- 键盘
extension JH_BuyAndSellCell_Deal {
    func keyBoardHidden(){
        _text_price.text_field.resignFirstResponder()
        _text_num.text_field.resignFirstResponder()
    }
    
}
