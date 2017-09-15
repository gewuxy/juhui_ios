//
//  My_MsgVC.swift
//  Fortuna
//
//  Created by LCD on 2017/8/24.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RealmSwift

class My_MsgVC: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<Int, M_MyMsgList>>()
    
    let dataCells = Variable([SectionModel<Int, M_MyMsgList>]())
    
    var _pageIndex = 1
}

extension My_MsgVC {
    override class func initSPVC() -> My_MsgVC {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "My_MsgVC") as! My_MsgVC
    }
    class func show(_ parentVC:UIViewController?) {
        let vc = My_MsgVC.initSPVC()
        vc.hidesBottomBarWhenPushed = true
        parentVC?.navigationController?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.n_view._title = sp_localized("消息")
        self.makeTableViewRx()
    }
    
}
extension My_MsgVC {
    fileprivate func makeTableViewRx(){
        
        dataCells.value = [SectionModel(model:0,items:[])]
        
        do {
            let realm = try Realm()
            let theRealms:Results<M_MyMsgListRealm> = realm.objects(M_MyMsgListRealm.self)
            
            for item in theRealms {
                self.dataCells.value[0].items.append(item.read())
                
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
            let cell = tab.dequeueReusableCell(withIdentifier: "My_MsgVCCell")
            switch mo.type {
            case .t评论:
                cell?.textLabel?.text = mo.from_user_name + "  评论了你"
            case .t点赞:
                cell?.textLabel?.text = mo.from_user_name + "  赞了你"
            case .t新短评:
                cell?.textLabel?.text = "发表了一篇短评"
                
            default:
                cell?.textLabel?.text = ""
            }
            cell?.detailTextLabel?.text = mo.create_time
            
            return cell!
        }
        tableView.rx
            .modelSelected(M_MyMsgList.self)
            .subscribe(onNext: { [weak self](model) in
            self?.tableView.deselectRow(at: self!.tableView.indexPathForSelectedRow!, animated: true)
            })
            .addDisposableTo(disposeBag)
        dataCells.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
    }
}
extension My_MsgVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
}

extension My_MsgVC {
    fileprivate func sp_addMJRefreshHeader() {
        tableView?.sp_headerAddMJRefresh { [weak self]_ in
            self?._pageIndex = 1
            self?.t_获取消息列表()
        }
    }
    fileprivate func sp_addMJRefreshFooter() {
        tableView?.sp_footerAddMJRefresh_Auto { [weak self]_ in
            self?._pageIndex += 1
            self?.t_获取消息列表()
            
        }
    }
    
    fileprivate func sp_EndRefresh()  {
        tableView?.sp_headerEndRefresh()
        tableView?.sp_footerEndRefresh()
    }
    fileprivate func t_获取消息列表() {
        My_API.t_获取消息列表(page:_pageIndex).post(M_MyMsgList.self) { [weak self](isOk, data, error) in
            self?.sp_EndRefresh()
            
            guard self != nil else{return}
            if isOk {
                guard let datas = data as? [M_MyMsgList] else{return}
                if self?._pageIndex == 1 {
                    
                    DispatchQueue.global().async {
                        do {
                            let realm = try Realm()
                            for item in datas {
                                let m_Realm = M_MyMsgListRealm()
                                m_Realm.write(item)
                                try realm.write {
                                    //写入，根据主键更新
                                    realm.add(m_Realm, update: true)
                                }
                            }
                            DispatchQueue.main.async { _ in
                            }
                        } catch let err {
                            print(err)
                        }
                    }
                    //self?.dataCells.value[0].items = datas
                    //self!._datas = datas
                    if datas.count > 0 {
                        self?.dataCells.value = [
                            SectionModel(model:0,items:datas)
                        ]
                        self?.sp_addMJRefreshFooter()
                    }else{
                        self?._placeHolderType = .tNoData(labTitle: sp_localized("9011110"), btnTitle:sp_localized("点击刷新"))
                        
                    }
                }else{
                    self?.dataCells.value.append(SectionModel(model:0,items:datas))
                    if datas.count == 0 {
                        self?.tableView.sp_footerEndRefreshNoMoreData()
                        
                    }
                }
            }else{
                if self!.dataCells.value.count > 0 {
                    SP_HUD.showMsg(error)
                }else{
                    self?._placeHolderType = .tNetError(labTitle: error)
                }
            }
        }
    }
}
