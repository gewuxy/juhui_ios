//
//  JH_IM.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/27.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SocketIO
import IQKeyboardManager
import SwiftyJSON

class JH_IM: SP_ParentVC {
    
    @IBOutlet weak var view_Top: UIView!
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var view_Sco: UIScrollView!
    //@IBOutlet weak var view_Tab: UIView!
    @IBOutlet weak var view_Bot: UIView!
    @IBOutlet weak var view_hud: UIView!
    @IBOutlet weak var view_Bot_B: NSLayoutConstraint!
    @IBOutlet weak var view_Bot_H: NSLayoutConstraint!
    @IBOutlet weak var view_hud_B: NSLayoutConstraint!
    @IBOutlet weak var btn_hudImg: UIButton!
    @IBOutlet weak var btn_hudVideo: UIButton!
    @IBOutlet weak var lab_hudImg: UILabel!
    @IBOutlet weak var lab_hudVideo: UILabel!
    @IBOutlet weak var btn_numRen: UIButton!
    @IBOutlet weak var btn_numFollow: UIButton!
    @IBOutlet weak var btn_follow: UIButton!
    let disposeBag = DisposeBag()
    /*
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
    */
    var _keyBoardHeight:CGFloat = 0.0 {
        didSet{
            //self.view_Sco.contentSize = CGSize(width: sp_ScreenWidth, height: sp_ScreenHeight-64-35-self._keyBoardHeight)
            //self.view_BG.frame = CGRect(x: 0, y: 0, width: sp_ScreenWidth, height: sp_ScreenHeight-64-35-self._keyBoardHeight)
        }
    }
    
    var _hudImgHeight:CGFloat = 0 {
        didSet{
            //self.view_Sco.contentSize = CGSize(width: sp_ScreenWidth, height: sp_ScreenHeight-64-35-self._keyBoardHeight-_hudImgHeight)
            //self.view_BG.frame = CGRect(x: 0, y: 0, width: sp_ScreenWidth, height: sp_ScreenHeight-64-35-self._keyBoardHeight-_hudImgHeight)
            
        }
    }
    
    
    /*
    lazy var _tabView:SP_IM_Tab = {
        let vc = SP_IM_Tab.initSPVC()
        self.addChildViewController(vc)
        self.view_Tab.addSubview(vc.view)
        vc.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return vc
    }()*/
    
    lazy var _inputView:SP_IM_Input = {
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
    
    // 通讯连接
    lazy var socket:SocketIOClient = {
        //+"?code=" + self._followData.code
        return SocketIOClient(socketURL: URL(string: My_API.url_SocketIO广播)!, config: [.log(true),.connectParams(["code" : self._followData.code])])//.forcePolling(false)
    }()
    
    var _followData:M_Attention = M_Attention()
    var _tabDatas:[SP_IM_TabModel] = []
    var _pageIndex = 0
    var _inpPotos = [HXPhotoModel]()
    //录音 是否取消
    var _isCancelled = false
    
    var isVideo = false
    var player:KZVideoPlayer?
    var timerOf60Second:Timer?
    
    
    
    deinit {
        LGAudioPlayer.share().stopAudioPlayer()
        self.removeKeyboard()
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        //self.socket.removeAllHandlers()
        self.socket.off(self._followData.code)
        //self.socket.reconnects = false
        //self.socket.reconnect()
        self.socket.disconnect()
        
    }
    
}

extension JH_IM {
    override class func initSPVC() -> JH_IM {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_IM") as! JH_IM
    }
    class func show(_ parentVC:UIViewController?, followData:M_Attention) {
        let vc = JH_IM.initSPVC()
        vc._followData = followData
        vc.hidesBottomBarWhenPushed = true
        parentVC?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeSocketIO()
        self.makeNavigation()
        self.makeUI()
        self.makeTextInput()
        self.makeTableView()
        //self.makeTableViewDelegate()
        self.showKeyboard()
        
        self.sp_addMJRefreshFooter()
        self.tableView.sp_footerBeginRefresh()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    func makeNavigation() {
        
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    func makeUI() {
        self.n_view._title = self._followData.name + "的直播间"
        //self.view_Sco.addSubview(view_BG)
        self._keyBoardHeight = 0.0
        //self.view_BG.addSubview(view_Tab)
        //self.view_BG.addSubview(view_Bot)
        /*
        self.view_Bot.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        self.view_Tab.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(view_Bot.snp.top)
        }*/
        
        
        self.hiddenHudImg(0)
        self.makeHudImg()
        self.makeBtnFollow()
    }
    
    func makeBtnFollow() {
        self.btn_follow.setTitle(" "+sp_localized(_followData.isFollow ? "删除自选" : "+ 自选")+" " , for: .normal)
    }
    
    
    
    @IBAction func clickViewTap(_ sender: UITapGestureRecognizer) {
        hiddenHudImg()
        self._inputView.text_View.resignFirstResponder()
    }
    
    @IBAction func clickBtnFollow(_ sender: UIButton) {
        if _followData.isFollow {
            UIAlertController.showAler(self, btnText: [sp_localized("取消"),sp_localized("确定")], title: sp_localized("您将删除此自选酒"), message: "", block: { [weak self](str) in
                if str == sp_localized("确定") {
                    self?.t_删除自选数据()
                }
            })
        }else{
            t_添加自选数据()
        }
    }
}

