//
//  JH_Market.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/8.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class JH_Market: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!
    
    
    

}

extension JH_Market {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavigation()
        makeUI()
    }
    fileprivate func makeNavigation() {
        n_view.n_btn_L1_Image = ""
    }
    fileprivate func makeUI() {
        tableView.delegate = self
        tableView.dataSource = self
        
    }
}
extension JH_Market:UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sp_SectionH_Foot
    }
    
}
extension JH_Market:UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SP_ComCell.show((L: "", R: ""), title: (L: "第\(section)组", R: ""))
        view.updateUI(labelL: (font: UIFont.systemFont(ofSize: 16), color: UIColor.main_string("#15cd48")),imageW: (L: 0 , R: 0))
        return view
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JH_AttentionCell_Normal.show(tableView, indexPath)
        return cell
    }
    
}
