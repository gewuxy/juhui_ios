//
//  JH_Attention.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/8.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class JH_Attention: SP_ParentVC {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lab_range_W: NSLayoutConstraint!
    
    
}

extension JH_Attention {
    override class func initSPVC() -> JH_Attention {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_Attention") as! JH_Attention
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavigation()
        makeUI()
        UIApplication.shared.statusBarStyle = .lightContent
        
        
        
        
        
        
        
    }
    fileprivate func makeNavigation() {
        
        n_view.n_btn_L1_Image = ""
        n_view.n_btn_L1_Text = "编辑"
        n_view.n_btn_R1_Image = "Attention搜索w"
        
        n_view.n_btn_L1_L.constant = 15
        n_view.n_btn_R1_R.constant = 15
        
        
    }
    
    fileprivate func makeUI() {
        tableView.delegate = self
        tableView.dataSource = self
        
        lab_range_W.constant = sp_fitSize((95,110,125))
    }
    override func clickN_btn_L1() {
        JH_AttentionEdit.show(self)
    }
    override func clickN_btn_R1() {
        JH_Search.show(self)
    }
    
}

extension JH_Attention:UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return sp_fitSize((70,75,80))
    }
}
extension JH_Attention:UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JH_AttentionCell_Normal.show(tableView, indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //JH_AttentionDetails.show(self)
        SP_HUD.show(text:"这是一条测试消息")
    }
}
