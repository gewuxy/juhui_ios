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
    
    lazy var _datas = M_Attention()
    
}

extension JH_AttentionDetails {
    override class func initSPVC() -> JH_AttentionDetails {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_AttentionDetails") as! JH_AttentionDetails
    }
    class func show(_ parentVC:UIViewController?, data:M_Attention) {
        let vc = JH_AttentionDetails.initSPVC()
        vc._datas = data
        vc.hidesBottomBarWhenPushed = true
        parentVC?.navigationController?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigation()
        makeUI()
        makeTableView()
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
        
        btn_remove.setTitle(sp_localized(_datas.isFollow ? "删除自选" : "+ 自选") , for: .normal)
        btn_remove.setTitleColor(_datas.isFollow ? UIColor.mainText_3 : UIColor.mainText_1, for: .normal)
        
        
    }
    fileprivate func makeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func clickN_btn_R1() {
        SP_UMView.show({ [unowned self](type) in
            SP_UMShare.shared.showDefault(self,viewType:.tCustom(platformType: type), shareTitle: "巨汇", shareText: "点击查看详情", shareImage: "http://v1.qzone.cc/pic/201306/29/10/56/51ce4cd6e7eb1111.jpg%21600x600.jpg", shareURL: "http://v1.qzone.cc/pic/201306/29/10/56/51ce4cd6e7eb1111.jpg%21600x600.jpg",  block: { (isOk) in
                
            })
        })
    }
    
    @IBAction func clickToolBarBtn(_ sender: UIButton) {
        switch sender {
        case btn_placeOrder:
            JH_HUD_PlaceOrder.show({ [unowned self]tag in
                switch tag {
                case 0:
                    JH_BuyAndSell.show(self, type: .t买入, data:self._datas)
                case 1:
                    JH_BuyAndSell.show(self, type: .t卖出, data:self._datas)
                case 2:
                    break
                default:break
                }
            })
        case btn_chateau:
            JH_IM.show(self)
        case btn_remove:
            if _datas.isFollow {
                UIAlertController.showAler(self, btnText: [sp_localized("取消"),sp_localized("确定")], title: sp_localized("您将删除此自选酒"), message: "", block: { [weak self](str) in
                    if str == sp_localized("确定") {
                        self?.t_删除自选数据()
                    }
                })
            }else{
                t_添加自选数据()
            }
        default:
            break
        }
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

//MARK:--- 网络 -----------------------------
extension JH_AttentionDetails {
    
    fileprivate func t_删除自选数据() {
        
        SP_HUD.show(view: self.view, type: .tLoading, text: sp_localized("正在删除"))
        My_API.t_删除自选数据(code:_datas.code).post(M_Attention.self) { [weak self](isOk, data, error) in
            SP_HUD.hidden()
            if isOk {
                SP_HUD.show(text: sp_localized("已删除"))
                self?.removeDatas()
            }else{
                SP_HUD.show(text:error)
            }
            
        }
    }
    fileprivate func removeDatas() {
        _datas.isFollow = false
        makeUI()
        sp_Notification.post(name: ntf_Name_自选删除, object: _datas)
        self.tableView.reloadData()
    }
    
    fileprivate func t_添加自选数据() {
        
        SP_HUD.show(view:self.view, type:.tLoading, text:sp_localized("+ 自选") )
        My_API.t_添加自选数据(code:_datas.code).post(M_Attention.self) { [weak self](isOk, data, error) in
            SP_HUD.hidden()
            if isOk {
                SP_HUD.show(text:sp_localized("已加自选"))
                self?._datas.isFollow = true
                self?.makeUI()
                sp_Notification.post(name: ntf_Name_自选添加, object: self != nil ? self!._datas : nil)
                
                self?.tableView.cyl_reloadData()
            }else{
                SP_HUD.show(text:error)
            }
            
        }
    }
    
    
}








