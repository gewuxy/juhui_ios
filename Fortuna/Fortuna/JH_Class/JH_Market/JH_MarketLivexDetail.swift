//
//  JH_MarketLivexDetail.swift
//  Fortuna
//
//  Created by LCD on 2017/9/13.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
class JH_MarketLivexDetail: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<Int, M_LivExHistory>>()
    let dataCells = Variable([SectionModel<Int, M_LivExHistory>]())
    var model = M_LivExList()
    
}
extension JH_MarketLivexDetail {
    override class func initSPVC() -> JH_MarketLivexDetail {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_MarketLivexDetail") as! JH_MarketLivexDetail
    }
    class func show(_ pvc:UIViewController?, _ model:M_LivExList) {
        let vc = JH_MarketLivexDetail.initSPVC()
        vc.model = model
        
        vc.hidesBottomBarWhenPushed = true
        pvc?.navigationController?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.n_view._title = model.name
        
        makeTableView()
    }
    override func sp_placeHolderViewClick() {
        switch _placeHolderType {
        case .tOnlyImage:
            break
        case .tNoData(_,_):
            self.tableView.sp_headerBeginRefresh()
        case .tNetError(_):
            self.tableView.sp_headerBeginRefresh()
        }
    }
    func makeTableView() {
        self._placeHolderType = .tOnlyImage
        self.sp_addPlaceHolderView()
        
        self.sp_addMJRefreshHeader()
        self.tableView.sp_headerBeginRefresh()
        self.sp_addPlaceHolderView()
        
        // 用所有的 [Item] 是否为空绑定 view 是否隐藏
        dataCells.asObservable()
            .map {  $0.map { $0.items }.reduce([], +)  }
            .map { !$0.isEmpty }
            .bind(to: _placeHolderView.rx.isHidden)
            .addDisposableTo(disposeBag)
        
        tableView.rx.setDelegate(self).addDisposableTo(disposeBag)
        
        dataSource.configureCell = { (dat,tab,indexPath,mo) in
            let cell = JH_AttentionCell_Normal.show(tab)
            cell.lab_name.text = mo.level
            cell.lab_code.text = mo.dates
            cell.lab_price.text = mo.pctChange
            cell.lab_range.text = mo.change
            cell.lab_range.textColor = mo.change.hasPrefix("-") ? UIColor.mainText_5 : UIColor.mainText_4
            cell.lab_name.textColor = mo.level.hasPrefix("-") ? UIColor.mainText_5 : UIColor.mainText_4
            cell.lab_code.font = SP_InfoOC.sp_fontFit(withSize: 18, weightType: tRegular)
            return cell
        }
        
        dataCells.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        tableView.rx
            .modelSelected(M_LivExHistory.self)
            .subscribe(onNext: { [weak self](model) in
                self?.tableView.deselectRow(at: self!.tableView.indexPathForSelectedRow!, animated: true)
            }).addDisposableTo(disposeBag)
    }
}
extension JH_MarketLivexDetail:UITableViewDelegate {
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
extension JH_MarketLivexDetail {
    fileprivate func sp_addMJRefreshHeader() {
        tableView?.sp_headerAddMJRefresh { [weak self]_ in
            
            self?.t_Liv最近一个时间段的数据数据()
        }
    }
    fileprivate func sp_EndRefresh()  {
        tableView?.sp_headerEndRefresh()
    }
    fileprivate func t_Liv最近一个时间段的数据数据() {
        My_API.t_Liv最近一个时间段的数据数据(symbol:model.symbol).post(M_LivExHistory.self) { [weak self](isOk, data, error) in
            self?.sp_EndRefresh()
            if isOk {
                guard let datas = data as? [M_LivExHistory] else{return}
                self?.dataCells.value = [SectionModel(model:0,items:datas)]
                if datas.count == 0 {
                    self?._placeHolderType = .tNoData(labTitle: sp_localized("没有数据"), btnTitle:sp_localized("点击刷新"))
                }else if datas.count < my_pageSize{
                    self?.tableView?.sp_footerEndRefreshNoMoreData()
                    
                }
            }else{
                
                self?._placeHolderType = .tNetError(labTitle: error)
                
            }
        }
    }
    
    /*
    fileprivate func t_Liv获取指数所有历史数据() {
        My_API.t_Liv获取指数所有历史数据(symbol:model.symbol).post(M_LivExList.self) { [weak self](isOk, data, error) in
            if isOk {
                guard let datas = data as? [M_LivExList] else{return}
                
                
            }
        }
    }*/
    
    
}
