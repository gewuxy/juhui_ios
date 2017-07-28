//
//  JH_AttentionEdit.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/13.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import RxCocoa
import RxSwift
import CYLTableViewPlaceHolder

class JH_AttentionEdit: SP_ParentVC {
    
    let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view_toolBar: UIView!
    @IBOutlet weak var btn_allSelect: UIButton!
    @IBOutlet weak var btn_remove: UIButton!
    fileprivate var _pageIndex = 1
    fileprivate var _datas = [M_Attention]()
    
    fileprivate var _allSelect = false
    
}

extension JH_AttentionEdit {
    override class func initSPVC() -> JH_AttentionEdit {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_AttentionEdit") as! JH_AttentionEdit
    }
    class func show(_ parentVC:UIViewController?,datas:[M_Attention], pageIndex:Int) {
        let vc = JH_AttentionEdit.initSPVC()
        vc._datas = datas
        vc._pageIndex = pageIndex
        vc.hidesBottomBarWhenPushed = true
        parentVC?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavigation()
        makeUI()
        makeRx()
    }
    fileprivate func makeNavigation() {
        
    }
    fileprivate func makeUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.setEditing(true, animated: true)
        
        //tableView.emptyDataSetDelegate = self
        //tableView.emptyDataSetSource = self
        
    }
    fileprivate func makeRx() {
        sp_Notification.rx
            .notification(ntf_Name_自选添加)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](n) in
                guard let data = n.object as? M_Attention else{
                    self?._pageIndex = 1
                    self?.t_获取自选列表()
                    return
                }
                self?._datas.insert(data, at: 0)
                self?.tableView.cyl_reloadData()
                if self?._datas.count == 0 {
                    self?._pageIndex = 1
                    self?.t_获取自选列表()
                }
            }).addDisposableTo(disposeBag)
    }
    fileprivate func allSelect() {
        _allSelect = true
        for item in _datas {
            if !item.isSelect {
                _allSelect = false
            }
        }
        
    }
    fileprivate func returnCode() ->String {
        var code = ""
        for item in _datas {
            if item.isSelect {
                code += ";"+item.code
            }
        }
        guard !code.isEmpty else {
            return code
        }
        code[0..<1] = ""
        print_Json(code)
        return code
    }
    
    fileprivate func removeDatas() {
        _allSelect = false
        var data = [M_Attention]()
        for item in _datas {
            if !item.isSelect {
                data.append(item)
            }
        }
        _datas = data
        tableView.cyl_reloadData()
        
        sp_Notification.post(name: ntf_Name_自选删除, object: _datas)
        
        if _datas.count == 0 {
            _pageIndex = 1
            t_获取自选列表()
        }
    }
    
    fileprivate func sortDatas(_ from:Int, _ to:Int) {
        let model = _datas[from]
        self._datas.remove(at: from)
        self._datas.insert(model, at: to)
        self.tableView.cyl_reloadData()
        sp_Notification.post(name: ntf_Name_自选排序, object: _datas)
    }
    
    @IBAction func clickButton(_ sender: UIButton) {
        switch sender {
        case btn_allSelect:
            _allSelect = !_allSelect
            var data = [M_Attention]()
            for var item in _datas {
                //var it = item
                item.isSelect = _allSelect
                data.append(item)
            }
            _datas = data
            tableView.cyl_reloadData()
        case btn_remove:
            guard !returnCode().isEmpty else {
                SP_HUD.show(text: sp_localized("请选择要删除的自选酒"))
                return
            }
            UIAlertController.showAler(self, btnText: [sp_localized("取消") ,sp_localized("删除")], title: sp_localized("您将删除所选自选酒"), block: { [weak self](text) in
                if text == sp_localized("删除") {
                    self?.t_删除自选数据()
                    
                }
            })
            
        default:
            break
        }
    }
    
    override func placeHolderViewClick() {
        switch _placeHolderType {
        case .tOnlyImage:
            break
        case .tNoData(_,_):
            JH_Search.show(self)
            //self.navigationController?.tabBarController?.selectedIndex = 2
        case .tNetError(_):
            _placeHolderType = .tOnlyImage
            t_获取自选列表()
        }
    }
}
extension JH_AttentionEdit:UITableViewDelegate {
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



extension JH_AttentionEdit:UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JH_AttentionCell_Edit.show(tableView, indexPath)
        let model = _datas[indexPath.row]
        //cell.lab_name.text = model.name
        cell.btn_tap.setImage(UIImage(named:model.isSelect ? "Attention选中" : "Attention没选中"), for: .normal)
        cell.btn_tap.setTitle(" "+model.name, for: .normal)
        cell._block = { [weak self] type in
            switch type {
            case .tSelect:
                
                self?._datas[indexPath.row].isSelect = !model.isSelect
                
                self?.allSelect()
            case .tToTop:
                self?.t_自选数据排序(indexPath.row,0)
                
            }
            tableView.cyl_reloadData()
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        print("\(sourceIndexPath.row) ==> \(destinationIndexPath.row)")
        
        t_自选数据排序(sourceIndexPath.row,destinationIndexPath.row)
    }
    
    
    
}




//MARK:--- 网络 -----------------------------
extension JH_AttentionEdit {
    
    fileprivate func t_获取自选列表() {
        SP_HUD.show(view: self.view, type: .tLoading, text: sp_localized("加载更多"))
        My_API.t_获取自选列表(page:_pageIndex).post(M_Attention.self) { [weak self](isOk, data, error) in
            SP_HUD.hidden()
            print_Json(data)
            if isOk {
                guard var datas = data as? [M_Attention] else{return}
                
                if self?._allSelect == true {
                    var data = [M_Attention]()
                    for var item in datas {
                        //var it = item
                        item.isSelect = true
                        data.append(item)
                    }
                    datas = data
                }
                self?._datas = datas
                if datas.count == 0 {
                    self?._placeHolderType = .tNoData(labTitle: sp_localized("还没有自选酒"), btnTitle:sp_localized("点击添加"))
                }
                self?.tableView.cyl_reloadData()
                
            }else{
                SP_HUD.show(text:error)
                self?._placeHolderType = .tNetError(labTitle: error)
                self?.tableView.cyl_reloadData()
            }
            
        }
    }
    
    fileprivate func t_删除自选数据() {
        
        guard !returnCode().isEmpty else {
            SP_HUD.show(text: sp_localized("请选择要删除的自选酒"))
            return
        }
        print_SP(returnCode())
        SP_HUD.show(view: self.view, type: .tLoading, text: sp_localized("正在删除"))
        My_API.t_删除自选数据(code:returnCode()).post(M_Attention.self) { [weak self](isOk, data, error) in
            SP_HUD.hidden()
            if isOk {
                SP_HUD.show(text:sp_localized("已删除"))
                self?.removeDatas()
            }else{
                SP_HUD.show(text:error)
            }
            
        }
    }
    
    fileprivate func t_自选数据排序(_ from:Int, _ to:Int) {
        My_API.t_自选数据排序(code:_datas[from].code, sort_no: String(format: "%d", to)).post(M_Attention.self) { [weak self](isOk, data, error) in
            if isOk {
                self?.sortDatas(from,to)
            }else{
                SP_HUD.show(text:error)
                self?.tableView?.cyl_reloadData()
            }
            
        }
    }
}





