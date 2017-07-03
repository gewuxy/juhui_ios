//
//  JH_IM_Cell.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/2.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
class JH_IM_Cell: UITableViewCell {
    class func show(_ tableView:UITableView, _ indexPath:IndexPath) -> JH_IM_Cell {
        return tableView.dequeueReusableCell(withIdentifier: "JH_IM_Cell", for: indexPath) as! JH_IM_Cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    
    
}
