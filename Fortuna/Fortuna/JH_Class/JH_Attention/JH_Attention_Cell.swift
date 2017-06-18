//
//  JH_Attention_Cell.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/13.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation

class JH_AttentionCell_Normal: UITableViewCell {
    class func show(_ tableView:UITableView, _ indexPath:IndexPath) -> JH_AttentionCell_Normal {
        return tableView.dequeueReusableCell(withIdentifier: "JH_AttentionCell_Normal", for: indexPath) as! JH_AttentionCell_Normal
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view_line.backgroundColor = UIColor.main_bg
        lab_name.textColor = UIColor.mainText_1
        lab_code.textColor = UIColor.mainText_2
        lab_range.textColor = UIColor.mainText_4
    }
    
    @IBOutlet weak var view_line: UIView!
    @IBOutlet weak var lab_name: UILabel!
    @IBOutlet weak var lab_code: UILabel!
    @IBOutlet weak var lab_price: UILabel!
    @IBOutlet weak var lab_range: UILabel!
    
}

class JH_AttentionCell_Edit: UITableViewCell {
    class func show(_ tableView:UITableView, _ indexPath:IndexPath) -> JH_AttentionCell_Edit {
        return tableView.dequeueReusableCell(withIdentifier: "JH_AttentionCell_Edit", for: indexPath) as! JH_AttentionCell_Edit
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view_line.backgroundColor = UIColor.main_bg
        lab_name.textColor = UIColor.mainText_1
        
    }
    
    @IBOutlet weak var view_line: UIView!
    @IBOutlet weak var lab_name: UILabel!
    @IBOutlet weak var btn_select: UIButton!
    @IBOutlet weak var btn_toTop: UIButton!
    
    
}
