//
//  JH_IM.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/27.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class JH_IM: SP_ParentVC {

    
    @IBOutlet weak var view_Top: UIView!
    @IBOutlet weak var view_Tab: UIView!
    @IBOutlet weak var view_Bot: UIView!
    @IBOutlet weak var view_Bot_H: NSLayoutConstraint!
    @IBOutlet weak var view_Bot_B: NSLayoutConstraint!

    @IBOutlet weak var view_hud: UIView!
    @IBOutlet weak var view_hud_B: NSLayoutConstraint!
    @IBOutlet weak var btn_hudImg: UIButton!
    @IBOutlet weak var btn_hudVideo: UIButton!
    @IBOutlet weak var lab_hudImg: UILabel!
    @IBOutlet weak var lab_hudVideo: UILabel!
    
    
    
    
    fileprivate lazy var _tabView:SP_IM_Tab = {
        let vc = SP_IM_Tab.initSPVC()
        self.addChildViewController(vc)
        self.view_Tab.addSubview(vc.view)
        vc.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return vc
    }()
    
    fileprivate lazy var _inputView:SP_IM_Input = {
        let view = SP_IM_Input.show(self.view_Bot)
        return view
    }()
    lazy var manager:HXPhotoManager = {
        let man = HXPhotoManager(type: HXPhotoManagerSelectedTypePhotoAndVideo)
        man?.videoMaxNum = 1
        man?.photoMaxNum = 9
        man?.selectTogether = false
        return man!
    }()
    
    
    
}

extension JH_IM {
    override class func initSPVC() -> JH_IM {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_IM") as! JH_IM
    }
    class func show(_ parentVC:UIViewController?) {
        let vc = JH_IM.initSPVC()
        vc.hidesBottomBarWhenPushed = true
        parentVC?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigation()
        makeUI()
        makeTextInput()
        makeTableViewDelegate()
        toRowBottom()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    fileprivate func makeNavigation() {
        
    }
    fileprivate func makeUI() {
        
        hiddenHudImg(0)
        makeHudImg()
    }
    
    @IBAction func clickViewTap(_ sender: UITapGestureRecognizer) {
        hiddenHudImg()
        _inputView.text_View.resignFirstResponder()
    }
}
extension JH_IM {
    fileprivate func makeTextInput(){
        _inputView._block = { [weak self](type,text) in
            switch type {
            case .tBtn_R:
                self?.showHudImg()
            case .tBegin:
                self?.hiddenHudImg()
            default:
                break
            }
        }
        _inputView._heightBlock = { [weak self](type,height) in
            switch type {
            case .tH:
                if height <= 40 {
                    self?.view_Bot_H.constant = 50
                }else if height < 100 {
                    self?.view_Bot_H.constant = height + 10
                }else{
                    self?.view_Bot_H.constant = 110
                }
            case .tB:
                self?.view_Bot_B.constant = height
            case .tFinish:
                self?.toRowBottom()
                
            }
        }
    }
}
extension JH_IM {
    fileprivate func toRowBottom(_ animated:Bool = false){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [weak self] _ in
            let indexPath = IndexPath(row: 10, section: 0)
            self?._tabView.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
        
    }
    fileprivate func makeTableViewDelegate() {
        _tabView._numberOfSections = { _ -> Int in
            return 1
        }
        _tabView._numberOfRowsInSection = { _ -> Int in
            return 11
        }
        
        _tabView._cellForRowAt = { [weak self](tableView,indexPath) -> UITableViewCell in
            switch indexPath.row%2 {
            case 0:
                if indexPath.row%3 == 0 {
                    let cell = SP_IM_TabCell_MeImg.show(tableView, indexPath)
                    return cell
                }else{
                    let cell = SP_IM_TabCell_MeText.show(tableView, indexPath)
                    return cell
                }
                
            default:
                if indexPath.row%3 == 0 {
                    let cell = SP_IM_TabCell_HeImg.show(tableView, indexPath)
                    return cell
                }else{
                    let cell = SP_IM_TabCell_HeText.show(tableView, indexPath)
                    return cell
                }
                
            }
        }
        
        
        
    }
}

extension JH_IM {
    fileprivate func makeHudImg() {
        btn_hudImg.layer.borderWidth = 0.5
        btn_hudImg.layer.borderColor = UIColor.main_line.cgColor
        btn_hudVideo.layer.borderWidth = 0.5
        btn_hudVideo.layer.borderColor = UIColor.main_line.cgColor
        
        lab_hudImg.text = sp_localized("图片")
        lab_hudVideo.text = sp_localized("视频")
        
    }
    fileprivate func showHudImg() {
        view_hud_B.constant = 0
        view_Bot_B.constant = 100
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.2, animations: { [weak self]_ in
            self?.view.layoutIfNeeded()
        }) { (bool) in
            
        }
    }
    func hiddenHudImg(_ time:TimeInterval = 0.2) {
        view_hud_B.constant = -100
        view_Bot_B.constant = 0
        self.view.setNeedsLayout()
        UIView.animate(withDuration: time, animations: { [weak self]_ in
            self?.view.layoutIfNeeded()
        }) { (bool) in
            
        }
        
    }
    
    @IBAction func clickHudBtn(_ sender: UIButton) {
        switch sender {
        case btn_hudImg:
            selectPhoto()
        case btn_hudVideo:
            selectVideo()
        default:
            break
        }
    }
    
    
}
