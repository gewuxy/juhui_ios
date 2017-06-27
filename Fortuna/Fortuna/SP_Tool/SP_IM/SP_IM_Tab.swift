//
//  SP_IM_Tab.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/27.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class SP_IM_Tab: UIView {
    static func show(_ supView:UIView) -> SP_IM_Tab {
        for item in supView.subviews {
            if let sub = item as? SP_IM_Tab {
                return sub
            }
        }
        let view = (Bundle.main.loadNibNamed("SP_IM_Tab", owner: nil, options: nil)!.first as? SP_IM_Tab)!
        supView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var _numberOfSections:(()->Int)?
    var _numberOfRowsInSection:((Int)->Int)?
    var _heightForHeaderInSection:((Int)->CGFloat)?
    var _heightForFooterInSection:((Int)->CGFloat)?
    var _heightForRow:((IndexPath)->CGFloat)?
    var _cellForRowAt:((IndexPath)->UITableViewCell)?
    var _viewForHeaderInSection:((Int)->UIView)?
    var _viewForFooterInSection:((Int)->UIView)?
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
        return _heightForRow?(indexPath) ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _numberOfRowsInSection?(section) ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
