//
//  JH_Attention.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/8.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SocketIO
import SwiftyJSON
import Realm
import RealmSwift

class JH_Attention: SP_ParentVC {

    let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lab_range_W: NSLayoutConstraint!
    fileprivate var _pageIndex = 1
    fileprivate var _datas = [M_Attention]()
    
    // 通讯连接//.forcePolling(false)
    static let socket:SocketIOClient = SocketIOClient(socketURL: URL(string: My_API.url_SocketIO广播)!, config: [.log(false)])
    
    
    //MARK:--- SocketIO -----------------------------
    func makeSocketIO() {
        JH_Attention.socket.on(clientEvent: .connect) { (data, ack) in
            //iOS客户端上线
            //self?.socket.emit("login", self!._followData.code)
        }
        JH_Attention.socket.on("last_price") { [weak self](res, ack) in
             guard self != nil else{return}
            //接收到广播
            let json:[JSON] = JSON(res).arrayValue
            //print_SP("json ==> \(json)")
            guard json.count > 0 else{return}
            let model = M_AttentionDetail(json[0])
            for (i,item) in self!._datas.enumerated() {
                if item.code == model.code {
                    self!._datas[i].last_price = model.lastest_price
                    self?._datas[i].quoteChange = model.increase_ratio
                    let index = IndexPath(row: i, section: 0)
                    self?.tableView.reloadRows(at: [index], with: .none)
                    
                }
            }
        }
        /*
         self.socket.on(clientEvent: .disconnect) { (data, ack) in
         
         }*/
        
        JH_Attention.socket.connect()
    }
}


extension JH_Attention {
    override class func initSPVC() -> JH_Attention {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_Attention") as! JH_Attention
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeNavigation()
        self.makeUI()
        self.makeNotification()
        self.makeSocketIO()
        //print_SP(SP_User.shared.deviceUUID)
    }
    fileprivate func makeNavigation() {
        
        n_view.n_btn_L1_Image = ""
        n_view.n_btn_L1_Text = sp_localized("编辑")
        n_view.n_btn_R1_Image = "Attention搜索w"
        
        n_view.n_btn_L1_L.constant = 15
        n_view.n_btn_R1_R.constant = 15
        
    }
    
    fileprivate func makeUI() {
        lab_range_W.constant = sp_fitSize((95,110,125))
        
        do {
            let realm = try Realm()
            if let theRealms:M_AttentionRealmS = realm.object(ofType: M_AttentionRealmS.self, forPrimaryKey: "m_AttentionRealm") {
                for item in theRealms.attentions {
                    _datas.append(item.read())
                }
            }
        } catch let err {
            print(err)
        }
        makeTableView()
    }
    func makeTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self._placeHolderType = .tOnlyImage
        self.tableView.cyl_reloadData()
        self.sp_addMJRefreshHeader()
        self.tableView.sp_headerBeginRefresh()
    }
    
    fileprivate func makeNotification() {
        sp_Notification.rx
            .notification(SP_User.shared.ntfName_成功登陆了)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](n) in
                self?._pageIndex = 1
                self?.t_获取自选列表()
                
            }).addDisposableTo(disposeBag)
        sp_Notification.rx
            .notification(SP_User.shared.ntfName_退出登陆了)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](n) in
                self?._datas.removeAll()
                //self?.tableView.cyl_reloadData()
                self?._pageIndex = 1
                self?.t_获取自选列表()
                
            }).addDisposableTo(disposeBag)
        sp_Notification.rx
            .notification(ntf_Name_自选删除)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](n) in
                guard self != nil else{return}
                guard let data = n.object as? [M_Attention] else{
                    if let dat = n.object as? M_Attention {
                        for (i,item) in self!._datas.enumerated() {
                            if item.code == dat.code {
                                self!._datas.remove(at: i)
                            }
                        }
                    }
                    self?.tableView.cyl_reloadData()
                    if self?._datas.count == 0 {
                        self?._pageIndex = 1
                        self?.t_获取自选列表()
                    }
                    return
                }
                self?._datas = data
                self?.tableView.cyl_reloadData()
                if self?._datas.count == 0 {
                    self?._pageIndex = 1
                    self?.t_获取自选列表()
                }
            }).addDisposableTo(disposeBag)
        
        sp_Notification.rx
            .notification(ntf_Name_自选添加)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](n) in
                self?._pageIndex = 1
                self?.t_获取自选列表()
                /*
                guard let data = n.object as? M_Attention else{
                    self?._pageIndex = 1
                    self?.t_获取自选列表()
                    return
                }
                self?._datas.insert(data, at: 0)
                self?.tableView.cyl_reloadData()
                if self?._datas.count == 0 {
                    self?._pageIndex = 1
                    self?.t_获取自选列表()
                }*/
            }).addDisposableTo(disposeBag)
        
        sp_Notification.rx
            .notification(ntf_Name_自选排序)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](n) in
                guard let data = n.object as? [M_Attention] else{return}
                self?._datas = data
                self?.tableView.cyl_reloadData()
            }).addDisposableTo(disposeBag)
    }
    
    override func clickN_btn_L1() {
        guard _datas.count > 0 else {
            UIAlertController.showAler(self, btnText: [sp_localized("取消") ,sp_localized("去添加")], title: sp_localized("您还没有自选酒"), block: { [weak self](text) in
                if text == sp_localized("去添加") {
                    self?.clickN_btn_R1()
                    //self.navigationController?.tabBarController?.selectedIndex = 2
                }
            })
            return
        }
        JH_AttentionEdit.show(self, datas:_datas, pageIndex:_pageIndex)
    }
    override func clickN_btn_R1() {
        JH_Search.show(self)
    }
    
    override func placeHolderViewClick() {
        switch _placeHolderType {
        case .tOnlyImage:
            break
        case .tNoData(_,_):
            clickN_btn_R1()
            //self.navigationController?.tabBarController?.selectedIndex = 2
        case .tNetError(let lab):
            if lab == My_NetCodeError.t需要登录.stringValue {
                SP_Login.show(self)
            }else{
                self._placeHolderType = .tOnlyImage
                self.tableView.sp_headerBeginRefresh()
            }
        }
    }
}


extension JH_Attention:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _datas.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return sp_fitSize((70,75,80))
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JH_AttentionCell_Normal.show(tableView, indexPath)
        let model = _datas[indexPath.row]
        cell.lab_name.text = model.name
        cell.lab_code.text = model.code
        cell.lab_price.text = model.last_price
        cell.lab_range.text = model.quoteChange
        cell.lab_range.textColor = model.quoteChange.hasPrefix("-") ? UIColor.mainText_5 : UIColor.mainText_4
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        JH_AttentionDetails.show(self, data:_datas[indexPath.row])
        
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            t_删除自选数据(indexPath.row)
        }
    }
    
    /*
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) {
            return true
        }
        return false
    }
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        if action == #selector(copy(_:)) {
            UIPasteboard.general.string = _datas[indexPath.row].name
        }
    }*/
}



//MARK:--- 网络 -----------------------------
extension JH_Attention {
    fileprivate func sp_addMJRefreshHeader() {
        tableView?.sp_headerAddMJRefresh { [weak self]_ in
            self?._pageIndex = 1
            self?.t_获取自选列表()
        }
    }
    fileprivate func sp_addMJRefreshFooter() {
        tableView?.sp_footerAddMJRefresh_Auto { [weak self]_ in
            self?._pageIndex += 1
            self?.t_获取自选列表()
            
            
        }
    }
    
    fileprivate func sp_EndRefresh()  {
        tableView?.sp_headerEndRefresh()
        tableView?.sp_footerEndRefresh()
    }
    
    fileprivate func t_获取自选列表() {
        
        My_API.t_获取自选列表(page:_pageIndex).post(M_Attention.self) { [weak self](isOk, data, error) in
            self?.sp_EndRefresh()
            
            if isOk {
                guard var datas = data as? [M_Attention] else{return}
                
                var ddd = [M_Attention]()
                
                for var item in datas {
                    item.isFollow = true
                    ddd.append(item)
                }
                datas = ddd
                if self?._pageIndex == 1 {
                    DispatchQueue.global().async { [weak self] _ in
                        do {
                            let realm = try Realm()
                            let m_AttentionRealmS = M_AttentionRealmS()
                            m_AttentionRealmS.id = "m_AttentionRealm"
                            for item in datas {
                                let m_AttentionRealm = M_AttentionRealm()
                                m_AttentionRealm.write(item)
                                m_AttentionRealmS.attentions.append(m_AttentionRealm)
                            }
                            try realm.write {
                                //写入，根据主键更新
                                realm.add(m_AttentionRealmS, update: true)
                            }
                            //打印出数据库地址
                            //print(realm.configuration.fileURL)
                            
                            DispatchQueue.main.async { _ in
                                
                            }
                            
                        } catch let err {
                            print(err)
                        }
                    }
                    
                    self?._datas = datas
                    self?.sp_addMJRefreshFooter()
                    if datas.count == 0 {
                        self?._placeHolderType = .tNoData(labTitle: sp_localized("还没有自选酒"), btnTitle:sp_localized("点击添加"))
                    }else if datas.count < my_pageSize{
                        self?.tableView?.sp_footerEndRefreshNoMoreData()
                        
                    }
                }else{
                    self?._datas += datas
                    
                    if datas.count < my_pageSize {
                        self?._footRefersh = false
                        self?.sp_addMJRefreshFooter()
                        self?.tableView?.sp_footerEndRefreshNoMoreData()
                    }
                }
                self?.tableView.cyl_reloadData()
            }else{
                
                self?._placeHolderType = .tNetError(labTitle: error)
                self?.tableView.cyl_reloadData()
            }
            
        }
    }
    
    fileprivate func t_删除自选数据(_ index:Int) {
        SP_HUD.show(view: self.view, type: .tLoading, text: sp_localized("正在删除"))
        My_API.t_删除自选数据(code:_datas[index].code).post(M_Attention.self) { [weak self](isOk, data, error) in
            SP_HUD.hidden()
            if isOk {
                SP_HUD.show(text:sp_localized("已删除"))
                self?._datas.remove(at: index)
                self?.tableView.cyl_reloadData()
            }else{
                SP_HUD.show(text:error)
            }
            
        }
    }

    
}

