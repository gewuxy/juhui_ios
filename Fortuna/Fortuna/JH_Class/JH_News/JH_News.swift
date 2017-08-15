//
//  JH_News.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/8.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import SafariServices
import RealmSwift

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
        
        do {
            let realm = try Realm()
            let theRealms:Results<M_NewsRealm> = realm.objects(M_NewsRealm.self)
            
            for item in theRealms {
                _datas.append(item.read())
            }
        } catch let err {
            print(err)
        }
        
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        if indexPath.section == self._datas.count - 1 && indexPath.row == self._datas[indexPath.section].count - 5 && self._footRefersh {
//            self._pageIndex += 1
//            self.t_获取资讯列表()
//        }
        
        if let cell = cell as? JH_NewsCell_List {
            let model = _datas[indexPath.row]
            cell.img_Logo.sp_ImageName(model.thumb_img)
            cell.lab_name.text = model.title
            cell.lab_time.text = model.newsYY
            cell.lab_time2.text = model.newsMM
        }
        
    }
}
extension JH_News:UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JH_NewsCell_List.show(tableView, indexPath)
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
            self?._footRefersh = true
            self?.t_获取资讯列表()
        }
    }
    fileprivate func sp_addMJRefreshFooter() {
        tableView?.sp_footerAddMJRefresh_Auto { [weak self]_ in
            self?._pageIndex += 1
            self?.t_获取资讯列表()
            
            
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
                    DispatchQueue.global().async {
                        do {
                            let realm = try Realm()
                            for (index,item) in datas.enumerated() {
                                let m_AttentionRealm = M_NewsRealm()
                                m_AttentionRealm.write(item, index)
                                try realm.write {
                                    //写入，根据主键更新
                                    realm.add(m_AttentionRealm, update: true)
                                }
                            }
                            //打印出数据库地址
                            //print(realm.configuration.fileURL)
                            
                            DispatchQueue.main.async { _ in
                                
                            }
                            
                        } catch let err {
                            print(err)
                        }
                    }
                    
                    
                    
                    self!._datas = datas
                    if datas.count > 0 {
                        self?.sp_addMJRefreshFooter()
                    }else{
                        self?._placeHolderType = .tNoData(labTitle: sp_localized("9011110"), btnTitle:sp_localized("点击刷新"))
                    }
                }else{
                    self!._datas += datas
                    if datas.count == 0 {
                        self?.tableView.sp_footerEndRefreshNoMoreData()
                    }
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


