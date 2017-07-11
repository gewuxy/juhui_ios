//
//  JH_MyPositions.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/9.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class JH_MyPositions: SP_ParentVC {

    @IBOutlet weak var view_topBg: UIView!
    
    @IBOutlet weak var lab_zc: UILabel!
    @IBOutlet weak var lab_zc0: UILabel!
    @IBOutlet weak var lab_yk: UILabel!
    @IBOutlet weak var lab_yk0: UILabel!
    @IBOutlet weak var lab_sz: UILabel!
    @IBOutlet weak var lab_sz0: UILabel!
    @IBOutlet weak var lab_ck: UILabel!
    @IBOutlet weak var lab_ck0: UILabel!
    
//    @IBOutlet weak var view_topHeader: UIView!
//    @IBOutlet weak var lab_code: UILabel!
//    @IBOutlet weak var lab_yk2: UILabel!
//    @IBOutlet weak var lab_ratio: UILabel!
//    @IBOutlet weak var lab_num: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    

}
extension JH_MyPositions {
    override class func initSPVC() -> JH_MyPositions {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_MyPositions") as! JH_MyPositions
    }
    class func show(_ parentVC:UIViewController?) {
        let vc = JH_MyPositions.initSPVC()
        vc.hidesBottomBarWhenPushed = true
        parentVC?.navigationController?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        makeTableView()
    }
    
    fileprivate func makeUI() {
        self.n_view._title = sp_localized(JH_MyCellType.t我的持仓.rawValue)
        self.lab_zc.textColor = UIColor.mainText_1
        self.lab_zc0.textColor = UIColor.mainText_2
        self.lab_yk.textColor = UIColor.mainText_1
        self.lab_yk0.textColor = UIColor.mainText_2
        self.lab_sz.textColor = UIColor.mainText_1
        self.lab_sz0.textColor = UIColor.mainText_2
        self.lab_ck.textColor = UIColor.mainText_1
        self.lab_ck0.textColor = UIColor.mainText_2
        
        self.lab_zc0.text = sp_localized("总资产")
        self.lab_yk0.text = sp_localized("浮动盈亏")
        self.lab_sz0.text = sp_localized("总市值")
        self.lab_ck0.text = sp_localized("当日参考盈亏")
        
    }
    
    fileprivate func updateUI() {
        
    }
    
    fileprivate func makeTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}
extension JH_MyPositions:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.5
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableCell(withIdentifier: "JH_MyPositionsCell") as! JH_MyPositionsCell
        view.frame.size.height = 35
        view.backgroundColor = UIColor.main_line
        view.lab_code.textColor = UIColor.mainText_2
        view.lab_yk.textColor = UIColor.mainText_2
        view.lab_ratio.textColor = UIColor.mainText_2
        view.lab_num.textColor = UIColor.mainText_2
        view.lab_code.text = sp_localized("代码")
        view.lab_yk.text = sp_localized("盈亏")
        view.lab_ratio.text = sp_localized("盈亏比例")
        view.lab_num.text = sp_localized("持仓数")
        return view
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JH_MyPositionsCell.show(tableView, indexPath)
        
        return cell
    }
}

