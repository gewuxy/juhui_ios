//
//  JH_IM.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/27.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import SocketIO
import IQKeyboardManager

class JH_IM: SP_ParentVC {
    
    @IBOutlet weak var view_Top: UIView!
    @IBOutlet weak var view_Sco: UIScrollView!
    @IBOutlet weak var view_hud: UIView!
    @IBOutlet weak var view_hud_B: NSLayoutConstraint!
    @IBOutlet weak var btn_hudImg: UIButton!
    @IBOutlet weak var btn_hudVideo: UIButton!
    @IBOutlet weak var lab_hudImg: UILabel!
    @IBOutlet weak var lab_hudVideo: UILabel!
    
    lazy var view_BG: UIView = {
        let view = UIView()
        return view
    }()
    lazy var view_Tab: UIView = {
        let view = UIView()
        return view
    }()
    lazy var view_Bot: UIView = {
        let view = UIView()
        return view
    }()
    
    var _keyBoardHeight:CGFloat = 0.0 {
        didSet{
            self.view_Sco.contentSize = CGSize(width: sp_ScreenWidth, height: sp_ScreenHeight-64-35-self._keyBoardHeight)
            self.view_BG.frame = CGRect(x: 0, y: 0, width: sp_ScreenWidth, height: sp_ScreenHeight-64-35-self._keyBoardHeight)
        }
    }
    
    var _hudImgHeight:CGFloat = 0 {
        didSet{
            self.view_Sco.contentSize = CGSize(width: sp_ScreenWidth, height: sp_ScreenHeight-64-35-self._keyBoardHeight-_hudImgHeight)
            self.view_BG.frame = CGRect(x: 0, y: 0, width: sp_ScreenWidth, height: sp_ScreenHeight-64-35-self._keyBoardHeight-_hudImgHeight)
            
            
            
        }
    }
    
    
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
    
    //
    let socket = SocketIOClient(socketURL: URL(string: "http://localhost:8080")!, config: [.log(true), .forcePolling(true)])
    
    
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
        view_Sco.addSubview(view_BG)
        _keyBoardHeight = 0.0
        view_BG.addSubview(view_Tab)
        view_BG.addSubview(view_Bot)
        view_Bot.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        view_Tab.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(view_Bot.snp.top)
        }
        
        
        
        
        hiddenHudImg(0)
        makeHudImg()
    }
    
    @IBAction func clickViewTap(_ sender: UITapGestureRecognizer) {
        hiddenHudImg()
        _inputView.text_View.resignFirstResponder()
    }
    
    fileprivate func makeSocketIO() {
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        socket.on("currentAmount") {data, ack in
            if let cur = data[0] as? Double {
                self.socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
                    self.socket.emit("update", ["amount": cur + 2.50])
                }
                
                ack.with("Got your currentAmount", "dude")
            }
        }
        
        socket.connect()
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
                    self?.view_Bot.snp.updateConstraints({ (make) in
                        make.height.equalTo(50)
                    })
                }else if height < 100 {
                    self?.view_Bot.snp.updateConstraints({ (make) in
                        make.height.equalTo(height + 10)
                    })
                }else{
                    self?.view_Bot.snp.updateConstraints({ (make) in
                        make.height.equalTo(110)
                    })
                }
                self?.toRowBottom()
            case .tB:
                
                self?._keyBoardHeight = height
                self?.toRowBottom()
            }
        }
        
        _inputView._shouldReturnBlock = { [weak self]_ in
            
        }
    }
}
extension JH_IM {
    fileprivate func toRowBottom(_ animated:Bool = false, time:Double = 0.0){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) { [weak self] _ in
            let indexPath = IndexPath(row: 10, section: 0)
            self?._tabView.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
        
    }
    fileprivate func makeTableViewDelegate() {
        _tabView._scrollViewWillBeginDragging = { _ in
            self._inputView.text_View.resignFirstResponder()
            self.hiddenHudImg()
        }
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
        guard view_hud_B.constant != 0 else {
            return
        }
        _inputView.text_View.resignFirstResponder()
        view_hud_B.constant = 0
        _hudImgHeight = 100
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.2, animations: { [weak self]_ in
            self?.view.layoutIfNeeded()
            
        }) { (bool) in
            
        }
        toRowBottom(true)
    }
    func hiddenHudImg(_ time:TimeInterval = 0.2) {
        
        view_hud_B.constant = -100
        _hudImgHeight = 0
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
