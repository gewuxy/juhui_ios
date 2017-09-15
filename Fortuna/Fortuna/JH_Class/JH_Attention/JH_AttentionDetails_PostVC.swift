//
//  JH_AttentionDetails_PostVC.swift
//  Fortuna
//
//  Created by LCD on 2017/9/12.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import YYText

class JH_AttentionDetails_PostVC: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!
    var _pageIndex = 1
    
    var _dataNewsS:[M_NewsS] = [] {
        didSet{
            self.tableView.cyl_reloadData()
        }
    }
    var _code = ""
}

extension JH_AttentionDetails_PostVC {
    override class func initSPVC() -> JH_AttentionDetails_PostVC {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_AttentionDetails_PostVC") as! JH_AttentionDetails_PostVC
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeTableView()
        
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
    func makeTableView() {
        self.n_view.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        self._placeHolderType = .tOnlyImage
        self.tableView.cyl_reloadData()
        self.sp_addMJRefreshHeader()
        self.tableView.sp_headerBeginRefresh()
    }
    
}

extension JH_AttentionDetails_PostVC:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dataNewsS.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
            let tagText = NSAttributedString(string: model.title, attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 18)])
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
                highlight.tapAction = { (containerView,text,range,rect) in
                    SP_HUD.showMsg("点击了超链接")
                }
                tagText.yy_setTextHighlight(highlight, range: tagText.yy_rangeOfAll())
                locationStr.append(tagText)
            default:
                break
            }
            
        }
        cell.textView.attributedText = locationStr
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self._dataNewsS[indexPath.section].type == .t新闻 {
            
            
            My_NewsPostDetail.show(self, _dataNewsS[indexPath.row], block:{ [weak self](type) in
                switch type {
                case .t关注(let follow):
                    self?._dataNewsS[indexPath.section].is_concerned = follow
                    var fff = M_Friends()
                    fff.id = self!._dataNewsS[indexPath.section].author_id
                    fff.name = self!._dataNewsS[indexPath.section].author_name
                    fff.logo = self!._dataNewsS[indexPath.section].author_img
                    sp_Notification.post(name: follow ? ntf_Name_朋友添加 : ntf_Name_朋友删除, object: fff)
                case .t赞:
                    self?._dataNewsS[indexPath.section].likes_count += 1
                case .t评论:
                    self?._dataNewsS[indexPath.section].comments_count += 1
                case .t转发:
                    self?.t_获取短评列表()
                }
            })
        }else{
            My_NewsPostDetail.show(self, _dataNewsS[indexPath.row])
        }
    }
    
    
}

extension JH_AttentionDetails_PostVC {
    fileprivate func sp_addMJRefreshHeader() {
        tableView?.sp_headerAddMJRefresh { [weak self]_ in
            self?._pageIndex = 1
            self?._footRefersh = true
            
            self?.t_获取短评列表()
        }
    }
    fileprivate func sp_addMJRefreshFooter() {
        tableView?.sp_footerAddMJRefresh_Auto { [weak self]_ in
            self?._pageIndex += 1
            
            self?.t_获取短评列表()
            
        }
    }
    
    fileprivate func sp_EndRefresh()  {
        tableView?.sp_headerEndRefresh()
        tableView?.sp_footerEndRefresh()
    }
    
    fileprivate func t_获取短评列表() {
        print_SP(_code)
        My_API.t_获取葡萄酒相关短评列表(code:_code,page:_pageIndex).post(M_NewsS.self) { [weak self](isOk, data, error) in
            self?.sp_EndRefresh()
            
            guard self != nil else{return}
            if isOk {
                guard let datas = data as? [M_NewsS] else{return}
                if self?._pageIndex == 1 {
                    
                    if datas.count > 0 {
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



