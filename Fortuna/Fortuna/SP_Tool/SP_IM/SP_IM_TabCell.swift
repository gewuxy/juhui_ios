//
//  SP_IM_TabCell.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/28.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation

enum SP_IM_TabCellClickButtonType {
    case tLogo
    case tImg
    case tText
    case tChongFa
}
class SP_IM_TabCell_HeText: UITableViewCell {
    class func show(_ tableView:UITableView, _ indexPath:IndexPath) -> SP_IM_TabCell_HeText {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SP_IM_TabCell_HeText", for: indexPath) as! SP_IM_TabCell_HeText
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBOutlet weak var btn_logo: UIButton!
    @IBOutlet weak var lab_name: UILabel!
    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var text_title: UITextView!
    @IBOutlet weak var btn_text: UIButton!
    
    var _block:((SP_IM_TabCellClickButtonType)->Void)?
    @IBAction func buttonClick(_ sender: UIButton) {
        switch sender {
        case btn_logo:
            _block?(.tLogo)
        case btn_text:
            _block?(.tText)
        default:
            break
        }
    }
}
class SP_IM_TabCell_HeImg: UITableViewCell {
    class func show(_ tableView:UITableView, _ indexPath:IndexPath) -> SP_IM_TabCell_HeImg {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SP_IM_TabCell_HeImg", for: indexPath) as! SP_IM_TabCell_HeImg
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btn_Img.imageView?.contentMode = .scaleAspectFill
    }
    
    @IBOutlet weak var btn_logo: UIButton!
    @IBOutlet weak var lab_name: UILabel!
    @IBOutlet weak var btn_Img: UIButton!
    @IBOutlet weak var btn_play: UIButton!
    
    var _block:((SP_IM_TabCellClickButtonType)->Void)?
    @IBAction func buttonClick(_ sender: UIButton) {
        switch sender {
        case btn_logo:
            _block?(.tLogo)
        case btn_Img:
            _block?(.tImg)
        default:
            break
        }
    }
}


class SP_IM_TabCell_MeText: UITableViewCell {
    class func show(_ tableView:UITableView, _ indexPath:IndexPath) -> SP_IM_TabCell_MeText {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SP_IM_TabCell_MeText", for: indexPath) as! SP_IM_TabCell_MeText
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBOutlet weak var btn_logo: UIButton!
    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var text_title: UITextView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    @IBOutlet weak var button_CF: UIButton!
    @IBOutlet weak var btn_text: UIButton!
    
    var _block:((SP_IM_TabCellClickButtonType)->Void)?
    @IBAction func buttonClick(_ sender: UIButton) {
        switch sender {
        case btn_logo:
            _block?(.tLogo)
        case btn_text:
            _block?(.tText)
        case button_CF:
            _block?(.tChongFa)
        default:
            break
        }
    }
}

class SP_IM_TabCell_MeImg: UITableViewCell {
    class func show(_ tableView:UITableView, _ indexPath:IndexPath) -> SP_IM_TabCell_MeImg {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SP_IM_TabCell_MeImg", for: indexPath) as! SP_IM_TabCell_MeImg
        return cell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btn_Img.imageView?.contentMode = .scaleAspectFill
    }
    
    @IBOutlet weak var btn_logo: UIButton!
    @IBOutlet weak var btn_Img: UIButton!
    @IBOutlet weak var btn_play: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    @IBOutlet weak var button_CF: UIButton!
    
    
    var _block:((SP_IM_TabCellClickButtonType)->Void)?
    @IBAction func buttonClick(_ sender: UIButton) {
        switch sender {
        case btn_logo:
            _block?(.tLogo)
        case btn_Img:
            _block?(.tText)
        case button_CF:
            _block?(.tChongFa)
        default:
            break
        }
    }
}








