//
//  JH_DealDetails.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/10.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class JH_MyDealDetails: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!
    
    var _datas:[(l:String,r:String)] {
        return[(sp_localized("红酒名称："),self._data.wine_name),
               (sp_localized("代码："),self._data.wine_code),
               (sp_localized("成交时间："),self._data.create_at),
               (sp_localized("成交价："),"¥ "+self._data.price),
               (sp_localized("成交量："),self._data.num),
               (sp_localized("成交额："),"¥ "+self._data.allprice),
               (sp_localized("支付方式："),"微信")]
    }
    var _data = M_MyDeal()
}

extension JH_MyDealDetails {
    override class func initSPVC() -> JH_MyDealDetails {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_MyDealDetails") as! JH_MyDealDetails
    }
    class func show(_ parentVC:UIViewController?, data:M_MyDeal) {
        let vc = JH_MyDealDetails.initSPVC()
        vc.hidesBottomBarWhenPushed = true
        vc._data = data
        parentVC?.navigationController?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.n_view._title = _data.wine_name
        makeTableView()
    }
    
    fileprivate func makeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension JH_MyDealDetails:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _datas.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 70 : 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JH_MyDealDetailsCell.show(tableView, indexPath)
        let model = _datas[indexPath.row]
        cell.lab_L.text = model.l
        cell.lab_R.text = model.r
        return cell
    }
}
