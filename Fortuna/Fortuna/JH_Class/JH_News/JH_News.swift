//
//  JH_News.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/8.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class JH_News: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!

    
}

extension JH_News {
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
extension JH_News:UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    
}
extension JH_News:UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JH_NewsCell_List.show(tableView, indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        JH_NewsDetials.show(self)
    }
    
}
