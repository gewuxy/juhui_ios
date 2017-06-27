//
//  JH_Attention.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/8.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import RxCocoa
import RxSwift


class JH_Attention: SP_ParentVC {

    let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lab_range_W: NSLayoutConstraint!
    fileprivate var _pageIndex = 1
    fileprivate var _datas = [M_Attention]()
    
    enum emptyDataOpenType {
        case tOff
        case tNoData
        case tNetError(text:String)
    }
    fileprivate var _emptyDataOpen = emptyDataOpenType.tOff
}


extension JH_Attention {
    override class func initSPVC() -> JH_Attention {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_Attention") as! JH_Attention
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavigation()
        makeUI()
        makeRx()
        sp_addMJRefreshHeader()
        tableView.sp_headerBeginRefresh()
        
    }
    fileprivate func makeNavigation() {
        
        n_view.n_btn_L1_Image = ""
        n_view.n_btn_L1_Text = sp_localized("编辑")
        n_view.n_btn_R1_Image = "Attention搜索w"
        
        n_view.n_btn_L1_L.constant = 15
        n_view.n_btn_R1_R.constant = 15
        
    }
    
    fileprivate func makeUI() {
        lab_range_W.constant = sp_fitSize((95,110,125))
        
        makeTableView()
    }
    func makeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
    }
    
    fileprivate func makeRx() {
        sp_Notification.rx
            .notification(ntf_Name_自选删除)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](n) in
                guard let data = n.object as? [M_Attention] else{return}
                self?._datas = data
                self?.tableView.reloadData()
                if self?._datas.count == 0 {
                    self?.tableView.sp_headerBeginRefresh()
                }
            }).addDisposableTo(disposeBag)
    }
    
    
    
    override func clickN_btn_L1() {
        guard _datas.count > 0 else {
            UIAlertController.showAler(self, btnText: ["取消","去添加"], title: "您还没有自选酒", block: { (text) in
                if text == "去添加" {
                    self.navigationController?.tabBarController?.selectedIndex = 2
                }
            })
            return
        }
        JH_AttentionEdit.show(self, datas:_datas, pageIndex:_pageIndex)
    }
    override func clickN_btn_R1() {
        JH_Search.show(self)
    }
    
}

extension JH_Attention:UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _datas.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return sp_fitSize((70,75,80))
    }
}
extension JH_Attention:UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JH_AttentionCell_Normal.show(tableView, indexPath)
        let model = _datas[indexPath.row]
        cell.lab_name.text = model.name
        cell.lab_code.text = model.code
        cell.lab_price.text = model.proposedPrice
        cell.lab_range.text = model.quoteChange
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //JH_AttentionDetails.show(self)
        SP_HUD.show(text:"这是一条测试消息")
    }
    
    
}

extension JH_Attention:DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let attributes = [NSFontAttributeName:sp_fitFont20,
                          NSForegroundColorAttributeName:UIColor.mainText_3]
        switch _emptyDataOpen {
        case .tOff:
            return NSAttributedString(string: "", attributes: attributes)
        case .tNoData:
            return NSAttributedString(string:  sp_localized("还没有自选酒"), attributes: attributes)
        case .tNetError(let text):
            return NSAttributedString(string:  text, attributes: attributes)
        }
        
    }
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        
        let attributes = [NSFontAttributeName:sp_fitFont20,
                          NSForegroundColorAttributeName:UIColor.main_1]
        switch _emptyDataOpen {
        case .tOff:
            return NSAttributedString(string: "", attributes: attributes)
        case .tNoData:
            return NSAttributedString(string:  sp_localized("点击添加"), attributes: attributes)
        case .tNetError(_):
            return NSAttributedString(string:  sp_localized("点击刷新"), attributes: attributes)
        }
        
    }
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "Attention杯子")
    }
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        switch _emptyDataOpen {
        case .tOff:
            break
        case .tNoData:
            self.navigationController?.tabBarController?.selectedIndex = 2
        case .tNetError(_):
            tableView.sp_headerBeginRefresh()
            
        }
        
        
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
}


//MARK:--- 网络 -----------------------------
extension JH_Attention {
    fileprivate func sp_addMJRefreshHeader() {
        tableView?.sp_headerAddMJRefresh { [weak self]_ in
            self?._pageIndex = 1
            self?.t_获取自选列表()
        }
    }
    fileprivate func sp_addMJRefreshFooter() {
        tableView?.sp_footerAddMJRefresh_Auto { [weak self]_ in
            self?.tableView.reloadData()
            self?._pageIndex += 1
            self?.t_获取自选列表()
            
        }
    }
    
    fileprivate func sp_EndRefresh()  {
        tableView?.sp_headerEndRefresh()
        tableView?.sp_footerEndRefresh()
    }
    
    fileprivate func t_获取自选列表() {
        My_API.t_获取自选列表(pageIndex:_pageIndex,pageSize:my_pageSize).post(M_Attention.self) { [weak self](isOk, data, error) in
            self?.sp_EndRefresh()
            print_Json(data)
            if isOk {
                guard var datas = data as? [M_Attention] else{return}
                //datas = self!.testData()
                if self?._pageIndex == 1 {
                    self?._datas = datas
                    
                    if datas.count == 0 {
                        self?._emptyDataOpen = emptyDataOpenType.tNoData
                        self?.tableView.reloadData()
                    }else if datas.count < 20{
                        self?.tableView?.sp_footerResetNoMoreData()
                        self?.tableView.reloadData()
                    }else{
                        self?.sp_addMJRefreshFooter()
                        self?.tableView.reloadData()
                        self?._pageIndex += 1
                        self?.t_获取自选列表()
                    }
                    
                }else{
                    self?._datas += datas
                    
                    if datas.count < 20{
                        self?.tableView?.sp_footerEndRefreshNoMoreData()
                    }else{
                        self?.sp_addMJRefreshFooter()
                    }
                }
            }else{
                self?._emptyDataOpen = emptyDataOpenType.tNetError(text: error)
                self?.tableView.reloadData()
            }
            
        }
    }
    
    
    fileprivate func testData() -> [M_Attention] {
        guard _pageIndex < 3 else {
            return []
        }
        var datas = [M_Attention]()
        for i in 0 ..< 20 {
            datas.append(M_Attention(code: "\(_pageIndex)-\(i)", id: "", isDelete: false, name: "自选\(_pageIndex)-\(i)", proposedPrice: "\(_pageIndex)-\(i)", quoteChange: "\(_pageIndex)-\(i)", winery: "\(_pageIndex)-\(i)", isSelect:false))
        }
        return datas
    }
}

