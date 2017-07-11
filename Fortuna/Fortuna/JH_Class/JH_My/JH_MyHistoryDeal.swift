//
//  JH_MyHistoryDeal.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/9.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class JH_MyHistoryDeal: SP_ParentVC {

   @IBOutlet weak var tableView: UITableView!

}
extension JH_MyHistoryDeal {
    override class func initSPVC() -> JH_MyHistoryDeal {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_MyHistoryDeal") as! JH_MyHistoryDeal
    }
    class func show(_ parentVC:UIViewController?) {
        let vc = JH_MyHistoryDeal.initSPVC()
        vc.hidesBottomBarWhenPushed = true
        parentVC?.navigationController?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeTableView()
        makeNavigation()
    }
    fileprivate func makeNavigation() {
        self.n_view._title = sp_localized(JH_MyCellType.t历史成交.rawValue)
    }
    
    fileprivate func makeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension JH_MyHistoryDeal:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sp_fitSize((220, 235, 250))
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JH_MyHistoryDealCell.show(tableView, indexPath)
        cell._block = { [unowned self]_ in
            JH_MyDealDetails.show(self)
        }
        return cell
    }
}





