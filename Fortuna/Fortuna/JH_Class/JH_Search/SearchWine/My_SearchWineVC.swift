//
//  My_SearchWineVC.swift
//  Fortuna
//
//  Created by LCD on 2017/8/29.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwiftyJSON
import RealmSwift

class My_SearchWineVC: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!
    fileprivate let disposeBag = DisposeBag()
    fileprivate let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<Int, M_Attention>>()
    
    fileprivate let dataCells = Variable([SectionModel<Int, M_Attention>]())
    fileprivate var _pageIndex = 1
    var selectBlock:((M_Attention)->Void)?
}
extension My_SearchWineVC {
    override class func initSPVC() -> My_SearchWineVC {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "My_SearchWineVC") as! My_SearchWineVC
    }
    class func show(_ parentVC:UIViewController?, block:((M_Attention)->Void)? = nil) {
        let vc = My_SearchWineVC.initSPVC()
        vc.selectBlock = block
        vc.hidesBottomBarWhenPushed = true
        parentVC?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeNotification()
        self.makeTableViewRx()
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
                self?.dataCells.value[0].items.removeAll()
                
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
                        for (i,item) in self!.dataCells.value[0].items.enumerated() {
                            if item.code == dat.code {
                                self!.dataCells.value[0].items.remove(at: i)
                            }
                        }
                    }
                    
                    if self?.dataCells.value[0].items.count == 0 {
                        self?._pageIndex = 1
                        self?.t_获取自选列表()
                    }
                    return
                }
                self?.dataCells.value[0].items = data
                
                if self?.dataCells.value[0].items.count == 0 {
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
                
            }).addDisposableTo(disposeBag)
        
        sp_Notification.rx
            .notification(ntf_Name_自选排序)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](n) in
                guard let data = n.object as? [M_Attention] else{return}
                self?.dataCells.value[0].items = data
                
            }).addDisposableTo(disposeBag)
    }
    override func sp_placeHolderViewClick() {
        switch _placeHolderType {
        case .tOnlyImage:
            break
        case .tNoData(_,_):
            JH_Search.show(self)
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
extension My_SearchWineVC {
    fileprivate func makeTableViewRx(){
        
        dataCells.value = [SectionModel(model:0,items:[])]
        
        do {
            let realm = try Realm()
            if let theRealms:M_AttentionRealmS = realm.object(ofType: M_AttentionRealmS.self, forPrimaryKey: "m_AttentionRealm") {
                for item in theRealms.attentions {
                    dataCells.value[0].items.append(item.read())
                }
            }
        } catch let err {
            print(err)
        }
        
        self._placeHolderType = .tOnlyImage
        self.sp_addPlaceHolderView()
        
        self.sp_addMJRefreshHeader()
        self.tableView.sp_headerBeginRefresh()
        
        // 用所有的 [Item] 是否为空绑定 view 是否隐藏
        dataCells.asObservable()
            .map {  $0.map { $0.items }.reduce([], +)  }
            .map { !$0.isEmpty }
            .bind(to: _placeHolderView.rx.isHidden)
            .addDisposableTo(disposeBag)
        
        tableView.rx.setDelegate(self).addDisposableTo(disposeBag)
        
        dataSource.configureCell = { (dat,tab,indexPath,mo) in
            let cell = JH_AttentionCell_Normal.show(tab)
            
            cell.lab_name.text = mo.name
            cell.lab_code.text = mo.code
            cell.lab_price.text = mo.last_price
            cell.lab_range.text = mo.quoteChange
            cell.lab_range.textColor = mo.quoteChange.hasPrefix("-") ? UIColor.mainText_5 : UIColor.mainText_4
            return cell
        }
        
        dataCells.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        tableView.rx
            .modelSelected(M_Attention.self)
            .subscribe(onNext: { [weak self](model) in
                self?.tableView.deselectRow(at: self!.tableView.indexPathForSelectedRow!, animated: true)
                self?.selectBlock?(model)
                _ = self?.navigationController?.popViewController(animated: true)
            }).addDisposableTo(disposeBag)
    }
}
extension My_SearchWineVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sp_fitSize((70,75,80))
        
    }
}
extension My_SearchWineVC {
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
                    
                    DispatchQueue.global().async {
                        do {
                            let realm = try Realm()
                            let m_RealmS = M_AttentionRealmS()
                            m_RealmS.id = "m_AttentionRealm"
                            for item in datas {
                                let m_Realm = M_AttentionRealm()
                                m_Realm.write(item)
                                m_RealmS.attentions.append(m_Realm)
                            }
                            try realm.write {
                                //写入，根据主键更新
                                realm.add(m_RealmS, update: true)
                            }
                            //打印出数据库地址
                            //print(realm.configuration.fileURL)
                            
                            DispatchQueue.main.async { _ in
                                
                            }
                            
                        } catch let err {
                            print(err)
                        }
                    }
                    
                    self?.dataCells.value[0].items = datas
                    self?.sp_addMJRefreshFooter()
                    if datas.count == 0 {
                        self?._placeHolderType = .tNoData(labTitle: sp_localized("还没有自选酒"), btnTitle:sp_localized("点击添加"))
                    }else if datas.count < my_pageSize{
                        self?.tableView?.sp_footerEndRefreshNoMoreData()
                        
                    }
                }else{
                    self?.dataCells.value[0].items += datas
                    
                    if datas.count < my_pageSize {
                        self?._footRefersh = false
                        self?.sp_addMJRefreshFooter()
                        self?.tableView?.sp_footerEndRefreshNoMoreData()
                    }
                }
                
            }else{
                
                self?._placeHolderType = .tNetError(labTitle: error)
                
            }
            
        }
    }
}

