//
//  My_FriendsVC.swift
//  Fortuna
//
//  Created by LCD on 2017/8/31.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import RxDataSources

import SwiftyJSON
import Realm
import RealmSwift

class My_FriendsVC: SP_ParentVC {

    let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    
    var datas = [M_Friends]() {
        didSet{
            self.tableView.cyl_reloadData()
        }
    }

}

extension My_FriendsVC {
    override class func initSPVC() -> My_FriendsVC {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "My_FriendsVC") as! My_FriendsVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeNotification()
        self.makeUI()
        
    }
    fileprivate func makeNotification() {
        sp_Notification.rx
            .notification(SP_User.shared.ntfName_成功登陆了)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](n) in
                self?.t_获取朋友列表()
                
            }).addDisposableTo(disposeBag)
        sp_Notification.rx
            .notification(SP_User.shared.ntfName_退出登陆了)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](n) in
                self?.datas.removeAll()
                self?.t_获取朋友列表()
                
            }).addDisposableTo(disposeBag)
        sp_Notification.rx
            .notification(ntf_Name_朋友删除)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](n) in
                guard self != nil else{return}
                guard let data = n.object as? [M_Friends] else{
                    if let dat = n.object as? M_Friends {
                        for (i,item) in self!.datas.enumerated() {
                            if item.id == dat.id {
                                self!.datas.remove(at: i)
                            }
                        }
                    }
                    self?.tableView.cyl_reloadData()
                    if self?.datas.count == 0 {
                        self?.t_获取朋友列表()
                    }
                    return
                }
                self?.datas = data
                self?.tableView.cyl_reloadData()
                if self?.datas.count == 0 {
                    self?.t_获取朋友列表()
                }
            }).addDisposableTo(disposeBag)
        
        sp_Notification.rx
            .notification(ntf_Name_朋友添加)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](n) in
                self?.t_获取朋友列表()
                
            }).addDisposableTo(disposeBag)
        
    }
    
    override func sp_placeHolderViewClick() {
        switch _placeHolderType {
        case .tOnlyImage:
            break
        case .tNoData(_,_):
            self.navigationController?.tabBarController?.selectedIndex = 0
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


extension My_FriendsVC {
    fileprivate func makeUI() {
        self.n_view.isHidden = true
        
        /*
        do {
            let realm = try Realm()
            if let theRealms:M_FriendsRealmS = realm.object(ofType: M_FriendsRealmS.self, forPrimaryKey: "m_FriendsRealmfollowlist") {
                for item in theRealms.followlist {
                    dataCells.value[0].items.append(item.read())
                }
            }
        } catch let err {
            print(err)
        }*/
        makeTableView()
    }
    func makeTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self._placeHolderType = .tOnlyImage
        
        self.sp_addMJRefreshHeader()
        self.tableView.sp_headerBeginRefresh()
    }
    
}

extension My_FriendsVC:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return sp_fitSize((70,75,80))
//        
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = My_FriendsCell_List.show(tableView)
        let mo = self.datas[indexPath.row]
        cell.lab_name.text = mo.name
        cell.btn_logo.sp_ImageName(mo.logo)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            t_删除朋友关注(indexPath.row)
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


extension My_FriendsVC {
    fileprivate func sp_addMJRefreshHeader() {
        tableView?.sp_headerAddMJRefresh { [weak self]_ in
            self?.t_获取朋友列表()
        }
    }
    fileprivate func sp_EndRefresh()  {
        tableView?.sp_headerEndRefresh()
        
    }
    fileprivate func t_获取朋友列表() {
        My_API.t_获取朋友列表.post(M_Friends.self) { [weak self](isOk, data, error) in
            self?.sp_EndRefresh()
            if isOk {
                guard let datas = data as? [M_Friends] else{return}
                /*
                DispatchQueue.global().async {
                    do {
                        let realm = try Realm()
                        let m_AttentionRealmS = M_FriendsRealmS()
                        m_AttentionRealmS.id = "m_FriendsRealmfollowlist"
                        for item in datas {
                            let m_AttentionRealm = M_FriendsRealm()
                            m_AttentionRealm.write(item)
                            m_AttentionRealmS.followlist.append(m_AttentionRealm)
                        }
                        
                        try realm.write {
                            //写入，根据主键更新
                            realm.add(m_AttentionRealmS, update: true)
                        }
                        DispatchQueue.main.async { _ in
                        }
                    } catch let err {
                        print(err)
                    }
                }*/
                self?.datas = datas
                if datas.count == 0 {
                    self?._placeHolderType = .tNoData(labTitle: sp_localized("还没有关注"), btnTitle:sp_localized("去逛逛"))
                }else if datas.count < my_pageSize{
                    self?.tableView?.sp_footerEndRefreshNoMoreData()
                }
            }else{
                self?._placeHolderType = .tNetError(labTitle: error)
            }
        }
    }
    
    fileprivate func t_删除朋友关注(_ index:Int) {
        SP_HUD.show(view: self.view, type: .tLoading, text: sp_localized("正在删除"))
        My_API.t_删除朋友关注(user_id:datas[index].id).post(M_MyCommon.self) { [weak self](isOk, data, error) in
            SP_HUD.hidden()
            if isOk {
                SP_HUD.show(text:sp_localized("已删除"))
                self?.datas.remove(at: index)
            }else{
                SP_HUD.show(text:error)
            }
            
        }
    }
    
    fileprivate func t_添加朋友关注() {
        
        My_API.t_添加朋友关注(user_id:"117").post(M_MyCommon.self) { [weak self](isOk, data, error) in
            SP_HUD.hidden()
            if isOk {
                SP_HUD.show(text:sp_localized("已关注"))
                
            }else{
                SP_HUD.show(text:error)
            }
            
        }
    }
}
