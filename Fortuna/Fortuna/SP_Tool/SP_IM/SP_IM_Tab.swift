//
//  SP_IM_Tab.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/27.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import SwiftyJSON

enum SP_IM_TabModelType:Int {
    case tText = 0
    case tImage = 1
    case tVoice = 2
    case tVideo = 3
}
struct SP_IM_TabModel {
    
    var userMobile = ""
    var userName = ""
    var userID = ""
    var userLogo = ""
    
    var wine_name = ""
    var wine_code = ""
    
    var isMe = false
    var isLoading = false
    var isSendFailure = false
    var type = SP_IM_TabModelType.tText
    
    var content = ""
    
    var loadingImage:UIImage?
    
    
    var videoImg = ""
    
    var create_at = ""
    var isSend = false
    var timeString = ""
}

extension SP_IM_TabModel:SP_JsonModel {
    init?(_ json: JSON) {
        if json.isEmpty{
            return
        }
        type = SP_IM_TabModelType(rawValue: json["type"].intValue) ?? .tText
        userMobile = json["mobile"].stringValue
        userID = json["user_id"].stringValue
        userName = json["nickname"].stringValue
        userLogo = json["user_img_url"].stringValue
        wine_name = json["wine_name"].stringValue
        wine_code = json["wine_code"].stringValue
        
        create_at = json["create_at"].stringValue
        switch type {
        case .tText:
            content = json["content"].stringValue
        case .tImage:
            content = json["content"].stringValue
        case .tVoice:
            content = json["content"].stringValue
            videoImg = json["video_img_url"].stringValue
        case .tVideo:
            content = json["content"].stringValue
            videoImg = json["video_img_url"].stringValue
        }
        
        isMe = userID == SP_UserModel.read().userId || userMobile == SP_UserModel.read().mobile
        
        if let tim = Double(create_at) {
            timeString = Date.sp_timestampToDate(tim)
        }
    }
}

class SP_IM_Tab: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var _numberOfSections:(()->Int)?
    var _numberOfRowsInSection:((Int)->Int)?
    var _heightForHeaderInSection:((Int)->CGFloat)?
    var _heightForFooterInSection:((Int)->CGFloat)?
    var _heightForRow:((IndexPath)->CGFloat)?
    var _cellForRowAt:((UITableView,IndexPath)->UITableViewCell)?
    var _cellWillDisplay:((UITableViewCell,IndexPath)->Void)?
    
    var _viewForHeaderInSection:((Int)->UIView)?
    var _viewForFooterInSection:((Int)->UIView)?
    var _scrollViewWillBeginDragging:((UIScrollView)->Void)?
}
extension SP_IM_Tab {
    override class func initSPVC() -> SP_IM_Tab {
        return UIStoryboard(name: "SP_IM", bundle: nil).instantiateViewController(withIdentifier: "SP_IM_Tab") as! SP_IM_Tab
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeTableView()
    }
    
    func makeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
}


extension SP_IM_Tab:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
         return _numberOfSections?() ?? 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return _heightForHeaderInSection?(section) ?? 0.0001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return _heightForFooterInSection?(section) ?? 0.0001
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return _viewForHeaderInSection?(section) ?? nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return _viewForFooterInSection?(section) ?? nil
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return _heightForRow?(indexPath) ?? UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _numberOfRowsInSection?(section) ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return _cellForRowAt?(tableView,indexPath) ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        _cellWillDisplay?(cell,indexPath)
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        _scrollViewWillBeginDragging?(scrollView)
    }
}

