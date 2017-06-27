//
//  JH_Search_Cell.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/13.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation

class JH_SearchCell_List: UITableViewCell {
    class func show(_ tableView:UITableView, _ indexPath:IndexPath) -> JH_SearchCell_List {
        return tableView.dequeueReusableCell(withIdentifier: "JH_SearchCell_List", for: indexPath) as! JH_SearchCell_List
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view_line.backgroundColor = UIColor.main_line
        lab_name.textColor = UIColor.mainText_1
        lab_num.textColor = UIColor.mainText_1
        lab_name.font = sp_fitFont16
        lab_num.font = sp_fitFont16
        btn_select.titleLabel?.font = sp_fitFont16
    }
    
    @IBOutlet weak var view_line: UIView!
    @IBOutlet weak var lab_name: UILabel!
    @IBOutlet weak var lab_num: UILabel!
    @IBOutlet weak var btn_select: UIButton!
    
    var _clickBlock:(()->Void)?
    @IBAction func clickButton(_ sender: UIButton) {
        _clickBlock?()
    }
    
}
