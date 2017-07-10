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
        return[(sp_localized("红酒名称"),""),
               (sp_localized("代码"),""),
               (sp_localized("成交时间"),""),
               (sp_localized("成交价"),""),
               (sp_localized("成交量"),""),
               (sp_localized("成交额"),""),
               (sp_localized("支付方式"),"")]
    }
}

extension JH_MyDealDetails {
    override class func initSPVC() -> JH_MyDealDetails {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_MyDealDetails") as! JH_MyDealDetails
    }
    class func show(_ parentVC:UIViewController?) {
        let vc = JH_MyDealDetails.initSPVC()
        vc.hidesBottomBarWhenPushed = true
        parentVC?.navigationController?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        return cell
    }
}
