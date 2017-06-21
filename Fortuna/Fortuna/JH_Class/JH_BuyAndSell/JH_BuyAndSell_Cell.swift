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

class JH_BuyAndSellCell_Data: UITableViewCell {
    class func show(_ tableView:UITableView, _ indexPath:IndexPath) -> JH_BuyAndSellCell_Data {
        return tableView.dequeueReusableCell(withIdentifier: "JH_BuyAndSellCell_Data", for: indexPath) as! JH_BuyAndSellCell_Data
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
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
    
}

class JH_BuyAndSellCell_Deal: UITableViewCell {
    class func show(_ tableView:UITableView, _ indexPath:IndexPath) -> JH_BuyAndSellCell_Deal {
        return tableView.dequeueReusableCell(withIdentifier: "JH_BuyAndSellCell_Deal", for: indexPath) as! JH_BuyAndSellCell_Deal
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        makeUI()
        makeTextFieldDelegate()
        makeRx()
    }
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
    
    lazy var _text_price:SP_TextField = {
        let text = SP_TextField.show(self.view_pice)
        text.text_field.placeholder = "0.0"
        text.text_field.textColor = UIColor.mainText_1
        text.text_field.keyboardType = .numbersAndPunctuation
        text.text_field.textAlignment = .center
        text.button_L.setImage(UIImage(named:"Attention减N"), for: .normal)
        text.button_R.setImage(UIImage(named:"Attention加N"), for: .normal)
        text.button_L_W.constant = 50
        text.button_R_W.constant = 50
        text.text_field_L.constant = 1
        text.text_field_R.constant = 1
        text.view_Line_L.constant = 0
        text.view_Line_R.constant = 0
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
        text.button_L.setImage(UIImage(named:"Attention减N"), for: .normal)
        text.button_R.setImage(UIImage(named:"Attention加N"), for: .normal)
        text.button_L_W.constant = 50
        text.button_R_W.constant = 50
        text.text_field_L.constant = 1
        text.text_field_R.constant = 1
        text.view_Line_L.constant = 0
        text.view_Line_R.constant = 0
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
    
    @IBAction func btnClick(_ sender: UIButton) {
        _clickBlock?()
    }
    
    
    fileprivate func makeUI() {
        lab_down.textColor = UIColor.mainText_5
        lab_up.textColor = UIColor.mainText_4
        
        lab_no.textColor = UIColor.mainText_1
        lab_name.textColor = UIColor.mainText_3
        
        view_name.backgroundColor = UIColor.clear
        view_name.layer.borderWidth = 1.0
        view_name.layer.borderColor = UIColor.main_line.cgColor
        
        view_pice.backgroundColor = UIColor.clear
        view_num.backgroundColor = UIColor.clear
        
        //阴影
        btn_deal.layer.shadowColor = UIColor.main_1.cgColor
        btn_deal.layer.shadowOffset = CGSize(width: 0, height: 1)
        btn_deal.layer.shadowOpacity = 0.5
    }
    
    fileprivate func makeTextFieldDelegate() {
        _text_num._shouldChangeCharactersBlock = { [weak self](textField,range,str) -> Bool in
            let bool = textField.sp_limitForNumbers(range,string: str, stringLength: 11, errorType:{ [weak self]type in
                switch type {
                case .tOutRange:
                    break
                case .tUnlawful:
                    break//self?.lab_error.text = "*请输入正确的手机号"
                case .tNormal:
                    break//self?.lab_error.text = ""
                }
            })
            return bool
        }
        _text_price._shouldChangeCharactersBlock = { [weak self](textField,range,str) -> Bool in
            let bool = textField.sp_limitForPrice(range, string: str, stringLength: 16, errorType: { (type) in
                switch type {
                case .tOutRange:
                    break
                case .tUnlawful:
                    break//self?.lab_error.text = "*密码限6~16位字母、数字、_"
                case .tNormal:
                    break//self?.lab_error.text = ""
                }
            })
            return bool
        }
        
        
    }
    
    fileprivate func makeRx(){
        
        _text_price.button_R.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self](isOK) in
                //self._text_phone.text_field.text = ""
            }).addDisposableTo(disposeBag)
        
        _text_price.button_L.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self](isOK) in
                
                
            }).addDisposableTo(disposeBag)
        
        
        _text_num.button_R.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self](isOK) in
                //self._text_phone.text_field.text = ""
            }).addDisposableTo(disposeBag)
        
        _text_num.button_L.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self](isOK) in
                
                
            }).addDisposableTo(disposeBag)
        
        
        
    }
    
    
}
