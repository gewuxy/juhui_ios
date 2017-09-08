//
//  JH_News_Cell.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/13.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation

class JH_NewsCell_List: UITableViewCell {
    class func show(_ tableView:UITableView) -> JH_NewsCell_List {
        return tableView.dequeueReusableCell(withIdentifier: "JH_NewsCell_List") as! JH_NewsCell_List
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view_line.backgroundColor = UIColor.main_line
        lab_name.textColor = UIColor.mainText_1
        lab_name.font = sp_fitFont20
        lab_time.font = sp_fitFont18
        lab_time2.font = sp_fitFont18
    }
    
    @IBOutlet weak var view_line: UIView!
    @IBOutlet weak var lab_name: UILabel!
    @IBOutlet weak var lab_time: UILabel!
    @IBOutlet weak var lab_time2: UILabel!
    @IBOutlet weak var img_Logo: UIImageView!
}

class JH_NewsPostCell_List: UITableViewCell {
    class func show(_ tableView:UITableView) -> JH_NewsPostCell_List {
        return tableView.dequeueReusableCell(withIdentifier: "JH_NewsPostCell_List") as! JH_NewsPostCell_List
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view_line.backgroundColor = UIColor.main_line
        lab_name.textColor = UIColor.mainText_2
        lab_comm.textColor = UIColor.mainText_2
        lab_name.font = sp_fitFont16
        lab_comm.font = sp_fitFont16
        view_text.clipsToBounds = true
        
        view_text.addSubview(textView)
//        textView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        textView.frame = view_text.bounds
    }
    lazy var textView:YYLabel = {
        let text = YYLabel()
        text.numberOfLines = 0
        text.isUserInteractionEnabled = true
        text.textVerticalAlignment = .top
        text.textColor = UIColor.mainText_1
        return text
    }()
    
    @IBOutlet weak var view_text: UIView!
    @IBOutlet weak var view_line: UIView!
    @IBOutlet weak var lab_name: UILabel!
    @IBOutlet weak var lab_comm: UILabel!
    
    @IBOutlet weak var img_Logo: UIImageView!
}


class JH_NewsCell_User: UITableViewCell {
    class func show(_ tableView:UITableView) -> JH_NewsCell_User {
        return tableView.dequeueReusableCell(withIdentifier: "JH_NewsCell_User") as! JH_NewsCell_User
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view_line.backgroundColor = UIColor.main_line
        lab_name.textColor = UIColor.mainText_1
        lab_time.textColor = UIColor.mainText_2
        lab_name.font = sp_fitFont18
        lab_time.font = sp_fitFont14
        btn_follow.layer.borderColor = UIColor.main_line.cgColor
        btn_follow.layer.borderWidth = 0.5
        btn_follow.layer.cornerRadius = 6
        btn_follow.clipsToBounds = true
        btn_follow.setTitleColor(UIColor.mainText_1, for: .normal)
        btn_follow.titleLabel?.font = sp_fitFont16
    }
    
    @IBOutlet weak var view_line: UIView!
    @IBOutlet weak var lab_name: UILabel!
    @IBOutlet weak var lab_time: UILabel!
    
    @IBOutlet weak var btn_Logo: UIButton!
    @IBOutlet weak var btn_follow: UIButton!
    @IBOutlet weak var btn_follow_W: NSLayoutConstraint!
    enum btnType {
        case logo
        case follow
    }
    var _clickBtn:((btnType)->Void)?
    @IBAction func clickButton(_ sender: UIButton) {
        switch sender {
        case btn_Logo:
            _clickBtn?(.logo)
        default:
            _clickBtn?(.follow)
        }
    }
    
}

import YYText
class JH_NewsCell_Content: UITableViewCell {
    class func show(_ tableView:UITableView) -> JH_NewsCell_Content {
        return tableView.dequeueReusableCell(withIdentifier: "JH_NewsCell_Content") as! JH_NewsCell_Content
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let lab = UILabel()
//        lab.attributedText
    }
    
    lazy var textView:YYLabel = {
//        let text = YYTextView()
//        text.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
//        text.allowsCopyAttributedString = true;
//        text.allowsPasteAttributedString = true;
//        text.font = UIFont.systemFont(ofSize: 18)
//        //text.backgroundColor = UIColor.gray
//        text.isScrollEnabled = false
//        text.allowsCopyAttributedString = false
//        text.isEditable = false
//        text.delegate = self
        
        let text = YYLabel()
        text.numberOfLines = 0
        text.isUserInteractionEnabled = true
        //text.textVerticalAlignment = .top
        text.textColor = UIColor.mainText_1
        text.preferredMaxLayoutWidth = sp_ScreenWidth - 20
        self.contentView.addSubview(text)
        text.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(10)
            make.bottom.trailing.equalToSuperview().offset(-10)
        }
        return text
    }()
    
}
extension JH_NewsCell_Content:YYTextViewDelegate {
     func textViewDidChange(_ textView: YYTextView) {
        var textBounds = textView.bounds
        // 计算 text view 的高度
        let maxSize = CGSize(width:textBounds.size.width, height:CGFloat.greatestFiniteMagnitude)
        let newSize = textView.sizeThatFits(maxSize)
        textBounds.size = newSize
        let textHeight = textBounds.size.height
        print_SP(textHeight)
    }
}



class JH_NewsCell_Btn: UITableViewCell {
    class func show(_ tableView:UITableView) -> JH_NewsCell_Btn {
        return tableView.dequeueReusableCell(withIdentifier: "JH_NewsCell_Btn") as! JH_NewsCell_Btn
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view_line.backgroundColor = UIColor.main_line
        btn_1.setTitleColor(UIColor.mainText_2, for: .normal)
        btn_2.setTitleColor(UIColor.mainText_2, for: .normal)
        btn_3.setTitleColor(UIColor.mainText_2, for: .normal)
        btn_1.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn_2.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn_3.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
    }
    
    @IBOutlet weak var view_line: UIView!
    @IBOutlet weak var btn_1: UIButton!
    @IBOutlet weak var btn_2: UIButton!
    @IBOutlet weak var btn_3: UIButton!
    var _clickBtn:((Int)->Void)?
    @IBAction func clickButton(_ sender: UIButton) {
        _clickBtn?(sender.tag)
    }
    
    
}
