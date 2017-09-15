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
import SwiftyJSON

import YYText
import YYImage
class JH_News: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    var msgNum = 0 {
        didSet{
            lab_Msg.text = msgNum > 0 ? (msgNum > 99 ? " 99+ " : String(format:" %d ",msgNum)) : ""
        }
    }
    var _pageIndex = 1
    
    var _dataNewsS:[M_NewsS] = [] {
        didSet{
            self.tableView.cyl_reloadData()
        }
    }
    
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
        
        self.makeNavigation()
        self.makeTableView()
        self.makeSocketIO()
    }
    override func clickN_btn_L1() {
        msgNum = 0
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
            
            guard SP_User.shared.userIsLogin else {
                SP_Login.show(self) { (isOk) in
                    
                }
                return
            }
            
            switch index {
            case 0:
                SP_RichTextEdit.show(self, type:.t短评, block:{ [weak self]_ in
                    self?.t_获取短评列表()
                })
            case 1:
                SP_RichTextEdit.show(self, type:.t长文, block:{ [weak self]_ in
                    self?.t_获取短评列表()
                })
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
        lab_Msg.text = msgNum > 0 ? (msgNum > 99 ? " 99+ " : String(format:" %d ",msgNum)) : ""
        
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
    //MARK:--- SocketIO -----------------------------
    func makeSocketIO() {
        JH_Attention.socket.on(clientEvent: .connect) { (data, ack) in
            //iOS客户端上线
            //self?.socket.emit("login", self!._followData.code)
        }
        JH_Attention.socket.on("commentary") { [weak self](res, ack) in
            //接收到广播
            let json:[JSON] = JSON(res).arrayValue
            print_SP("json ==> \(json)")
            guard json.count > 0 else{return}
            let model = M_MsgSocket(json[0])
            guard model.to_id == SP_UserModel.read().userId else{return}
            switch model.type {
            case .t点赞:
                SP_HUD.showMsg(model.from_name + "为你点了一个👍")
                self?.msgNum += 1
            case .t评论:
                SP_HUD.showMsg("收到"+model.from_name+"的评论", detailText: model.commomString)
                self?.msgNum += 1
            default:break
            }
        }
        /*
         self.socket.on(clientEvent: .disconnect) { (data, ack) in
         
         }*/
        
        JH_Attention.socket.connect()
    }
}
extension JH_News {
    fileprivate func makeTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        do {
            let realm = try Realm()
            let theRealms:Results<M_NewsSRealm> = realm.objects(M_NewsSRealm.self)
            
            for item in theRealms {
                self._dataNewsS.append(item.read())
                
            }
        } catch let err {
            print(err)
        }
        
        
        self._placeHolderType = .tOnlyImage
        
        self.sp_addMJRefreshHeader()
        self.tableView.sp_headerBeginRefresh()
        
        
//        var mo1 = M_NewsS()
//        mo1.type = .t新闻
//        mo1.news = dataCells.value[0].items.first ?? M_News()
//        
//        var mo2 = M_NewsS()
//        mo2.type = .t帖子
//        mo2.content = [M_SP_RichText]()
//        
//        self._dataNewsS = [mo2,mo1]
        
        
    }
}
/*
//MARK:--- 旧 ----------
extension JH_News {
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
}*/
extension JH_News:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1//self._dataNewsS.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dataNewsS.count
//        if self._dataNewsS[section].type == .t新闻 {
//            return 1
//        }else{
//            return 3
//        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension//sp_fitSize((90, 100, 110))
        
//        if self._dataNewsS[indexPath.section].type == .t新闻 {
//            return sp_fitSize((90, 100, 110))
//        }else{
//            switch indexPath.row {
//            case 0:
//                return 60
//            case 1:
//                return 60
//            case 2:
//                return 40
//            default:
//                return 0
//            }
//        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return sp_SectionH_Min
        }else{
            return sp_SectionH_Min
        }
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JH_NewsPostCell_List.show(tableView)
        print_SP(cell.bounds.size.height)
        let model = _dataNewsS[indexPath.row]
        if model.first_img.isEmpty {
            cell.textView.preferredMaxLayoutWidth = sp_ScreenWidth-20
            cell.img_Logo.snp.updateConstraints({ (make) in
                make.width.equalTo(0)
                make.height.equalTo(0)
            })
        }else{
            cell.textView.preferredMaxLayoutWidth = sp_ScreenWidth-120
            cell.img_Logo.sp_ImageName(model.first_img)
            cell.img_Logo.snp.updateConstraints({ (make) in
                make.width.equalTo(100)
                make.height.equalTo(80)
            })
        }
        cell.lab_name.text = model.author_name
        cell.lab_comm.text = "评论:" + String(format: "%d", model.comments_count)
        let locationStr:NSMutableAttributedString = NSMutableAttributedString(string: "", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 18)])
        if !model.title.isEmpty {
            let tagText = NSMutableAttributedString(string: model.title, attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 18)])
            if model.title.hasPrefix("【转】") {
                tagText.yy_color = UIColor.main_btnNormal
                tagText.yy_setTextBinding(YYTextBinding(deleteConfirm: false), range: tagText.yy_rangeOfAll())
                let highlight = YYTextHighlight()
                highlight.tapAction = { (containerView,text,range,rect) in
                    var mo = M_NewsS()
                    mo.blog_id = model.parent_blog_id
                    My_NewsPostDetail.show(self, mo, block:{ [weak self](type) in
                        switch type {
                        case .t转发:
                            self?.t_获取短评列表()
                        default:break
                        }
                    })
                }
                tagText.yy_setTextHighlight(highlight, range: tagText.yy_rangeOfAll())
            }
            let tagText2 = NSAttributedString(string: "\n", attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 0)])
            locationStr.append(tagText)
            locationStr.append(tagText2)
        }
        for item in model.bastract {
            switch item.type {
            case M_SP_RichTextType.t文字.rawValue:
                if item.text != "\n" {
                    let tagText = NSAttributedString(string: item.text, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 16)])
                    locationStr.append(tagText)
                }
            case M_SP_RichTextType.t关注.rawValue:
                let tagText = NSMutableAttributedString(string: item.text)
                tagText.yy_font = UIFont.systemFont(ofSize: 16)
                tagText.yy_color = UIColor.main_btnNormal
                tagText.yy_setTextBinding(YYTextBinding(deleteConfirm: false), range: tagText.yy_rangeOfAll())
                let highlight = YYTextHighlight()
                highlight.tapAction = { (containerView,text,range,rect) in
                    SP_HUD.showMsg("@朋友")
                }
                tagText.yy_setTextHighlight(highlight, range: tagText.yy_rangeOfAll())
                locationStr.append(tagText)
            case M_SP_RichTextType.t自选酒.rawValue:
                let tagText = NSMutableAttributedString(string: item.text)
                tagText.yy_font = UIFont.systemFont(ofSize: 16)
                tagText.yy_color = UIColor.main_btnNormal
                tagText.yy_setTextBinding(YYTextBinding(deleteConfirm: false), range: tagText.yy_rangeOfAll())
                let highlight = YYTextHighlight()
                highlight.tapAction = { (containerView,text,range,rect) in
                    var model = M_Attention()
                    model.name = item.text
                    model.name[0 ..< 2] = ""
                    model.code = item.code
                    JH_AttentionDetails.show(self, data:model)
                }
                tagText.yy_setTextHighlight(highlight, range: tagText.yy_rangeOfAll())
                locationStr.append(tagText)
            case M_SP_RichTextType.t超链接.rawValue:
                let tagText = NSMutableAttributedString(string: item.text)
                tagText.yy_font = UIFont.systemFont(ofSize: 16)
                tagText.yy_color = UIColor.main_btnNormal
                tagText.yy_setTextBinding(YYTextBinding(deleteConfirm: false), range: tagText.yy_rangeOfAll())
                let highlight = YYTextHighlight()
                highlight.tapAction = { [weak self](containerView,text,range,rect) in
                    var mmo = M_News()
                    mmo.href = item.link
                    mmo.title = item.text
                    JH_NewsDetials.show(self,data:mmo, isHttp:true)
                }
                tagText.yy_setTextHighlight(highlight, range: tagText.yy_rangeOfAll())
                locationStr.append(tagText)
            default:
                break
            }
        }
        cell.textView.attributedText = locationStr
        
        return cell
        /*
        if self._dataNewsS[indexPath.section].type == .t新闻 {
            let cell = JH_NewsCell_List.show(tableView)
            let model = self._dataNewsS[indexPath.section].news
            cell.img_Logo.sp_ImageName(model.thumb_img)
            cell.lab_name.text = model.title
            cell.lab_time.text = model.newsYY
            cell.lab_time2.text = model.newsMM
            return cell
        }else{
            switch indexPath.row {
            case 0:
                let cell = JH_NewsCell_User.show(tableView)
                return cell
            case 1:
                let cell = JH_NewsCell_Content.show(tableView)
                return cell
            case 2:
                let cell = JH_NewsCell_Btn.show(tableView)
                return cell
            default:
                return UITableViewCell()
            }
            
        }*/
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        My_NewsPostDetail.show(self, _dataNewsS[indexPath.row], block:{ [weak self](type) in
            switch type {
            case .t关注(let follow):
                self?._dataNewsS[indexPath.row].is_concerned = follow
                var fff = M_Friends()
                fff.id = self!._dataNewsS[indexPath.row].author_id
                fff.name = self!._dataNewsS[indexPath.row].author_name
                fff.logo = self!._dataNewsS[indexPath.row].author_img
                sp_Notification.post(name: follow ? ntf_Name_朋友添加 : ntf_Name_朋友删除, object: fff)
            case .t赞:
                self?._dataNewsS[indexPath.row].likes_count += 1
            case .t评论:
                self?._dataNewsS[indexPath.row].comments_count += 1
            case .t转发:
                self?.t_获取短评列表()
            }
        })
    }
   
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        if indexPath.section == self._datas.count - 1 && indexPath.row == self._datas[indexPath.section].count - 5 && self._footRefersh {
//            self._pageIndex += 1
//            self.t_获取资讯列表()
//        }
        
    }
}

extension JH_News {
    fileprivate func sp_addMJRefreshHeader() {
        tableView?.sp_headerAddMJRefresh { [weak self]_ in
            self?._pageIndex = 1
            self?._footRefersh = true
            //self?.t_获取资讯列表()
            self?.t_获取短评列表()
        }
    }
    fileprivate func sp_addMJRefreshFooter() {
        tableView?.sp_footerAddMJRefresh_Auto { [weak self]_ in
            self?._pageIndex += 1
            //self?.t_获取资讯列表()
            self?.t_获取短评列表()
            
        }
    }
    
    fileprivate func sp_EndRefresh()  {
        tableView?.sp_headerEndRefresh()
        tableView?.sp_footerEndRefresh()
    }
    /*
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
                                let m_Realm = M_NewsRealm()
                                m_Realm.write(item, index)
                                try realm.write {
                                    //写入，根据主键更新
                                    realm.add(m_Realm, update: true)
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
    }*/
    
    fileprivate func t_获取短评列表() {
        My_API.t_获取短评列表(page:_pageIndex).post(M_NewsS.self) { [weak self](isOk, data, error) in
            self?.sp_EndRefresh()
            
            guard self != nil else{return}
            if isOk {
                guard let datas = data as? [M_NewsS] else{return}
                if self?._pageIndex == 1 {
                    
                    DispatchQueue.global().async {
                        do {
                            let realm = try Realm()
                            for (index,item) in datas.enumerated() {
                                let m_Realm = M_NewsSRealm()
                                m_Realm.write(item, index)
                                try realm.write {
                                    //写入，根据主键更新
                                    realm.add(m_Realm, update: true)
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
                        self?.msgNum = datas[0].notice_not_read
                        self?._dataNewsS = datas
                        self?.sp_addMJRefreshFooter()
                    }else{
                        self?._placeHolderType = .tNoData(labTitle: sp_localized("9011110"), btnTitle:sp_localized("点击刷新"))
                        
                    }
                }else{
                    self?._dataNewsS += datas
                    
                    if datas.count == 0 {
                        self?.tableView.sp_footerEndRefreshNoMoreData()
                        
                    }
                }
            }else{
                if self!._dataNewsS.count > 0 {
                    SP_HUD.showMsg(error)
                }else{
                    self?._placeHolderType = .tNetError(labTitle: error)
                }
            }
        }
    }
}


