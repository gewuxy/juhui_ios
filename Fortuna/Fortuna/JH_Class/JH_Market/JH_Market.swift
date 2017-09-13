//
//  JH_Market.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/8.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa
import RxDataSources

class JH_Market: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<Int, Any>>()
    let dataCells = Variable([SectionModel<Int, Any>]())
    
    var _datas = M_Market()
    var _datasLiv = M_Market()

    enum sectionType:Int {
        case tLiv_ex = 0
        case t涨幅
        case t跌幅
    }
    
}

extension JH_Market {
    override class func initSPVC() -> JH_Market {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_Market") as! JH_Market
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavigation()
        makeTableView()
    }
    fileprivate func makeNavigation() {
        n_view.n_btn_L1_Image = ""
    }
    fileprivate func makeTableView() {
        if let realm = try? Realm() {
            print(realm.configuration.fileURL)
        }
        /*
        do {
            let realm = try Realm()
            if let theRealms:M_AttentionRealmS = realm.object(ofType: M_AttentionRealmS.self, forPrimaryKey: "m_MarketRealm") {
                for item in theRealms.high_ratio {
                    self._datas.high_ratio.append(item.read())
                }
                for item in theRealms.low_ratio {
                    self._datas.low_ratio.append(item.read())
                }
            }
            
        } catch let err {
            print(err)
        }*/
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self._placeHolderType = .tOnlyImage
        self.tableView.cyl_reloadData()
        self.sp_addMJRefreshHeader()
        self.tableView.sp_headerBeginRefresh()
        
        
    }
    
    override func sp_placeHolderViewClick() {
        switch self._placeHolderType {
        case .tOnlyImage:
            break
        case .tNoData(_,_):
            self.tableView.sp_headerBeginRefresh()
        case .tNetError(let lab):
            if lab == My_NetCodeError.t需要登录.stringValue {
                SP_Login.show(self)
            }else{
                self._placeHolderType = .tOnlyImage
                self.tableView.sp_headerBeginRefresh()
            }
            
        }
    }
}
extension JH_Market{
    fileprivate func makeTableViewRx() {
        dataCells.value = [
            SectionModel(model:0,items:[M_Market_Liv]()),
            SectionModel(model:1,items:[M_Attention]()),
            SectionModel(model:2,items:[M_Attention]())
        ]
        tableView.rx.setDelegate(self).addDisposableTo(disposeBag)
        
        dataSource.configureCell = { (da,tab,indexPath,mo)in
            switch mo {
            case is M_Market_Liv:
                let cell = My_MarketCell_Liv.show(tab)
                cell.contentView.backgroundColor = UIColor.main_bg
                return cell
            case is M_Attention:
                let cell = JH_AttentionCell_Normal.show(tab)
                let model = mo as! M_Attention
                cell.lab_name.text = model.name
                cell.lab_code.text = model.code
                cell.lab_price.text = model.last_price
                cell.lab_range.text = model.ratio
                cell.lab_range.textColor = indexPath.section==0 ? UIColor.mainText_4 : UIColor.mainText_5
                return cell
            default:
                return UITableViewCell()
            }
        }
        tableView.rx
            .modelSelected(M_Attention.self)
            .subscribe(onNext: { [weak self](model) in
                self?.tableView.deselectRow(at: self!.tableView.indexPathForSelectedRow!, animated: true)
                JH_AttentionDetails.show(self, data:model)
            })
            .addDisposableTo(disposeBag)
        tableView.rx.setDataSource(self).addDisposableTo(disposeBag)
        
    }
}
extension JH_Market:UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return (_datas.high_ratio.count == 0 && _datas.low_ratio.count == 0) ? 0 : 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case sectionType.t涨幅.rawValue:
            return _datas.high_ratio.count
        case sectionType.t跌幅.rawValue:
            return _datas.low_ratio.count
        default:
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case sectionType.t涨幅.rawValue:
            return _datas.high_ratio.count == 0 ? sp_SectionH_Min : 35
        case sectionType.t跌幅.rawValue:
            return _datas.low_ratio.count == 0 ? sp_SectionH_Min : 35
        default:
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case sectionType.t涨幅.rawValue:
            return _datas.high_ratio.count == 0 ? sp_SectionH_Min : 10
        case sectionType.t跌幅.rawValue:
            return _datas.low_ratio.count == 0 ? sp_SectionH_Min : 10
        default:
            return sp_SectionH_Min
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case sectionType.tLiv_ex.rawValue:
            return 100
        default:
            return sp_fitSize((70,75,80))
        }
        
    }
    
    
}
extension JH_Market:UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SP_ComCell.show((L: "", R: ""), title: (L: sp_localized(section==sectionType.t涨幅.rawValue ? "涨幅前10名" : "跌幅前10名"), R: ""))
        view.updateUI(labelL: (font: sp_fitFont18, color: section==0 ? UIColor.mainText_4 : UIColor.mainText_5),imageW: (L: 5 , R: 0))
        view.image_L.backgroundColor = section==0 ? UIColor.mainText_4 : UIColor.mainText_5
        view.image_L_H.constant = 15
        switch section {
        case sectionType.t涨幅.rawValue:
            return _datas.high_ratio.count == 0 ? nil : view
        case sectionType.t跌幅.rawValue:
            return _datas.low_ratio.count == 0 ? nil : view
        default:
            return nil
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == sectionType.tLiv_ex.rawValue {
            let cell = My_MarketCell_Liv.show(tableView)
            cell.contentView.backgroundColor = UIColor.main_bg
            return cell
        }
        let cell = JH_AttentionCell_Normal.show(tableView)
        let model = indexPath.section == sectionType.t涨幅.rawValue ? _datas.high_ratio[indexPath.row] : _datas.low_ratio[indexPath.row]
        cell.lab_name.text = model.name
        cell.lab_code.text = model.code
        cell.lab_price.text = model.last_price
        cell.lab_range.text = model.ratio
        cell.lab_range.textColor = indexPath.section==0 ? UIColor.mainText_4 : UIColor.mainText_5
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section != sectionType.tLiv_ex.rawValue {
            let model = indexPath.section == sectionType.t涨幅.rawValue ? _datas.high_ratio[indexPath.row] : _datas.low_ratio[indexPath.row]
            JH_AttentionDetails.show(self, data:model)
        }
        
    }
    
}

//MARK:--- 网络 -----------------------------
extension JH_Market {
    fileprivate func sp_addMJRefreshHeader() {
        tableView?.sp_headerAddMJRefresh { [weak self]_ in
            self?.t_获取行情数据()
            self?.t_Liv获取指数表现()
        }
    }
    
    
    fileprivate func sp_EndRefresh()  {
        tableView?.sp_headerEndRefresh()
    }
    
    fileprivate func t_获取行情数据() {
        My_API.t_获取行情数据.post(M_Market.self) { [weak self](isOk, data, error) in
            self?.sp_EndRefresh()
            
            if isOk {
                guard let datas = data as? M_Market else{return}
                /*
                DispatchQueue.global().async {
                    do {
                        let realm = try Realm()
                        let m_MarketRealm = M_AttentionRealmS()
                        m_MarketRealm.id = "m_MarketRealm"
                        m_MarketRealm.high_ratio.removeAll()
                        m_MarketRealm.low_ratio.removeAll()
                        for item in datas.high_ratio {
                            let m_AttentionRealm = M_AttentionRealm()
                            m_AttentionRealm.write(item)
                            m_MarketRealm.high_ratio.append(m_AttentionRealm)
                        }
                        for item in datas.low_ratio {
                            let m_AttentionRealm = M_AttentionRealm()
                            m_AttentionRealm.write(item)
                            m_MarketRealm.low_ratio.append(m_AttentionRealm)
                        }
                        try realm.write {
                            //写入，根据主键更新
                            realm.add(m_MarketRealm, update: true)
                        }
                        //打印出数据库地址
                        //print(realm.configuration.fileURL)
                        
                        DispatchQueue.main.async { _ in
                            
                        }
                        
                    } catch let err {
                        print(err)
                    }
                }*/
                if self?.dataCells.value.count == 0 {
                    
                }
                self?.dataCells.value = [
                    SectionModel(model:1,items:datas.high_ratio),
                    SectionModel(model:2,items:datas.low_ratio)]
                self?._datas = datas
                if datas.high_ratio.count == 0 && datas.low_ratio.count == 0 {
                    self?._placeHolderType = .tNoData(labTitle: sp_localized("9011110"), btnTitle:sp_localized("点击刷新"))
                }
                
                self?.tableView.cyl_reloadData()
            }else{
                self?._placeHolderType = .tNetError(labTitle: error)
                self?.tableView.cyl_reloadData()
            }
            
        }
    }
    fileprivate func t_Liv获取指数表现() {
        My_API.t_Liv获取指数表现.post(M_MyCommon.self) { (isOk, data, error) in
            
        }
    }
    
}


