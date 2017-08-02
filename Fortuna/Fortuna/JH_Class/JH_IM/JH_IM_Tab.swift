//
//  JH_IM_Tab.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/13.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import MediaPlayer
import UITableView_FDTemplateLayoutCell
extension JH_IM {
    func toRowBottom(_ animated:Bool = false, time:Double = 0.0){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) { [weak self] _ in
            guard self != nil else{return}
            /*
            if self!._tabView.tableView.contentSize.height > self!._tabView.tableView.frame.size.height
            {
                let offset = CGPoint(x: 0, y: self!._tabView.tableView.contentSize.height - self!._tabView.tableView.frame.size.height);
                self?._tabView.tableView?.setContentOffset(offset, animated:animated)
            }*/
            
            guard self!._tabDatas.count > 0 else{return}
            let indexPath = IndexPath(row: self!._tabDatas.count - 1, section: 0)
            self?._tabView.tableView?.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
        
    }
    
    func makeTableViewDelegate() {
        self._tabView._scrollViewWillBeginDragging = { _ in
            self._inputView.text_View.resignFirstResponder()
            self.hiddenHudImg()
        }
        self._tabView._numberOfSections = { _ -> Int in
            return 1
        }
        self._tabView._numberOfRowsInSection = { [weak self]_ -> Int in
            guard self != nil else {return 0}
            return self!._tabDatas.count
        }
        /*
        self._tabView._heightForRow = { [weak self](tableView,indexPath) -> CGFloat in
            let model = self!._tabDatas[indexPath.row]
            var identifier = ""
            switch model.type {
            case .tText:
                identifier = model.isMe ? "SP_IM_TabCell_MeText" : "SP_IM_TabCell_HeText"
            case .tImage, .tVideo:
                identifier = model.isMe ? "SP_IM_TabCell_MeImg" : "SP_IM_TabCell_HeImg"
            case .tVoice:
                identifier = model.isMe ? "SP_IM_TabCell_MeVoice" : "SP_IM_TabCell_HeVoice"
            }
            
            return tableView.fd_heightForCell(withIdentifier: identifier, cacheBy: indexPath, configuration: { [weak self](cell) in
                self?.makeCell(cell,indexPath)
            })
            
        }*/
        self._tabView._cellForRowAt = { [weak self](tableView,indexPath) -> UITableViewCell in
            guard self != nil else {return UITableViewCell()}
            let model = self!._tabDatas[indexPath.row]
            var cell:UITableViewCell?
            switch model.type {
            case .tText:
                cell = model.isMe ? SP_IM_TabCell_MeText.show(tableView) : SP_IM_TabCell_HeText.show(tableView)
            case .tImage, .tVideo:
                cell = model.isMe ? SP_IM_TabCell_MeImg.show(tableView) : SP_IM_TabCell_HeImg.show(tableView)
            case .tVoice:
                cell = model.isMe ? SP_IM_TabCell_MeVoice.show(tableView) : SP_IM_TabCell_HeVoice.show(tableView)
            }
            
            self?.makeCell(cell,indexPath)
            return cell ?? UITableViewCell()
            
        }
        
    }
    
    fileprivate func makeCell(_ cel:Any?, _ indexPath:IndexPath) {
        let model = self._tabDatas[indexPath.row]
        //MARK:--- SP_IM_TabCell_MeText ----------
        if let cell = cel as? SP_IM_TabCell_MeText {
            cell.text_title.text = model.content
            cell.btn_logo.sp_ImageName(model.userLogo)
            cell.isLoading = model.isLoading
            if model.isLoading {
                cell._block = { type in
                }
            }else{
                cell._block = { type in
                    switch type {
                    case .tLogo:
                        SP_PhotoBrowser.show(self, images: [model.userLogo], index:0)
                    default:
                        break
                    }
                    
                }
            }
        }
        //MARK:--- SP_IM_TabCell_HeText ----------
        if let cell = cel as? SP_IM_TabCell_HeText {
            cell.text_title.text = model.content
            cell.btn_logo.sp_ImageName(model.userLogo)
            cell.lab_name.text = model.userName.isEmpty ? model.userMobile : model.userName
            cell._block = { type in
                switch type {
                case .tLogo:
                    SP_PhotoBrowser.show(self, images: [model.userLogo], index:0)
                default:
                    break
                }
                
            }
        }
        //MARK:--- SP_IM_TabCell_MeImg ----------
        if let cell = cel as? SP_IM_TabCell_MeImg {
            cell.btn_logo.sp_ImageName(model.userLogo)
            cell.isLoading = model.isLoading
            if model.type == .tImage {
                cell.btn_play.isHidden = true
                cell.btn_Img.sp_ImageName(model.content, ph:false)
                cell._block = { type in
                    switch type {
                    case .tImg:
                        SP_PhotoBrowser.show(self, images: [model.content], index:0)
                    case .tLogo:
                        SP_PhotoBrowser.show(self, images: [model.userLogo], index:0)
                    default:
                        break
                    }
                    
                }
                /*
                if model.isLoading {
                    cell.btn_Img.setImage(model.loadingImage, for: .normal)
                    cell._block = { type in
                        
                    }
                }else{
                    
                }*/
            }else{
                cell.btn_play.isHidden = false
                cell.btn_Img.sp_ImageName(model.videoImg)
                cell._block = { [weak self]type in
                    switch type {
                    case .tImg:
                        let mvc = MPMoviePlayerViewController(contentURL: URL(string: model.content))
                        self?.presentMoviePlayerViewControllerAnimated(mvc)
                    case .tLogo:
                        SP_PhotoBrowser.show(self, images: [model.userLogo], index:0)
                    default:
                        break
                    }
                    
                }
            }
        }
        //MARK:--- SP_IM_TabCell_HeImg ----------
        if let cell = cel as? SP_IM_TabCell_HeImg {
            cell.btn_logo.sp_ImageName(model.userLogo)
            cell.lab_name.text = model.userName.isEmpty ? model.userMobile : model.userName
            if model.type == .tImage {
                cell.btn_play.isHidden = true
                cell.btn_Img.sp_ImageName(model.content)
                cell._block = { type in
                    switch type {
                    case .tImg:
                        SP_PhotoBrowser.show(self, images: [model.content], index:0)
                    case .tLogo:
                        SP_PhotoBrowser.show(self, images: [model.userLogo], index:0)
                    default:
                        break
                    }
                    
                }
            }else{
                cell.btn_play.isHidden = false
                cell.btn_Img.sp_ImageName(model.videoImg)
                cell._block = { [weak self]type in
                    switch type {
                    case .tImg:
                        let mvc = MPMoviePlayerViewController(contentURL: URL(string: model.content))
                        self?.presentMoviePlayerViewControllerAnimated(mvc)
                    case .tLogo:
                        SP_PhotoBrowser.show(self, images: [model.userLogo], index:0)
                    default:
                        break
                    }
                    
                }
            }
        }
        //MARK:--- SP_IM_TabCell_MeVoice ----------
        if let cell = cel as? SP_IM_TabCell_MeVoice {
            cell.btn_logo.sp_ImageName(model.userLogo)
            cell.isLoading = model.isLoading
            if !model.isLoading && !model.isSendFailure {
                cell.button_CF.setTitle(model.videoImg, for: .normal)
                let strArr = model.videoImg.components(separatedBy: "\"")
                let str = strArr.joined()
                if let time = Double(str) {
                    if time <= 1 {
                        //最小宽度
                        cell.btn_Img_W.constant = 60.0
                    }else{
                        //宽度根据时间适配
                        cell.btn_Img_W.constant = (sp_ScreenWidth-200)/60 * CGFloat(time) + 60.0
                    }
                }else{
                    cell.btn_Img_W.constant = 60.0
                }
                cell.button_CF.isHidden = false
                cell.button_CF.isEnabled = false
                cell.button_CF.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            }else{
                cell.button_CF.setTitle(model.isSendFailure ? sp_localized("！重发") : "", for: .normal)
                cell.button_CF.isHidden = !model.isSendFailure
                cell.button_CF.isEnabled = model.isSendFailure
                cell.button_CF.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            }
            cell._block = { [weak self]type in
                switch type {
                case .tVoice:
                    self?.playRecord(model.content, index: indexPath.row, playBtn: cell.btn_Img)
                case .tLogo:
                    SP_PhotoBrowser.show(self, images: [model.userLogo], index:0)
                default:
                    break
                }
            }
        }
        //MARK:--- SP_IM_TabCell_HeVoice ----------
        if let cell = cel as? SP_IM_TabCell_HeVoice {
            cell.btn_logo.sp_ImageName(model.userLogo)
            cell.lab_name.text = model.userName.isEmpty ? model.userMobile : model.userName
            cell.lab_time.text = model.videoImg
            let strArr = model.videoImg.components(separatedBy: "\"")
            let str = strArr.joined()
            if let time = Double(str) {
                if time <= 1 {
                    //最小宽度
                    cell.btn_Img_W.constant = 60.0
                }else{
                    //宽度根据时间适配
                    cell.btn_Img_W.constant = (sp_ScreenWidth-200)/60 * CGFloat(time) + 60.0
                }
            }else{
                cell.btn_Img_W.constant = 60.0
            }
            
            cell._block = { [weak self]type in
                switch type {
                case .tVoice:
                    self?.playRecord(model.content, index: indexPath.row, playBtn: cell.btn_Img)
                case .tLogo:
                    SP_PhotoBrowser.show(self, images: [model.userLogo], index:0)
                default:
                    break
                }
            }
        }
        
    }
    
}

