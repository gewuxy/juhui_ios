//
//  JH_Search.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/13.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class JH_Search: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!

    lazy var _text_search:SP_TextField = {
        let text = SP_TextField.show(self.n_view.n_view_Title)
        text.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        text.text_field.placeholder = "搜你喜欢"
        text.button_L.setImage(UIImage(named:"navi_search_gray"), for: .normal)
        text.button_R.setImage(UIImage(named:"navi_search_gray"), for: .normal)
        text.layer.cornerRadius = 14
        text.clipsToBounds = true
        
        return text
    }()
}
extension JH_Search {
    override class func initSPVC() -> JH_Search {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_Search") as! JH_Search
    }
    class func show(_ parentVC:UIViewController?) {
        let vc = JH_Search.initSPVC()
        vc.hidesBottomBarWhenPushed = true
        parentVC?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavigation()
        makeUI()
        makeTextDelegate()
    }
    fileprivate func makeNavigation() {
        n_view.n_btn_R1_W.constant = 15
    }
    
    fileprivate func makeUI() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    fileprivate func makeTextDelegate() {
        
        
        _text_search._block = { [weak self] (type,text) in
            switch type {
            case .tChange:
                break
            default:
                break
            }
        }
    }
}

extension JH_Search:UITableViewDelegate {
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
extension JH_Search:UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JH_SearchCell_List.show(tableView, indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
