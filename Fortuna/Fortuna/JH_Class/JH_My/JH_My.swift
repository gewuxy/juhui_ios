//
//  JH_My.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/8.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

enum JH_MyCellType:String {
    case t用户 = "用户"
    case t我的持仓 = "我的持仓"
    case t当日成交 = "当日成交"
    case t当日委托 = "当日委托"
    case t历史成交 = "历史成交"
    case t历史委托 = "历史委托"
    case t设置 = "设置"
}




class JH_My: SP_ParentVC {

    lazy var _height_Top:CGFloat = sp_ScreenWidth/1.4
    
    lazy var _imgae_Bg_Rate:CGFloat = 2
    @IBOutlet weak var image_Bg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var _sectionsHead:[(type: JH_MyCellType,txtR: String,imgL: String,imgR: String,on_off: Bool)] = {
        return [(.t用户,"", "", "", false),
                (.t我的持仓, "","","com_向右",false),
                (.t当日成交, "", "wd_帖子", "com_向右", false),
                (.t当日委托, "", "wd_帖子", "com_向右", false),
                (.t历史成交, "", "wd_帖子", "com_向右", false),
                (.t历史委托, "", "wd_帖子", "com_向右", false),
                (.t设置,"", "wd_帖子", "com_向右", false)]
    }()
}

extension JH_My {
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigation()
        makeImage_Bg()
        makeTableView()
        makeLogin()
    }
    fileprivate func makeNavigation() {
        n_view.n_btn_L1_Image = ""
        
        n_view.sp_setBgAlpha(UIColor.main_1,textColor: UIColor.white, offsetY: 0, maxOffsetY: _height_Top, leftBackImg: "", leftBackImg2: "",btnBgAlpha:false)
        
        view.backgroundColor = UIColor.main_bg
    }
    fileprivate func makeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    fileprivate func makeImage_Bg(){
        image_Bg.frame = CGRect(x:0, y:0, width:sp_ScreenWidth, height:_height_Top)
    }
    fileprivate func changeImage_Bg(_ point:CGPoint){
        /**
         样式 1：下拉放大，上拉覆盖
         */
        var rect = image_Bg.frame
        if(point.y >= 0 ){
            rect.origin.y = -point.y/1.5
        }else{
            rect.size.height = _height_Top - point.y
        }
        image_Bg.frame = rect
    }
    
    fileprivate func makeLogin() {
        SP_Login.show(self) { (isOk) in
            
        }
    }
    
}

extension JH_My:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return _sectionsHead.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch _sectionsHead[section].type {
        case .t用户:
            return 1
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch _sectionsHead[section].type {
        case .t用户:
            return sp_SectionH_Min
        default:
            return sp_SectionH_Top
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch _sectionsHead[section].type {
        case .t用户, .t我的持仓, .t历史委托, .t设置:
            return sp_SectionH_Foot
        default:
            return sp_SectionH_Min
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch _sectionsHead[indexPath.section].type {
        case .t用户:
            return _height_Top
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch _sectionsHead[section].type {
        case .t用户:
            return nil
        default:
            
            let headView = SP_ComCell.show((_sectionsHead[section].imgL,_sectionsHead[section].imgR), title: (_sectionsHead[section].type.rawValue,_sectionsHead[section].txtR), hiddenLine: false)
            headView.frame = CGRect(x: 0, y: 0, width: sp_ScreenWidth, height: 50)
            headView._tapBlock = { [unowned self]() in
                self.didSelectAt(self._sectionsHead[section].type, section:section)
            }
            headView.updateUI(labelL:(font: SP_InfoOC.sp_fontFit(withSize: 17), color: UIColor.mainText_1))
            
            switch _sectionsHead[section].type {
            case .t我的持仓, .t设置, .t历史委托:
                headView.view_Line.isHidden = true
            default:
                headView.view_Line.isHidden = false
            }
            
            return headView
            
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.main_bg
        return view
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch _sectionsHead[indexPath.section].type {
        case .t用户:
            let cell = JH_MyCell_User.show(tableView, indexPath)
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    func didSelectAt(_ type:JH_MyCellType, section:Int) {
        if type == .t设置 {
            
        }else{
            /*
            guard SP_User.shared.userIsLogin else{
                SP_Login.show(self, block: { [weak self](isOk) in
                    self?.myTableView.reloadData()
                })
                return
            }*/
            
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        changeImage_Bg(scrollView.contentOffset)
    }
}

class JH_MyCell_User: UITableViewCell {
    class func show(_ tableView: UITableView, _ indexPath: IndexPath)->JH_MyCell_User {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JH_MyCell_User", for: indexPath) as! JH_MyCell_User
        return cell
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        view_logoBg.layer.borderColor = UIColor.white.cgColor
        view_logoBg.layer.borderWidth = 0.5
        
    }
    @IBOutlet weak var view_logoBg: UIView!
    @IBOutlet weak var img_Logo: UIImageView!
    @IBOutlet weak var lab_name: UILabel!
    @IBOutlet weak var lab_subName: UILabel!
    
}



