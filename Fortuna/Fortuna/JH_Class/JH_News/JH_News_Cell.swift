//
//  JH_News_Cell.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/13.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation

class JH_NewsCell_List: UITableViewCell {
    class func show(_ tableView:UITableView, _ indexPath:IndexPath) -> JH_NewsCell_List {
        return tableView.dequeueReusableCell(withIdentifier: "JH_NewsCell_List", for: indexPath) as! JH_NewsCell_List
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view_line.backgroundColor = UIColor.main_line
        lab_name.textColor = UIColor.mainText_1
        
    }
    
    @IBOutlet weak var view_line: UIView!
    @IBOutlet weak var lab_name: UILabel!
    @IBOutlet weak var lab_time: UILabel!
    @IBOutlet weak var lab_time2: UILabel!
    @IBOutlet weak var img_Logo: UIImageView!
   
    
}
