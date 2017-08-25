//
//  JH_MyTodayDeal.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/9.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class JH_MyTodayDeal: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!
    var _pageIndex = 1
    var _datas = [M_MyDeal]()
}
extension JH_MyTodayDeal {
    override class func initSPVC() -> JH_MyTodayDeal {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_MyTodayDeal") as! JH_MyTodayDeal
    }
    class func show(_ parentVC:UIViewController?) {
        let vc = JH_MyTodayDeal.initSPVC()
        vc.hidesBottomBarWhenPushed = true
        parentVC?.navigationController?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeTableView()
        self.makeNavigation()
    }
    fileprivate func makeNavigation() {
        self.n_view._title = sp_localized(JH_MyCellType.t当日成交.rawValue)
    }
    fileprivate func makeTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self._placeHolderType = .tOnlyImage
        self.tableView.cyl_reloadData()
        self.sp_addMJRefreshHeader()
        self.tableView.sp_headerBeginRefresh()
    }
    override func sp_placeHolderViewClick() {
        switch _placeHolderType {
        case .tOnlyImage:
            break
        case .tNoData(_,_):
            tableView.sp_headerBeginRefresh()
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

extension JH_MyTodayDeal:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _datas.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sp_fitSize((245, 260, 275))
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JH_MyTodayDealCell.show(tableView, indexPath)
        let model = _datas[indexPath.row]
        cell.lab_name.text = model.wine_name
        cell.lab_allPrice.text = "¥ "+model.allprice
        cell.lab_price.text = "¥ "+model.price
        cell.lab_num.text = model.num
        cell.lab_time.text = model.create_at
        cell._block = { [unowned self]_ in
            JH_MyDealDetails.show(self, data:model)
        }
        return cell
    }
}

extension JH_MyTodayDeal {
    fileprivate func sp_addMJRefreshHeader() {
        tableView?.sp_headerAddMJRefresh { [weak self]_ in
            self?._pageIndex = 1
            self?.t_当日成交()
        }
    }
    fileprivate func sp_addMJRefreshFooter() {
        tableView?.sp_footerAddMJRefresh_Auto { [weak self]_ in
            self?._pageIndex += 1
            self?.t_当日成交()
            
            
        }
    }
    
    fileprivate func sp_EndRefresh()  {
        tableView?.sp_headerEndRefresh()
        tableView?.sp_footerEndRefresh()
    }
    fileprivate func t_当日成交() {
        My_API.t_当日成交(page: _pageIndex).post(M_MyDeal.self) { [weak self](isOk, data, error) in
            self?.sp_EndRefresh()
            guard self != nil else{return}
            if isOk {
                guard let datas = data as? [M_MyDeal] else{return}
                if self?._pageIndex == 1 {
                    self!._datas = datas
                    if datas.count > 0 {
                        self!.sp_addMJRefreshFooter()
                    }else {
                        self?._placeHolderType = .tNoData(labTitle: sp_localized("9011110"), btnTitle:sp_localized("点击刷新"))
                    }
                }else{
                    self!._datas += datas
                }
                
                if datas.count < my_pageSize{
                    self!.tableView.sp_footerEndRefreshNoMoreData()
                }
                self?.tableView.cyl_reloadData()
            }else{
                if self!._datas.count > 0 {
                    SP_HUD.showMsg(error)
                }else{
                    self?._placeHolderType = .tNetError(labTitle: error)
                    self?.tableView.cyl_reloadData()
                }
            }
        }
    }
}

