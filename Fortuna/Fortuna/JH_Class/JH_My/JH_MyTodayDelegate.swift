//
//  JH_MyTodayDelegate.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/9.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class JH_MyTodayDelegate: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!
    var _pageIndex = 1
    var _datas = [M_MyDelegate]()
    
    enum historyDelegateType {
        case t当日委托列表
        case t单品委托列表(datas:[M_MyDelegate], title:String)
    }
    var _dType = historyDelegateType.t当日委托列表
}
extension JH_MyTodayDelegate {
    override class func initSPVC() -> JH_MyTodayDelegate {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_MyTodayDelegate") as! JH_MyTodayDelegate
    }
    class func show(_ parentVC:UIViewController?, dType:historyDelegateType) {
        let vc = JH_MyTodayDelegate.initSPVC()
        vc._dType = dType
        vc.hidesBottomBarWhenPushed = true
        parentVC?.navigationController?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeNavigation()
        self.makeTableView()
    }
    fileprivate func makeNavigation() {
        self.n_view._title = sp_localized(JH_MyCellType.t当日委托.rawValue)
    }
    
    fileprivate func makeTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self._placeHolderType = .tOnlyImage
        self.tableView.cyl_reloadData()
        switch _dType {
        case .t当日委托列表:
            self.sp_addMJRefreshHeader()
            self.tableView.sp_headerBeginRefresh()
        case .t单品委托列表(let datas, let title):
            self.n_view._title = title
            self.t_单品委托列表(datas)
            
        }
        
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

extension JH_MyTodayDelegate:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _datas.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sp_fitSize((200, 215, 230))
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JH_MyTodayDelegateCell.show(tableView, indexPath)
        let model = _datas[indexPath.row]
        cell.lab_name.text = model.wine_name
        cell.lab_time.text = model.create_at
        cell.lab_num.text = model.num
        cell.lab_price.text = "¥ "+model.price
        cell.lab_status.text = model.statusStr
        if model.status == .t可撤销 {
            cell.btn_look.isEnabled = true
            cell.btn_look.setTitleColor(UIColor.mainText_1, for: .normal)
            cell.btn_look.setTitle(sp_localized("点击撤单"), for: .normal)
            cell.img_jr.isHidden = false
        }else{
            cell.img_jr.isHidden = true
            cell.btn_look.isEnabled = false
            cell.btn_look.setTitleColor(UIColor.mainText_2, for: .normal)
            cell.btn_look.setTitle(sp_localized(model.statusStr), for: .normal)
        }
        cell._block = { [unowned self]_ in
            let models = JH_HUD_EntrustModel(type: .t撤销买入, no: model.wine_code, name: model.wine_name, price: model.price, num: model.num)
            JH_HUD_Entrust.show(models, block: {[weak self] _ in
                self?.t_撤销委托单(model.id, row: indexPath.row)
            })
        }
        return cell
    }
}

extension JH_MyTodayDelegate {
    fileprivate func sp_addMJRefreshHeader() {
        tableView?.sp_headerAddMJRefresh { [weak self]_ in
            self?._pageIndex = 1
            self?.t_当日委托()
        }
    }
    fileprivate func sp_addMJRefreshFooter() {
        tableView?.sp_footerAddMJRefresh_Auto { [weak self]_ in
            self?._pageIndex += 1
            self?.t_当日委托()
            
            
        }
    }
    
    fileprivate func sp_EndRefresh()  {
        tableView?.sp_headerEndRefresh()
        tableView?.sp_footerEndRefresh()
    }
    fileprivate func t_单品委托列表(_ datas:[M_MyDelegate]) {
        self._datas = datas
        self.tableView.cyl_reloadData()
    }
    fileprivate func t_当日委托() {
        My_API.t_当日委托(page: _pageIndex).post(M_MyDelegate.self) { [weak self](isOk, data, error) in
            self?.sp_EndRefresh()
            guard self != nil else{return}
            if isOk {
                guard let datas = data as? [M_MyDelegate] else{return}
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
    
    fileprivate func t_撤销委托单(_ commission_id:String, row:Int) {
        //print_SP(commission_id)
        My_API.t_撤销委托单(commission_id: commission_id).post(M_MyCommon.self) { [weak self](isOk, data, error) in
            if isOk {
                SP_HUD.showMsg(sp_localized("已撤销"))
                self?._datas[row].status = .t已撤销
                self?.tableView.cyl_reloadData()
                sp_Notification.post(name: ntf_Name_撤销委托, object: nil)
                
            }else{
                SP_HUD.showMsg(error)
            }
        }
    }
}

