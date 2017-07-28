//
//  JH_News.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/8.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import SafariServices
class JH_News: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!

    var _pageIndex = 1
    var _datas = [M_News]()
}

extension JH_News {
    override class func initSPVC() -> JH_News {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_News") as! JH_News
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavigation()
        makeUI()
        
        
        
        
    }
    fileprivate func makeNavigation() {
        n_view.n_btn_L1_Image = ""
    }
    fileprivate func makeUI() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self._placeHolderType = .tOnlyImage
        self.tableView.cyl_reloadData()
        self.sp_addMJRefreshHeader()
        self.tableView.sp_headerBeginRefresh()
    }
}
extension JH_News:UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _datas.count
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
        let model = _datas[indexPath.row]
        cell.img_Logo.sp_ImageName(model.thumb_img)
        cell.lab_name.text = model.title
        cell.lab_time.text = model.newsYY
        cell.lab_time2.text = model.newsMM
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        JH_NewsDetials.show(self,data:self._datas[indexPath.row])
    }
    
}

extension JH_News {
    fileprivate func sp_addMJRefreshHeader() {
        tableView?.sp_headerAddMJRefresh { [weak self]_ in
            self?._pageIndex = 1
            self?.t_获取资讯列表()
        }
    }
    fileprivate func sp_addMJRefreshFooter() {
        tableView?.sp_footerAddMJRefresh_Auto { [weak self]_ in
            self?._pageIndex += 1
            self?.t_获取资讯列表()
            self?.tableView.cyl_reloadData()
            self?.sp_EndRefresh()
            
        }
    }
    
    fileprivate func sp_EndRefresh()  {
        tableView?.sp_headerEndRefresh()
        tableView?.sp_footerEndRefresh()
    }
    fileprivate func t_获取资讯列表() {
        My_API.t_获取资讯列表(page:_pageIndex).post(M_News.self) { [weak self](isOk, data, error) in
            self?.sp_EndRefresh()
            guard self != nil else{return}
            if isOk {
                guard let datas = data as? [M_News] else{return}
                if self?._pageIndex == 1 {
                    self!._datas = datas
                    if datas.count > 0 {
                        self!.sp_addMJRefreshFooter()
                    }else {
                        self?._placeHolderType = .tNoData(labTitle: sp_localized("9011110"), btnTitle:sp_localized("点击刷新"))
                    }
                }else{
                    self!._datas += datas
                }
                self?.tableView.cyl_reloadData()
            }else{
                if self!._datas.count > 0 {
                    SP_HUD.showMsg(error)
                }else{
                    self?._placeHolderType = .tNetError(labTitle: error)
                    self?.tableView.cyl_reloadData()
                }
            }
        }
    }
}


