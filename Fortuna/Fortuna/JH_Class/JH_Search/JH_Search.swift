//
//  JH_Search.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/13.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import IQKeyboardManager

class JH_Search: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!

    fileprivate var _datas = [M_Attention]()
    fileprivate var _pageIndex = 1
    
    let disposeBag = DisposeBag()
    lazy var _text_search:SP_TextField = {
        let text = SP_TextField.show(self.n_view.n_view_Title)
        text.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(7)
            make.bottom.equalToSuperview().offset(-7)
        }
        text.text_field.returnKeyType = .search
        text.text_field.placeholder = "搜你喜欢"
        text.text_field.font = UIFont.systemFont(ofSize: 15)
        text.text_field.textColor = UIColor.mainText_1
        text.text_field.tintColor = UIColor.main_1
        
        text.button_L.setImage(UIImage(named:"Search搜索"), for: .normal)
        text.button_R.setImage(UIImage(named:"Search叉"), for: .normal)
        text.layer.cornerRadius = 15
        text.clipsToBounds = true
        text.backgroundColor = UIColor.white
        text.view_Line.isHidden = true
        text.button_L_W.constant = 50
        text.button_R_W.constant = 40
        text.text_field_L.constant = 0
        text.view_textBg_L.constant = 0
        return text
    }()
    
    deinit {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    
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
        makeTableView()
        makeTextDelegate()
    }
    fileprivate func makeNavigation() {
        n_view.n_btn_R1_R.constant = 15
        
        makeSearchRx()
    }
    
    fileprivate func makeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        _placeHolderType = .tOnlyImage
        tableView.cyl_reloadData()
        
        sp_addMJRefreshHeader()
        
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        self._text_search.text_field.becomeFirstResponder()
        
        
    }
    
    override func placeHolderViewClick() {
        switch _placeHolderType {
        case .tOnlyImage:
            break
        case .tNoData(_,_):
            _text_search.text_field.becomeFirstResponder()
        case .tNetError(_):
            _placeHolderType = .tOnlyImage
            self.tableView.sp_headerBeginRefresh()
        }
    }
    
    fileprivate func makeNotification() {
        sp_Notification.rx
            .notification(SP_User.shared.ntfName_成功登陆了)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](n) in
                self?.tableView.sp_headerBeginRefresh()
            }).addDisposableTo(disposeBag)
        sp_Notification.rx
            .notification(SP_User.shared.ntfName_退出登陆了)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](n) in
                self?.tableView.sp_headerBeginRefresh()
            }).addDisposableTo(disposeBag)
        sp_Notification.rx
            .notification(ntf_Name_自选删除)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](n) in
                guard self != nil else{return}
                guard let data = n.object as? M_Attention else{return}
                for (i,item) in self!._datas.enumerated() {
                    if data.code == item.code {
                        self!._datas[i] = data
                    }
                }
                self?.tableView.cyl_reloadData()
            }).addDisposableTo(disposeBag)
        
        sp_Notification.rx
            .notification(ntf_Name_自选添加)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](n) in
                guard self != nil else{return}
                guard let data = n.object as? M_Attention else{return}
                for (i,item) in self!._datas.enumerated() {
                    if data.code == item.code {
                        self!._datas[i] = data
                    }
                }
                self?.tableView.cyl_reloadData()
            }).addDisposableTo(disposeBag)
        
    }
}
extension JH_Search {
    fileprivate func makeSearchRx() {
        let phoneValid_1 = _text_search.text_field.rx.text.map { $0?.characters.count == 0 }.shareReplay(1)
        phoneValid_1
            .asObservable()
            .subscribe(onNext: { [weak self](isOk) in
                self?._text_search.button_R_W.constant = isOk ? 0 : 40
                self?._text_search.button_R.isHidden = isOk
            }).addDisposableTo(disposeBag)
        _text_search.button_R.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self](isOK) in
                self._text_search.text_field.text = ""
                self._text_search.text_field.becomeFirstResponder()
            }).addDisposableTo(disposeBag)
    }
    
    fileprivate func makeTextDelegate() {
        _text_search._shouldReturnBlock = { [weak self] (bool) in
            self?._pageIndex = 1
            self?.t_自选搜索()
            return true
        }
        _text_search._block = { [weak self] (type,text) in
            switch type {
            case .tChange:
                guard !text.isEmpty else {
                    self?._datas.removeAll()
                    self?._placeHolderType = .tOnlyImage
                    self?.tableView.cyl_reloadData()
                    return
                }
                self?._pageIndex = 1
                self?.t_自选搜索()
            default:
                break
            }
        }
    }
}
extension JH_Search:UITableViewDelegate {
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
extension JH_Search:UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JH_SearchCell_List.show(tableView, indexPath)
        let model = _datas[indexPath.row]
        cell.lab_name.text = model.name
        cell.lab_num.text = model.code
        cell.btn_select.setTitle(sp_localized(model.isFollow ? "已加自选" : "+ 自选")   , for: .normal)
        cell.btn_select.setTitleColor(model.isFollow ? UIColor.mainText_3 : UIColor.mainText_1, for: .normal)
        cell._clickBlock = { [weak self]_ in
            self?._text_search.text_field.resignFirstResponder()
            self?.t_添加或删除(indexPath.row)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self._text_search.text_field.resignFirstResponder()
        JH_AttentionDetails.show(self, data:_datas[indexPath.row])
    }
    
}

//MARK:--- 网络 -----------------------------
extension JH_Search {
    fileprivate func sp_addMJRefreshHeader() {
        tableView?.sp_headerAddMJRefresh { [weak self]_ in
            self?._pageIndex = 1
            self?.t_自选搜索()
        }
    }
    fileprivate func sp_addMJRefreshFooter() {
        tableView?.sp_footerAddMJRefresh_Auto { [weak self]_ in
            //self?.tableView.cyl_reloadData()
            self?._pageIndex += 1
            self?.t_自选搜索()
            //self?.sp_EndRefresh()
        }
    }
    
    fileprivate func sp_EndRefresh()  {
        tableView?.sp_headerEndRefresh()
        tableView?.sp_footerEndRefresh()
    }
    
    fileprivate func t_自选搜索() {
        My_API.t_自选搜索(key:_text_search.text_field.text!, page:_pageIndex).post(M_Attention.self) { [weak self](isOk, data, error) in
            self?.sp_EndRefresh()
            if isOk {
                guard let datas = data as? [M_Attention] else{return}
                
                if self?._pageIndex == 1 {
                    self?._datas = datas
                    
                    self?.sp_addMJRefreshFooter()
                    if datas.count == 0 {
                        self?._placeHolderType = .tNoData(labTitle:sp_localized("没有搜到"),btnTitle:sp_localized("搜其他的"))
                        //self?.tableView.cyl_reloadData()
                    }else if datas.count < my_pageSize{
                        self?.tableView?.sp_footerEndRefreshNoMoreData()
                        
                    }
                    
                    /*else{
                        self?.tableView.cyl_reloadData()
                        self?._pageIndex += 1
                        self?.t_自选搜索()
                    }*/
                    
                }else{
                    self?._datas += datas
                    if datas.count < my_pageSize{
                        self?.tableView?.sp_footerEndRefreshNoMoreData()
                    }else{
                        
                    }
                }
                self?.tableView.cyl_reloadData()
            }else{
                self?._placeHolderType = .tNetError(labTitle:error)
                self?.tableView.cyl_reloadData()
            }
            
        }
    }
    
    fileprivate func t_添加或删除(_ index:Int) {
        
        if !_datas[index].isFollow {
            t_添加自选数据(index)
        }else{
            UIAlertController.showAler(self, btnText: [sp_localized("取消"),sp_localized("确定")], title: sp_localized("您将删除此自选酒"), message: "", block: { [weak self](str) in
                if str == sp_localized("确定") {
                    self?.t_删除自选数据(index)
                }
            })
        }
    }
    fileprivate func t_添加自选数据(_ index:Int) {
        
        SP_HUD.show(view:self.view, type:.tLoading, text:sp_localized("+ 自选") )
        My_API.t_添加自选数据(code:_datas[index].code).post(M_Attention.self) { [weak self](isOk, data, error) in
            SP_HUD.hidden()
            if isOk {
                SP_HUD.show(text:sp_localized("已加自选"))
                self?._datas[index].isFollow = true
                sp_Notification.post(name: ntf_Name_自选添加, object: self != nil ? self!._datas[index] : nil)
                
                self?.tableView.cyl_reloadData()
            }else{
                SP_HUD.show(text:error)
            }
            
        }
    }
    
    fileprivate func t_删除自选数据(_ index:Int) {
        SP_HUD.show(view: self.view, type: .tLoading, text: sp_localized("正在删除"))
        My_API.t_删除自选数据(code:_datas[index].code).post(M_Attention.self) { [weak self](isOk, data, error) in
            SP_HUD.hidden()
            if isOk {
                SP_HUD.show(text: sp_localized("已删除"))
                self?.removeDatas(index)
            }else{
                SP_HUD.show(text:error)
            }
            
        }
    }
    fileprivate func removeDatas(_ index:Int) {
        _datas[index].isFollow = false
        sp_Notification.post(name: ntf_Name_自选删除, object: _datas[index])
        self.tableView.cyl_reloadData()
    }
}



