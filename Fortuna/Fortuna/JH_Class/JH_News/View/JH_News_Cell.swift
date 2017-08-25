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
        //self.addGestureRecognizer(longPress)
    }
    lazy var longPress:UILongPressGestureRecognizer = {
        let lo = UILongPressGestureRecognizer(target: self, action: #selector(JH_NewsCell_List.longPressClick(_:)))
        lo.minimumPressDuration = 0.5
        return lo
    }()
    func longPressClick(_ sender:UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            self.backgroundColor = UIColor.main_bgHigh
        case .ended:
            self.backgroundColor = UIColor.white
        default:
            break
        }
    }
    
    
    @IBOutlet weak var view_line: UIView!
    @IBOutlet weak var lab_name: UILabel!
    @IBOutlet weak var lab_time: UILabel!
    @IBOutlet weak var lab_time2: UILabel!
    @IBOutlet weak var img_Logo: UIImageView!
   
    
}
