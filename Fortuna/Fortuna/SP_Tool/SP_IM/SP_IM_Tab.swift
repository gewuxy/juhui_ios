//
//  SP_IM_Tab.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/27.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class SP_IM_Tab: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var _numberOfSections:(()->Int)?
    var _numberOfRowsInSection:((Int)->Int)?
    var _heightForHeaderInSection:((Int)->CGFloat)?
    var _heightForFooterInSection:((Int)->CGFloat)?
    var _heightForRow:((IndexPath)->CGFloat)?
    var _cellForRowAt:((UITableView,IndexPath)->UITableViewCell)?
    var _viewForHeaderInSection:((Int)->UIView)?
    var _viewForFooterInSection:((Int)->UIView)?
}
extension SP_IM_Tab {
    override class func initSPVC() -> SP_IM_Tab {
        return UIStoryboard(name: "SP_IM", bundle: nil).instantiateViewController(withIdentifier: "SP_IM_Tab") as! SP_IM_Tab
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeTableView()
    }
    
    func makeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
}


extension SP_IM_Tab:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
         return _numberOfSections?() ?? 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return _heightForHeaderInSection?(section) ?? 0.0001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return _heightForFooterInSection?(section) ?? 0.0001
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return _viewForHeaderInSection?(section) ?? nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return _viewForFooterInSection?(section) ?? nil
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return _heightForRow?(indexPath) ?? UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _numberOfRowsInSection?(section) ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return _cellForRowAt?(tableView,indexPath) ?? UITableViewCell()
    }
}

