//
//  JH_IM_Tab.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/13.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import MediaPlayer
extension JH_IM {
    func toRowBottom(_ animated:Bool = false, time:Double = 0.0){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) { [weak self] _ in
            self?.tableView?.setContentOffset(CGPoint.zero, animated:true)
            /*
            guard self != nil else{return}
            guard self!._tabDatas.count > 0 else{return}
            let indexPath = IndexPath(row: 0, section: 0)
            self?.tableView.scrollToRow(at: indexPath, at: .top, animated: false)*/
        }
        
    }
    func makeTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI))
        
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, tableView.bounds.size.width-7)
    }
    /*
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
        
        self._tabView._cellForRowAt = { [weak self](tableView,indexPath) -> UITableViewCell in
            guard self != nil else {return UITableViewCell()}
            let model = self!._tabDatas[indexPath.row]
            switch model.type {
            case .tText:
                if model.isMe {
                    let cell = SP_IM_TabCell_MeText.show(tableView, indexPath)
                    cell.text_title.text = model.text
                    cell.btn_logo.sp_ImageName(model.userLogo)
                    cell.isLoading = model.isLoading
                    return cell
                }else{
                    let cell = SP_IM_TabCell_HeText.show(tableView, indexPath)
                    cell.text_title.text = model.text
                    cell.btn_logo.sp_ImageName(model.userLogo)
                    cell.lab_name.text = model.userName.isEmpty ? model.userMobile : model.userName
                    return cell
                }
            case .tImage,.tVideo:
                if model.isMe {
                    let cell = SP_IM_TabCell_MeImg.show(tableView, indexPath)
                    return cell
                }else{
                    let cell = SP_IM_TabCell_HeImg.show(tableView, indexPath)
                    cell.btn_logo.sp_ImageName(model.userLogo)
                    cell.lab_name.text = model.userName.isEmpty ? model.userMobile : model.userName
                    cell.btn_play.isHidden = model.type != .tVideo
                    return cell
                }
                
            case .tVoice:
                if model.isMe {
                    let cell = SP_IM_TabCell_MeVoice.show(tableView, indexPath)
                    return cell
                }else{
                    let cell = SP_IM_TabCell_HeVoice.show(tableView, indexPath)
                    cell.btn_logo.sp_ImageName(model.userLogo)
                    cell.lab_name.text = model.userName.isEmpty ? model.userMobile : model.userName
                    return cell
                }
            }
        }
        
    }*/
}
extension JH_IM:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    /*
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return  nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return  nil
    }*/
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._tabDatas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self._tabDatas[indexPath.row]
        switch model.type {
        case .tText:
            if model.isMe {
                let cell = SP_IM_TabCell_MeText.show(tableView, indexPath)
                cell.text_title.text = model.content
                cell.btn_logo.sp_ImageName(model.userLogo)
                cell.isLoading = model.isLoading
                return cell
            }else{
                let cell = SP_IM_TabCell_HeText.show(tableView, indexPath)
                cell.text_title.text = model.content
                cell.btn_logo.sp_ImageName(model.userLogo)
                cell.lab_name.text = model.userName.isEmpty ? model.userMobile : model.userName
                return cell
            }
        case .tImage:
            if model.isMe {
                let cell = SP_IM_TabCell_MeImg.show(tableView, indexPath)
                cell.btn_logo.sp_ImageName(model.userLogo)
                cell.btn_play.isHidden = true
                cell.isLoading = model.isLoading
                if model.isLoading {
                    cell.btn_Img.setImage(model.loadingImage, for: .normal)
                    cell._block = { type in
                        
                    }
                }else{
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
                }
                
                return cell
            }else{
                let cell = SP_IM_TabCell_HeImg.show(tableView, indexPath)
                cell.btn_logo.sp_ImageName(model.userLogo)
                cell.lab_name.text = model.userName.isEmpty ? model.userMobile : model.userName
                cell.btn_Img.sp_ImageName(model.content)
                cell.btn_play.isHidden = true
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
                return cell
            }
        case .tVideo:
            if model.isMe {
                let cell = SP_IM_TabCell_MeImg.show(tableView, indexPath)
                cell.btn_logo.sp_ImageName(model.userLogo)
                cell.btn_play.isHidden = false
                cell.isLoading = model.isLoading
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
                
                return cell
            }else{
                let cell = SP_IM_TabCell_HeImg.show(tableView, indexPath)
                cell.btn_logo.sp_ImageName(model.userLogo)
                cell.lab_name.text = model.userName.isEmpty ? model.userMobile : model.userName
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
                return cell
            }
        case .tVoice:
            if model.isMe {
                let cell = SP_IM_TabCell_MeVoice.show(tableView, indexPath)
                cell.isLoading = model.isLoading
                if !model.isLoading && !model.isSendFailure {
                    cell.button_CF.setTitle(model.videoImg, for: .normal)
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
                return cell
            }else{
                let cell = SP_IM_TabCell_HeVoice.show(tableView, indexPath)
                cell.btn_logo.sp_ImageName(model.userLogo)
                cell.lab_name.text = model.userName.isEmpty ? model.userMobile : model.userName
                cell.lab_time.text = model.videoImg
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
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self._inputView.text_View.resignFirstResponder()
        self.hiddenHudImg()
    }
}



