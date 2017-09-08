//
//  My_NewsPostDetail.swift
//  Fortuna
//
//  Created by LCD on 2017/9/4.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import YYText
import YYImage

class My_NewsPostDetail: SP_ParentVC {

    @IBOutlet weak var view_bottom: UIView!
    @IBOutlet weak var view_bo_line: UIView!
    @IBOutlet weak var btn_Zhanfa: UIButton!
    @IBOutlet weak var btn_Comm: UIButton!
    @IBOutlet weak var btn_Zan: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    var _dataNewsS:M_NewsS = M_NewsS()
    
    var _images = [String]()
    var _locations = [Int]()
    enum blockType {
        case t关注(follow:Bool)
        case t评论
        case t赞
        case t转发
    }
    var _vcBlock:((blockType)->Void)?
    
    @IBAction func bottomBtnClick(_ sender: UIButton) {
        switch sender {
        case btn_Zhanfa:
             SP_RichTextEdit.show(self, type:.t转发)
        case btn_Comm:
             SP_RichTextEdit.show(self, type:.t评论)
        case btn_Zan:
            self.t_短评点赞()
        default:
            break
        }
    }
    
}

extension My_NewsPostDetail {
    override class func initSPVC() -> My_NewsPostDetail {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "My_NewsPostDetail") as! My_NewsPostDetail
    }
    class func show(_ pvc:UIViewController, _ model:M_NewsS, block:((blockType)->Void)? = nil) {
        let vc = My_NewsPostDetail.initSPVC()
        vc._dataNewsS = model
        vc._vcBlock = block
        vc.hidesBottomBarWhenPushed = true
        pvc.navigationController?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.n_view._title = _dataNewsS.title
        makeTableView()
        
    }
    
    func makeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}
extension My_NewsPostDetail:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }else{
            return 2
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return 60
            case 1:
                return UITableViewAutomaticDimension
            default:
                return UITableViewAutomaticDimension
            }
        }else{
            return UITableViewAutomaticDimension
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return sp_SectionH_Min
        }else{
            return sp_SectionH_Foot
        }
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                //MARK:--- JH_NewsCell_User ----------
                let cell = JH_NewsCell_User.show(tableView)
                cell.btn_Logo.sp_ImageName(_dataNewsS.author_img)
                cell.lab_name.text = _dataNewsS.author_name
                cell.lab_time.text = _dataNewsS.create_time
                cell.btn_follow.setTitle(_dataNewsS.is_concerned ? sp_localized(" + 关注 ") : sp_localized(" 取消关注 ") , for: .normal)
                cell.view_line.isHidden = true
                cell._clickBtn = { [unowned self](type) in
                    switch type {
                    case .logo:
                        SP_PhotoBrowser.show(self, images: [self._dataNewsS.author_img], index: 0)
                    case .follow:
                        self.t_添加朋友关注()
                    }
                    
                }
                return cell
            }else{
                //MARK:--- JH_NewsCell_Content ----------
                let cell = JH_NewsCell_Content.show(tableView)
                _images.removeAll()
                _locations.removeAll()
                let locationStr:NSMutableAttributedString = NSMutableAttributedString(string: "", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 18)])
                if !_dataNewsS.title.isEmpty {
                    let tagText = NSAttributedString(string: _dataNewsS.title, attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 22)])
                    let tagText2 = NSAttributedString(string: "\n", attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 0)])
                    locationStr.append(tagText)
                    locationStr.append(tagText2)
                }
                for item in _dataNewsS.content {
                    switch item.type {
                    case M_SP_RichTextType.t文字.rawValue:
                        var attributes:[String:Any] = [NSFontAttributeName:UIFont.systemFont(ofSize: item.fontPt)]
                        if item.isBold {
                           attributes = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: item.fontPt)]
                        }
                        let tagText = NSAttributedString(string: item.text, attributes: attributes)
                        locationStr.append(tagText)
                    case M_SP_RichTextType.t关注.rawValue:
                        print_SP(item)
                        let tagText = NSMutableAttributedString(string: item.text)
                        tagText.yy_font = UIFont.systemFont(ofSize: 18)
                        tagText.yy_color = UIColor.main_btnNormal
                        tagText.yy_setTextBinding(YYTextBinding(deleteConfirm: true), range: tagText.yy_rangeOfAll())
                        let highlight = YYTextHighlight()
                        highlight.tapAction = { (containerView,text,range,rect) in
                            SP_HUD.showMsg("@朋友")
                        }
                        tagText.yy_setTextHighlight(highlight, range: tagText.yy_rangeOfAll())
                        locationStr.append(tagText)
                    case M_SP_RichTextType.t自选酒.rawValue:
                        let tagText = NSMutableAttributedString(string: item.text)
                        tagText.yy_font = UIFont.systemFont(ofSize: item.fontPt)
                        tagText.yy_color = UIColor.main_btnNormal
                        tagText.yy_setTextBinding(YYTextBinding(deleteConfirm: true), range: tagText.yy_rangeOfAll())
                        let highlight = YYTextHighlight()
                        highlight.tapAction = { (containerView,text,range,rect) in
                            SP_HUD.showMsg("点击了自选酒")
                        }
                        tagText.yy_setTextHighlight(highlight, range: tagText.yy_rangeOfAll())
                        locationStr.append(tagText)
                    case M_SP_RichTextType.t超链接.rawValue:
                        let tagText = NSMutableAttributedString(string: item.text)
                        tagText.yy_font = UIFont.systemFont(ofSize: item.fontPt)
                        tagText.yy_color = UIColor.main_btnNormal
                        tagText.yy_setTextBinding(YYTextBinding(deleteConfirm: true), range: tagText.yy_rangeOfAll())
                        let highlight = YYTextHighlight()
                        highlight.tapAction = { (containerView,text,range,rect) in
                            SP_HUD.showMsg("点击了超链接")
                        }
                        tagText.yy_setTextHighlight(highlight, range: tagText.yy_rangeOfAll())
                        locationStr.append(tagText)
                    case M_SP_RichTextType.t图片.rawValue:
                        let image = YYImage(named: "HuanChong")
                        image?.preloadAllAnimatedImageFrames = true
                        let imageView = YYAnimatedImageView(image: image)
                        imageView.sp_ImageName(item.imgUrl)
                        imageView.clipsToBounds = true
                        let size = CGSize(width:sp_ScreenWidth-20, height:item.imgHeight/(item.imgWidth/(sp_ScreenWidth-20)))
                        
                        imageView.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                        let tagText = NSMutableAttributedString.yy_attachmentString(withContent: imageView, contentMode: .scaleAspectFill, attachmentSize: size, alignTo: UIFont.systemFont(ofSize: item.imgHeight/(item.imgWidth/(sp_ScreenWidth-20))), alignment: YYTextVerticalAlignment.bottom)
                        tagText.yy_font = UIFont.systemFont(ofSize: 18)
                        
                        let highlight = YYTextHighlight()
                        highlight.tapAction = { [unowned self](containerView,text,range,rect) in
                            let index = self._locations.index(of: range.location)!
                            SP_PhotoBrowser.show(self, images: self._images, index: index)
                        }
                        tagText.yy_setTextHighlight(highlight, range: tagText.yy_rangeOfAll())
                        
                        _images.append(item.imgUrl)
                        _locations.append(locationStr.length)
                        locationStr.append(tagText)
                    default:
                        break
                    }
                    
                }
                cell.textView.attributedText = locationStr
                return cell
            }
        default:
            return UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension My_NewsPostDetail {
    fileprivate func t_添加朋友关注() {
        if _dataNewsS.is_concerned {
            SP_HUD.show(view: self.view, type: .tLoading, text: sp_localized("取消关注"))
            My_API.t_删除朋友关注(user_id:_dataNewsS.author_id).post(M_MyCommon.self) { [weak self](isOk, data, error) in
                SP_HUD.hidden()
                if isOk {
                    SP_HUD.show(text:sp_localized("已取消"))
                    self?._dataNewsS.is_concerned = false
                    let ind = IndexPath(row: 0, section: 0)
                    self?.tableView.reloadRows(at: [ind], with: .none)
                    self?._vcBlock?(.t关注(follow:false))
                }else{
                    SP_HUD.show(text:error)
                }
                
            }
        }else{
            SP_HUD.show(view: self.view, type: .tLoading, text: sp_localized("添加关注"))
            My_API.t_添加朋友关注(user_id:_dataNewsS.author_id).post(M_MyCommon.self) { [weak self](isOk, data, error) in
                SP_HUD.hidden()
                if isOk {
                    SP_HUD.show(text:sp_localized("已关注"))
                    let ind = IndexPath(row: 0, section: 0)
                    self?._dataNewsS.is_concerned = true
                    self?.tableView.reloadRows(at: [ind], with: .none)
                    self?._vcBlock?(.t关注(follow:true))
                }else{
                    SP_HUD.show(text:error)
                }
                
            }
        }
    }
    
    func t_短评点赞() {
        
        My_API.t_短评点赞(blog_id:_dataNewsS.blog_id).post(M_MyCommon.self) { [weak self](isOk, data, error) in
            SP_HUD.hidden()
            if isOk {
                SP_HUD.show(text:sp_localized("👍 +1"))
                self?._vcBlock?(.t赞)
            }else{
                SP_HUD.show(text:error)
            }
            
        }
    }
}
