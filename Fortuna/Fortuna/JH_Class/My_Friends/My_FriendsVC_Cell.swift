//
//  My_FriendsVCCell.swift
//  Fortuna
//
//  Created by LCD on 2017/9/6.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation


class My_FriendsCell_List: UITableViewCell {
    class func show(_ tableView:UITableView) -> My_FriendsCell_List {
        return tableView.dequeueReusableCell(withIdentifier: "My_FriendsCell_List") as! My_FriendsCell_List
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view_line.backgroundColor = UIColor.main_line
        lab_name.textColor = UIColor.mainText_1
        //btn_logo.isEnabled = false
    }
    
    @IBOutlet weak var view_line: UIView!
    @IBOutlet weak var lab_name: UILabel!
    @IBOutlet weak var btn_logo: UIButton!
    enum btnType {
        case logo
        case follow
    }
    var _clickBtn:((btnType)->Void)?
    @IBAction func clickButton(_ sender: UIButton) {
        switch sender {
        case btn_logo:
            _clickBtn?(.logo)
        default:
            _clickBtn?(.follow)
        }
    }
    
}
