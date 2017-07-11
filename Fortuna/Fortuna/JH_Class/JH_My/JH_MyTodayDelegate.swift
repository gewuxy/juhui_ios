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

}
extension JH_MyTodayDelegate {
    override class func initSPVC() -> JH_MyTodayDelegate {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_MyTodayDelegate") as! JH_MyTodayDelegate
    }
    class func show(_ parentVC:UIViewController?) {
        let vc = JH_MyTodayDelegate.initSPVC()
        vc.hidesBottomBarWhenPushed = true
        parentVC?.navigationController?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeTableView()
        makeNavigation()
    }
    fileprivate func makeNavigation() {
        self.n_view._title = sp_localized(JH_MyCellType.t当日委托.rawValue)
    }
    
    fileprivate func makeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension JH_MyTodayDelegate:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
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
        cell._block = { [unowned self]_ in
            let model = JH_HUD_EntrustModel(type: .t撤销买入, no: "", name: "", price: "", num: "")
            JH_HUD_Entrust.show(model, block: {[weak self] _ in
                //SP_HUD.show(text:"模块开发中，下面是模拟")
                //self?.goBuyOrSell()
            })
        }
        return cell
    }
}

