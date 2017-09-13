//
//  JH_AttentionDetails_NewsVC.swift
//  Fortuna
//
//  Created by LCD on 2017/9/12.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import SwiftyJSON

class JH_AttentionDetails_NewsVC: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<Int, M_News>>()
    
    let dataCells = Variable([SectionModel<Int, M_News>]())
    var _pageIndex = 1
}

extension JH_AttentionDetails_NewsVC {
    override class func initSPVC() -> JH_AttentionDetails_NewsVC {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_AttentionDetails_NewsVC") as! JH_AttentionDetails_NewsVC
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeTableView()
        
    }
    func makeTableView() {
        self.n_view.isHidden = true
        
        self._placeHolderType = .tOnlyImage
        self.sp_addPlaceHolderView()
        _placeHolderView.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(0)
        }
        self.makeTableViewRx()
        self.sp_addMJRefreshHeader()
        self.tableView.sp_headerBeginRefresh()
    }
    fileprivate func makeTableViewRx() {
        //dataCells.value = [SectionModel(model:0,items:[])]
        dataCells.asObservable()
            .map { !$0.isEmpty }
            .shareReplay(1)
            .bind(to: _placeHolderView.rx.isHidden)
            .addDisposableTo(disposeBag)
        /* 用所有的 [Item] 是否为空绑定 view 是否隐藏
         dataCells.asObservable()
         .map {  $0.map { $0.items }.reduce([], +)  }
         .map { $0.isEmpty }
         .bind(to: view.rx.isHidden)
         .disposed(by: disposeBag)
         */
        
        tableView.rx.setDelegate(self).addDisposableTo(disposeBag)
        
        self.makeTableViewCell()
        
        dataCells.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        self.didSelectTableView()
    }
    fileprivate func makeTableViewCell() {
        dataSource.configureCell = { (dataSource, tab, indexPath, model) in
            let cell = JH_NewsCell_List.show(tab)
            cell.img_Logo.sp_ImageName(model.thumb_img)
            cell.lab_name.text = model.title
            cell.lab_time.text = model.newsYY
            cell.lab_time2.text = model.newsMM
            return cell
        }
    }
    
    fileprivate func didSelectTableView() {
        tableView.rx
            .modelSelected(M_News.self)
            .subscribe(onNext: { [weak self](model) in
                self?.tableView.deselectRow(at: self!.tableView.indexPathForSelectedRow!, animated: true)
                JH_NewsDetials.show(self,data:model)
            })
            .addDisposableTo(disposeBag)
    }
}

extension JH_AttentionDetails_NewsVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sp_fitSize((90, 100, 110))
    }
}

extension JH_AttentionDetails_NewsVC {
    fileprivate func sp_addMJRefreshHeader() {
        tableView?.sp_headerAddMJRefresh { [weak self]_ in
            self?._pageIndex = 1
            self?.t_获取资讯列表()
            
        }
    }
    fileprivate func sp_addMJRefreshFooter() {
        tableView?.sp_footerAddMJRefresh_Auto { [weak self]_ in
            self?._pageIndex += 1
            self?.t_获取资讯列表()
            
            
        }
    }
    
    fileprivate func sp_EndRefresh()  {
        tableView?.sp_headerEndRefresh()
        tableView?.sp_footerEndRefresh()
    }
    fileprivate func t_获取资讯列表() {
        My_API.t_获取资讯列表(page:_pageIndex).post(M_News.self) { [weak self](isOk, data, error) in
            self?.sp_EndRefresh()
            
            guard self != nil else{return}
            if isOk {
                guard let datas = data as? [M_News] else{return}
                if self?._pageIndex == 1 {
                    /*
                    DispatchQueue.global().async {
                        do {
                            let realm = try Realm()
                            for (index,item) in datas.enumerated() {
                                let m_AttentionRealm = M_NewsRealm()
                                m_AttentionRealm.write(item, index)
                                try realm.write {
                                    //写入，根据主键更新
                                    realm.add(m_AttentionRealm, update: true)
                                }
                            }
                            DispatchQueue.main.async { _ in
                            }
                        } catch let err {
                            print(err)
                        }
                    }*/
                    //self?.dataCells.value[0].items = datas
                    //self!._datas = datas
                    if datas.count > 0 {
                        self?.dataCells.value = [SectionModel(model: self!._pageIndex-1, items: datas)]
                        self?.sp_addMJRefreshFooter()
                    }else{
                        self?._placeHolderType = .tNoData(labTitle: sp_localized("9011110"), btnTitle:sp_localized("点击刷新"))
                        
                    }
                }else{
                    self?.dataCells.value.append(SectionModel(model: self!._pageIndex-1, items: datas))
                    
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




