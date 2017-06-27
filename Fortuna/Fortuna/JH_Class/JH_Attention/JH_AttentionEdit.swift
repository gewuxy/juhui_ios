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

class JH_AttentionEdit: SP_ParentVC {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view_toolBar: UIView!
    @IBOutlet weak var btn_allSelect: UIButton!
    @IBOutlet weak var btn_remove: UIButton!
    fileprivate var _pageIndex = 1
    fileprivate var _datas = [M_Attention]()
    
    fileprivate var _allSelect = false
    enum emptyDataOpenType {
        case tOff
        case tNoData
        case tNetError(text:String)
    }
    fileprivate var _emptyDataOpen = emptyDataOpenType.tOff
    
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
        
    }
    fileprivate func makeNavigation() {
        
    }
    fileprivate func makeUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.setEditing(true, animated: true)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        
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
                code += ","+item.code
            }
        }
        guard !code.isEmpty else {
            return code
        }
        code[0..<1] = ""
        return code
    }
    
    fileprivate func removeDatas() {
        var data = [M_Attention]()
        for item in _datas {
            if !item.isSelect {
                data.append(item)
            }
        }
        _datas = data
        tableView.reloadData()
        
        sp_Notification.post(name: ntf_Name_自选删除, object: _datas)
        
        if _datas.count == 0 {
            _pageIndex = 0
            t_获取自选列表()
        }
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
            tableView.reloadData()
        case btn_remove:
            t_删除自选数据()
        default:
            break
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
        cell.btn_select.setTitle("    "+model.name, for: .normal)
        cell.btn_select.setImage(UIImage(named:model.isSelect ? "Attention选中" : "Attention没选中"), for: .normal)
        cell._block = { [weak self] type in
            switch type {
            case .tSelect:
                
                self?._datas[indexPath.row].isSelect = !model.isSelect
                
                self?.allSelect()
                
            default:
                self?._datas.remove(at: indexPath.row)
                self?._datas.insert(model, at: 0)
            }
            tableView.reloadData()
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
        
    }
}

extension JH_AttentionEdit:DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
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
            t_获取自选列表()
            
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
extension JH_AttentionEdit {
    
    fileprivate func t_获取自选列表() {
        SP_HUD.show(view: self.view, type: .tLoading, text: "加载更多")
        My_API.t_获取自选列表(pageIndex:_pageIndex,pageSize:my_pageSize).post(M_Attention.self) { [weak self](isOk, data, error) in
            SP_HUD.hidden()
            print_Json(data)
            if isOk {
                guard var datas = data as? [M_Attention] else{return}
                //datas = self!.testData()
                
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
                    self?._emptyDataOpen = emptyDataOpenType.tNoData
                }
                self?.tableView.reloadData()
                
            }else{
                SP_HUD.show(text:error)
                self?._emptyDataOpen = emptyDataOpenType.tNetError(text: error)
                self?.tableView.reloadData()
            }
            
        }
    }
    
    
    fileprivate func testData() -> [M_Attention] {
        guard _pageIndex < 5 else {
            return []
        }
        var datas = [M_Attention]()
        for i in 0 ..< 20 {
            datas.append(M_Attention(code: "\(_pageIndex)-\(i)", id: "", isDelete: false, name: "自选\(_pageIndex)-\(i)", proposedPrice: "\(_pageIndex)-\(i)", quoteChange: "\(_pageIndex)-\(i)", winery: "\(_pageIndex)-\(i)", isSelect:false))
        }
        return datas
    }
    
    
    fileprivate func t_删除自选数据() {
        
        guard !returnCode().isEmpty else {
            SP_HUD.show(text: "请选择要删除的自选酒")
            return
        }
        SP_HUD.show(view: self.view, type: .tLoading, text: "正在提交")
        My_API.t_删除自选数据(code:returnCode()).post(M_Attention.self) { [weak self](isOk, data, error) in
            SP_HUD.hidden()
            if isOk {
                SP_HUD.show(text:"已删除")
                self?.removeDatas()
            }else{
                SP_HUD.show(text:error)
            }
            
        }
    }
}





