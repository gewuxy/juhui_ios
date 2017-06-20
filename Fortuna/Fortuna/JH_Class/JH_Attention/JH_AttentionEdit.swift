//
//  JH_AttentionEdit.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/13.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class JH_AttentionEdit: SP_ParentVC {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view_toolBar: UIView!
    @IBOutlet weak var btn_allSelect: UIButton!
    @IBOutlet weak var btn_remove: UIButton!
    
}

extension JH_AttentionEdit {
    override class func initSPVC() -> JH_AttentionEdit {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_AttentionEdit") as! JH_AttentionEdit
    }
    class func show(_ parentVC:UIViewController?) {
        let vc = JH_AttentionEdit.initSPVC()
        vc.hidesBottomBarWhenPushed = true
        parentVC?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavigation()
        makeUI()
    }
    fileprivate func makeNavigation() {
        
    }
    fileprivate func makeUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.setEditing(true, animated: true)
    }
}
extension JH_AttentionEdit:UITableViewDelegate {
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
extension JH_AttentionEdit:UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JH_AttentionCell_Edit.show(tableView, indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
}



