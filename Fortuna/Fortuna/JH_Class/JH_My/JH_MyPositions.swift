//
//  JH_MyPositions.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/9.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class JH_MyPositions: SP_ParentVC {

    @IBOutlet weak var view_topBg: UIView!
    
    @IBOutlet weak var lab_zc: UILabel!
    @IBOutlet weak var lab_zc0: UILabel!
    @IBOutlet weak var lab_yk: UILabel!
    @IBOutlet weak var lab_yk0: UILabel!
    @IBOutlet weak var lab_sz: UILabel!
    @IBOutlet weak var lab_sz0: UILabel!
    @IBOutlet weak var lab_ck: UILabel!
    @IBOutlet weak var lab_ck0: UILabel!
    
//    @IBOutlet weak var view_topHeader: UIView!
//    @IBOutlet weak var lab_code: UILabel!
//    @IBOutlet weak var lab_yk2: UILabel!
//    @IBOutlet weak var lab_ratio: UILabel!
//    @IBOutlet weak var lab_num: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    

    var _pageIndex = 1
    var _datas = M_MyPositions()
}
extension JH_MyPositions {
    override class func initSPVC() -> JH_MyPositions {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_MyPositions") as! JH_MyPositions
    }
    class func show(_ parentVC:UIViewController?) {
        let vc = JH_MyPositions.initSPVC()
        vc.hidesBottomBarWhenPushed = true
        parentVC?.navigationController?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        makeTableView()
    }
    
    fileprivate func makeUI() {
        self.n_view._title = sp_localized(JH_MyCellType.t我的持仓.rawValue)
        self.lab_zc.textColor = UIColor.mainText_1
        self.lab_zc0.textColor = UIColor.mainText_2
        self.lab_yk.textColor = UIColor.mainText_1
        self.lab_yk0.textColor = UIColor.mainText_2
        self.lab_sz.textColor = UIColor.mainText_1
        self.lab_sz0.textColor = UIColor.mainText_2
        self.lab_ck.textColor = UIColor.mainText_1
        self.lab_ck0.textColor = UIColor.mainText_2
        
        self.lab_zc0.text = sp_localized("总资产")
        self.lab_yk0.text = sp_localized("浮动盈亏")
        self.lab_sz0.text = sp_localized("总市值")
        self.lab_ck0.text = sp_localized("当日参考盈亏")
    }
    
    fileprivate func updateUI() {
        self.lab_zc.text = "¥ "+self._datas.total_assets
        self.lab_yk.text = "¥ "+self._datas.float_profit_loss
        self.lab_sz.text = "¥ "+self._datas.total_market_value
        self.lab_ck.text = "¥ "+self._datas.current_profit_loss
    }
    
    fileprivate func makeTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.sp_addMJRefreshHeader()
        self.tableView.sp_headerBeginRefresh()
    }
    override func placeHolderViewClick() {
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
extension JH_MyPositions:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _datas.position_list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.5
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableCell(withIdentifier: "JH_MyPositionsCell") as! JH_MyPositionsCell
        view.frame.size.height = 35
        view.backgroundColor = UIColor.white
        view.isUserInteractionEnabled = false
        view.lab_code.textColor = UIColor.mainText_2
        view.lab_yk.textColor = UIColor.mainText_2
        view.lab_ratio.textColor = UIColor.mainText_2
        view.lab_num.textColor = UIColor.mainText_2
        view.lab_code.text = sp_localized("代码")
        view.lab_yk.text = sp_localized("盈亏")
        view.lab_ratio.text = sp_localized("盈亏比例")
        view.lab_num.text = sp_localized("持仓数")
        return view
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JH_MyPositionsCell.show(tableView, indexPath)
        let model = _datas.position_list[indexPath.row]
        cell.lab_num.text = model.num
        cell.lab_code.text = model.code
        cell.lab_yk.text = model.profit_loss
        cell.lab_ratio.text = model.profit_loss_ratio
        cell.lab_yk.textColor = model.profit_loss.hasPrefix("-") ? UIColor.mainText_5 : UIColor.mainText_4
        cell.lab_ratio.textColor = model.profit_loss_ratio.hasPrefix("-") ? UIColor.mainText_5 : UIColor.mainText_4
        //cell.lab_num.textAlignment = .center
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        var model = M_Attention()
        model.code = _datas.position_list[indexPath.row].code
        model.name = _datas.position_list[indexPath.row].name
        JH_AttentionDetails.show(self, data:model)
    }
}
extension JH_MyPositions {
    fileprivate func sp_addMJRefreshHeader() {
        tableView?.sp_headerAddMJRefresh { [weak self]_ in
            self?._pageIndex = 1
            self?.t_我的持仓()
        }
    }
    fileprivate func sp_addMJRefreshFooter() {
        tableView?.sp_footerAddMJRefresh_Auto { [weak self]_ in
            self?._pageIndex += 1
            self?.t_我的持仓()
            self?.tableView.cyl_reloadData()
            self?.sp_EndRefresh()
            
        }
    }
    
    fileprivate func sp_EndRefresh()  {
        tableView?.sp_headerEndRefresh()
        tableView?.sp_footerEndRefresh()
    }
    fileprivate func t_我的持仓() {
        My_API.t_我的持仓(page: _pageIndex).post(M_MyPositions.self) { [weak self](isOk, data, error) in
            self?.sp_EndRefresh()
            guard self != nil else{return}
            if isOk {
                guard let datas = data as? M_MyPositions else{return}
                if self?._pageIndex == 1 {
                    self!._datas = datas
                    if datas.position_list.count > 0 {
                        self!.sp_addMJRefreshFooter()
                    }else {
                        self?._placeHolderType = .tNoData(labTitle: sp_localized("9011110"), btnTitle:sp_localized("点击刷新"))
                    }
                }else{
                    self!._datas.total_market_value = datas.total_market_value
                    self!._datas.total_assets = datas.total_assets
                    self!._datas.float_profit_loss = datas.float_profit_loss
                    self!._datas.current_profit_loss = datas.current_profit_loss
                    self!._datas.position_list += datas.position_list
                }
                self?.updateUI()
                self?.tableView.cyl_reloadData()
            }else{
                if self!._datas.position_list.count > 0 {
                    SP_HUD.showMsg(error)
                }else{
                    self?._placeHolderType = .tNetError(labTitle: error)
                    self?.tableView.cyl_reloadData()
                }
            }
        }
    }
}


