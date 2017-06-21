//
//  JH_AttentionDetails.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/20.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class JH_AttentionDetails: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view_toolBar: UIView!
    @IBOutlet weak var btn_remove: UIButton!
    @IBOutlet weak var btn_placeOrder: UIButton!
    @IBOutlet weak var btn_chateau: UIButton!
    
    fileprivate enum sectionType:Int {
        case tData = 0
        case tCharts
    }
    lazy var _tUnfoldOpen = false
    
    @IBAction func clickToolBarBtn(_ sender: UIButton) {
        switch sender {
        case btn_placeOrder:
            JH_HUD_PlaceOrder.show({ _ in
                
            })
        default:
            break
        }
    }
}

extension JH_AttentionDetails {
    override class func initSPVC() -> JH_AttentionDetails {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_AttentionDetails") as! JH_AttentionDetails
    }
    class func show(_ parentVC:UIViewController?) {
        let vc = JH_AttentionDetails.initSPVC()
        vc.hidesBottomBarWhenPushed = true
        parentVC?.navigationController?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigation()
        makeUI()
    }
    fileprivate func makeNavigation() {
        n_view._title = "这里是详情页这里是详情页这里是详情页这里是详情页"
        n_view.n_btn_C1.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        n_view._detailTitle = "交易中"
        n_view.n_label_C1.textColor = UIColor.white.withAlphaComponent(0.3)
        n_view.n_label_C1.font = UIFont.boldSystemFont(ofSize: 12)
        n_view.n_label_C1_H.constant = 12
        n_view.n_label_C1_B.constant = 5
        n_view.n_btn_R1_Image = "Attention分享"
        n_view.n_btn_R1_R.constant = 15
        
    }
    
    fileprivate func makeUI() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}
extension JH_AttentionDetails:UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionType.tCharts.rawValue + 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case sectionType.tData.rawValue:
            return _tUnfoldOpen ? 2 : 1
        case sectionType.tCharts.rawValue:
            return 1
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sp_SectionH_Foot
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case sectionType.tData.rawValue:
            return indexPath.row == 0 ? sp_fitSize((145,160,175)) : sp_fitSize((125,140,155))
        case sectionType.tCharts.rawValue:
            return sp_fitSize((228,248,278))
        default:
            return 0
        }
    }
}
extension JH_AttentionDetails:UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case sectionType.tData.rawValue:
            if indexPath.row == 0 {
                let cell = JH_AttentionDetailsCell_Data.show(tableView, indexPath, openBlock:{ [unowned self]_ in
                    self._tUnfoldOpen = !self._tUnfoldOpen
                    self.tableView.reloadData()
                })
                cell.btn_unfold.setImage(UIImage(named: _tUnfoldOpen ? "Attention置顶" : "Attention展开"), for: .normal)
                return cell
            }else{
                let cell = JH_AttentionDetailsCell_Unfold.show(tableView, indexPath)
                
                return cell
            }
        case sectionType.tCharts.rawValue:
            let cell = JH_AttentionDetailsCell_Charts.show(tableView, indexPath)
            
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}




