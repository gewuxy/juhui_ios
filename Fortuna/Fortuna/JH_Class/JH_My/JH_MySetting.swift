//
//  JH_MySetting.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/23.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class JH_MySetting: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btn_exitLogin: UIButton!
    
    enum JH_MyCellType:String {
        case t意见反馈 = "意见反馈"
        case t关于我们 = "关于我们"
        case t检查更新 = "检查更新"
    }
    lazy var _sectionsHead:[(type: JH_MyCellType,txtR: String,imgL: String,imgR: String,on_off: Bool)] = {
        return [(.t意见反馈,"","","my进入", false),
                (.t关于我们,"","","my进入",false),
                (.t检查更新,self.version,"","my进入", false)]
    }()
    
    //MARK:----------- 获取当前的版本号
    private var version: String {
        let nowVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "1.0.0"
        return sp_localized("当前版本：") + nowVersion
    }
    
    

}

extension JH_MySetting {
    override class func initSPVC() -> JH_MySetting {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_MySetting") as! JH_MySetting
    }
    class func show(_ parentVC:UIViewController?) {
        let vc = JH_MySetting.initSPVC()
        vc.hidesBottomBarWhenPushed = true
        parentVC?.navigationController?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigation()
        makeTableView()
        makeUI()
        
    }
    fileprivate func makeNavigation() {
        n_view._title = sp_localized("设置")
    }
    fileprivate func makeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    fileprivate func makeUI() {
        btn_exitLogin.isHidden = !SP_User.shared.userIsLogin
    }
    

    @IBAction func clickExitLogin(_ sender: UIButton) {
        SP_User.shared.loginOut { (isOk, error) in
            
        }
        makeUI()
    }
}

extension JH_MySetting:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_is审核员 ? 2 : 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = SP_ComCell.show((_sectionsHead[section].imgL,_sectionsHead[section].imgR), title: (sp_localized(_sectionsHead[section].type.rawValue),_sectionsHead[section].txtR), hiddenLine: false)
        headView.frame = CGRect(x: 0, y: 0, width: sp_ScreenWidth, height: 50)
        headView._tapBlock = { [unowned self]() in
            self.didSelectAt(section)
        }
        headView.updateUI(labelL:(font: SP_InfoOC.sp_fontFit(withSize: 18), color: UIColor.mainText_1), imageW:(L:_sectionsHead[section].imgL.isEmpty ? 0 : 24,R:17))
        headView.label_L_ConstrL.constant = 0
        
        return headView
    }
    func didSelectAt(_ section:Int) {
        switch _sectionsHead[section].type {
        case .t意见反馈:
            break
        case .t关于我们:
            break
        case .t检查更新:
            break
        
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
