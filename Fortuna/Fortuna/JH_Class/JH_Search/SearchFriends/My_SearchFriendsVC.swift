//
//  My_SearchFriendsVC.swift
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

class My_SearchFriendsVC: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<Int, M_Friends>>()
    
    let dataCells = Variable([SectionModel<Int, M_Friends>]())

    var selectBlock:((M_Friends)->Void)?
}
extension My_SearchFriendsVC {
    override class func initSPVC() -> My_SearchFriendsVC {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "My_SearchFriendsVC") as! My_SearchFriendsVC
    }
    class func show(_ parentVC:UIViewController?, block:((M_Friends)->Void)? = nil) {
        let vc = My_SearchFriendsVC.initSPVC()
        vc.selectBlock = block
        vc.hidesBottomBarWhenPushed = true
        parentVC?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.makeTableViewRx()
    }
    
}
extension My_SearchFriendsVC {
    fileprivate func makeTableViewRx(){
        dataCells.value = [SectionModel(model:0,items:[])]
        
        do {
            let realm = try Realm()
            if let theRealms:M_FriendsRealmS = realm.object(ofType: M_FriendsRealmS.self, forPrimaryKey: "m_FriendsRealmfollowlist") {
                for item in theRealms.followlist {
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
            let cell = My_FriendsCell_List.show(tab)
            cell.lab_name.text = mo.name
            cell.btn_logo.sp_ImageName(mo.logo)
            return cell

        }
        
        dataCells.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        tableView.rx
            .modelSelected(M_Friends.self)
            .subscribe(onNext: { [weak self](model) in
                self?.tableView.deselectRow(at: self!.tableView.indexPathForSelectedRow!, animated: true)
                self?.selectBlock?(model)
                _ = self?.navigationController?.popViewController(animated: true)
            }).addDisposableTo(disposeBag)
    }
}

extension My_SearchFriendsVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
}

extension My_SearchFriendsVC {
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
                
                DispatchQueue.global().async {
                    do {
                        let realm = try Realm()
                        let m_RealmS = M_FriendsRealmS()
                        m_RealmS.id = "m_FriendsRealmfollowlist"
                        for item in datas {
                            let m_Realm = M_FriendsRealm()
                            m_Realm.write(item)
                            m_RealmS.followlist.append(m_Realm)
                        }
                        
                        try realm.write {
                            //写入，根据主键更新
                            realm.add(m_RealmS, update: true)
                        }
                        DispatchQueue.main.async { _ in
                        }
                    } catch let err {
                        print(err)
                    }
                }
                self?.dataCells.value[0].items = datas
                if datas.count == 0 {
                    self?._placeHolderType = .tNoData(labTitle: sp_localized("还没有关注"), btnTitle:"")
                }else if datas.count < my_pageSize{
                    self?.tableView?.sp_footerEndRefreshNoMoreData()
                }
            }else{
                self?._placeHolderType = .tNetError(labTitle: error)
            }
        }
    }
}

