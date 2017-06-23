//
//  SP_UpdateVersionView.swift
//  carpark
//
//  Created by 刘才德 on 2017/2/23.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
let sp_isNewVersion = "SP_IsNewVersion"
var sp_is审核员: Bool {
    // -- 我们确保审核人员手里的APP屏蔽一些东西
    if sp_UserDefaultsBool(sp_isNewVersion) {
        return true
    }else{
        return false
    }
    
}

class SP_UpdateVersionView: UIView {
    class func show() {
        // -- 取得当前版本
        let dic:Dictionary = Bundle.main.infoDictionary!
        let thisVersion:String = (dic["CFBundleShortVersionString"] as? String)!
        print_SP("url_版本控制==>"+SP_UpdateVersionViewModel.shared.v版本号)
        if thisVersion > SP_UpdateVersionViewModel.shared.v版本号 //.compare(newVersion) == .OrderedDescending // 审核期
        {
            sp_UserDefaultsSet(sp_isNewVersion, value: true)
            sp_UserDefaultsSyn()
        }
        if thisVersion < SP_UpdateVersionViewModel.shared.v版本号 //.compare(newVersion) == .OrderedAscending // 已过审核期-更新期
        {
            sp_UserDefaultsSet(sp_isNewVersion, value: false)
            sp_UserDefaultsSyn()
            SP_UpdateVersionViewModel.shared.isUpdateShow = true
            for item in sp_MainWindow.subviews {
                if item is SP_UpdateVersionView {
                    return
                }
            }
            let subView = (Bundle.main.loadNibNamed("SP_UpdateVersionView", owner: nil, options: nil)!.first as? SP_UpdateVersionView)!
            sp_MainWindow.addSubview(subView)
            subView.snp.makeConstraints { (make) in
                make.top.bottom.leading.trailing.equalToSuperview()
            }
        }
        if thisVersion == SP_UpdateVersionViewModel.shared.v版本号 //.compare(newVersion) == .OrderedSame      // 用户
        {
            sp_UserDefaultsSet(sp_isNewVersion, value: false)
            sp_UserDefaultsSyn()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        label_Title.text = "发现新版本\nv" + SP_UpdateVersionViewModel.shared.v版本号
        //label_Title2.text = SP_UpdateVersionViewModel.shared.v更新内容
        
        //view_BG_H.constant = CGSize.xzLabelSize(label_Title.text!, font: UIFont.boldSystemFont(ofSize: 15), size:CGSize(width:240,height:0)).height + CGSize.xzLabelSize(label_Title2.text!, font: UIFont.systemFont(ofSize: 14), size:CGSize(width:240,height:0)).height + 60
        
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    var _block:(()->Void)?
    @IBOutlet weak var view_Bg: UIView!
    @IBOutlet weak var view_BG_H: NSLayoutConstraint!
    @IBOutlet weak var label_Title: UILabel!
    
    @IBOutlet weak var button_0: UIButton!
    @IBOutlet weak var button_1: UIButton!
    @IBAction func buttonClick(_ sender: UIButton) {
        switch sender {
        case button_0:
            self.removeFromSuperview()
        case button_1:
            if SP_UpdateVersionViewModel.shared.v下载链接.hasPrefix("https://") || SP_UpdateVersionViewModel.shared.v下载链接.hasPrefix("http://") {
                let url = URL(string: SP_UpdateVersionViewModel.shared.v下载链接)
                UIApplication.shared.openURL(url!)
            }
            self.removeFromSuperview()
        default:
            break
        }
    }

}




class SP_UpdateVersionViewModel {
    private static let sharedInstance = SP_UpdateVersionViewModel()
    private init() {}
    //提供静态访问方法
    open static var shared: SP_UpdateVersionViewModel {
        return self.sharedInstance
    }
    var isUpdateShow:Bool {
        set{
            let today = Date.sp_ReturnDateFormat("YYYY-MM-dd")
            sp_UserDefaultsSet("UpdateVersionTime", value: today)
            sp_UserDefaultsSyn()
        }
        get{
            let today = Date.sp_ReturnDateFormat("YYYY-MM-dd")
            let oldDay = sp_UserDefaultsGet("UpdateVersionTime") as? String ?? ""
            if today == oldDay {
                return false
            }else{
                return true
            }
            
        }
    }
    var v版本号 = ""
    var v更新内容 = ""
    var v下载链接 = ""
    func write(version:String,content:String,link:String){
        v版本号 = version
        v更新内容 = content
        v下载链接 = link
    }
}












