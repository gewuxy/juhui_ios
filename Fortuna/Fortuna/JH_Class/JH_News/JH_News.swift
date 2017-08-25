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
import RxSwift
import RxCocoa
import RxDataSources
import Then
import YCXMenu

class JH_News: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<Int, M_News>>()
    
    let dataCells = Variable([SectionModel<Int, M_News>]())
    
    var _pageIndex = 1
    //var _datas = [M_News]()
    
    lazy var btn_Search:UIButton = {
        let btn = UIButton()
        self.n_view.n_view_Title.addSubview(btn)
        btn.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
            make.height.equalTo(30)
            make.left.equalToSuperview().offset(10)
        })
        btn.backgroundColor = UIColor.white
        btn.layer.cornerRadius = 15
        btn.clipsToBounds = true
        btn.setImage(UIImage(named:"Search搜索"), for: .normal)
        btn.setTitle(" "+sp_localized("搜索"), for: .normal)
        btn.setTitleColor(UIColor.mainText_2, for: .normal)
        btn.addTarget(self, action: #selector(JH_News.clickSearch(_:)), for: .touchUpInside)
        return btn
    }()
    lazy var lab_Msg:UILabel = {
        let lab = UILabel()
        self.n_view.addSubview(lab)
        lab.snp.makeConstraints({ [unowned self](make) in
            make.top.equalTo(self.n_view.n_btn_L1.snp.top)
            make.height.equalTo(12)
            make.left.equalTo(self.n_view.n_btn_L1.snp.right).offset(-10)
            
        })
        lab.backgroundColor = UIColor.red
        lab.layer.cornerRadius = 6
        lab.clipsToBounds = true
        lab.font = UIFont.systemFont(ofSize: 10)
        lab.textColor = UIColor.white
        return lab
    }()
    
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
    override func clickN_btn_L1() {
        My_MsgVC.show(self)
    }
    override func clickN_btn_R1() {
        let menuItems = [
            YCXMenuItem.init(sp_localized("短评"), image: nil, tag: 0, userInfo: ["title":"短评"]),
            YCXMenuItem.init(sp_localized("长文"), image: nil, tag: 1, userInfo: ["title":"长文"]),
            YCXMenuItem.init(sp_localized("活动"), image: nil, tag: 2, userInfo: ["title":"活动"])]
        let fromRect = CGRect(x:self.n_view.n_btn_R1.frame.origin.x+22,y:64,width:0,height:0)
        YCXMenu.setHasShadow(true)
        YCXMenu.setTintColor(UIColor.mainText_1)
        YCXMenu.setSelectedColor(UIColor.black)
        YCXMenu.show(in: self.view, from: fromRect, menuItems: menuItems) { [weak self](index, item) in
            switch index {
            case 0:
                let vc = SP_RichTextEdit()
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
            default:break
            }
        }
    }
    
    func clickSearch(_ sender:UIButton) {
        JH_Search.show(self)
    }
    
    fileprivate func makeNavigation() {
        n_view.n_btn_L1_Image = "IM展开加号"
        n_view.n_btn_R1_Image = "IM展开加号"
        btn_Search.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        lab_Msg.text = " 99 "
        
    }
    fileprivate func makeUI() {
        
        do {
            let realm = try Realm()
            let theRealms:Results<M_NewsRealm> = realm.objects(M_NewsRealm.self)
            if theRealms.count > 0 {
                dataCells.value = [SectionModel(model: 0, items: [])]
            }
            for item in theRealms {
                dataCells.value[0].items.append(item.read())
                
            }
        } catch let err {
            print(err)
        }
        
        self._placeHolderType = .tOnlyImage
        self.sp_addPlaceHolderView()
        
        self.makeTableView()
        self.sp_addMJRefreshHeader()
        self.tableView.sp_headerBeginRefresh()
        
        
    }
    
    override func sp_placeHolderViewClick() {
        switch _placeHolderType {
        case .tOnlyImage:
            break
        case .tNoData(_,_):
            self._placeHolderType = .tOnlyImage
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
extension JH_News {
    fileprivate func makeTableView() {
        
        dataCells.asObservable()
            .map { !$0.isEmpty }
            .shareReplay(1)
            .bind(to: _placeHolderView.rx.isHidden)
            .addDisposableTo(disposeBag)
        /* 用所有的 [Item] 是否为空绑定 view 是否隐藏
         dataCells.asObservable()
         .map {  $0.map { $0.items }.reduce([], +)  }
         .map { $0.isEmpty }
         .bind(to: view.rx.isHidden)
         .disposed(by: disposeBag)
         */
        
        tableView.rx.setDelegate(self).addDisposableTo(disposeBag)
        
        self.makeTableViewCell()
        
        dataCells.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        self.didSelectTableView()
    }
    fileprivate func makeTableViewCell() {
        dataSource.configureCell = { (dataSource, tab, indexPath, model) in
            let cell = JH_NewsCell_List.show(tab)
            cell.img_Logo.sp_ImageName(model.thumb_img)
            cell.lab_name.text = model.title
            cell.lab_time.text = model.newsYY
            cell.lab_time2.text = model.newsMM
            return cell
        }
    }
    
    fileprivate func didSelectTableView() {
        tableView.rx
            .modelSelected(M_News.self)
            .subscribe(onNext: { [weak self](model) in
                self?.tableView.deselectRow(at: self!.tableView.indexPathForSelectedRow!, animated: true)
                JH_NewsDetials.show(self,data:model)
            })
            .addDisposableTo(disposeBag)
    }
}
extension JH_News:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sp_fitSize((90, 100, 110))
    }
     /*
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
        
    }*/
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
                            DispatchQueue.main.async { _ in
                            }
                        } catch let err {
                            print(err)
                        }
                    }
                    //self?.dataCells.value[0].items = datas
                    //self!._datas = datas
                    if datas.count > 0 {
                        self?.dataCells.value = [SectionModel(model: self!._pageIndex-1, items: datas)]
                        self?.sp_addMJRefreshFooter()
                    }else{
                        self?._placeHolderType = .tNoData(labTitle: sp_localized("9011110"), btnTitle:sp_localized("点击刷新"))
                        
                    }
                }else{
                    self?.dataCells.value.append(SectionModel(model: self!._pageIndex-1, items: datas))
                    
                    if datas.count == 0 {
                        self?.tableView.sp_footerEndRefreshNoMoreData()
                        
                    }
                }
            }else{
                if self!.dataCells.value.count > 0 {
                    SP_HUD.showMsg(error)
                }else{
                    self?._placeHolderType = .tNetError(labTitle: error)
                }
            }
        }
    }
}


