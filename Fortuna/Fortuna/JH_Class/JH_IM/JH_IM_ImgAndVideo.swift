//
//  JH_IM_ImgAndVideo.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/28.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
//MARK:--- 底部选择 弹窗 -----------------------------
extension JH_IM {
    func makeHudImg() {
        self.btn_hudImg.layer.borderWidth = 0.5
        self.btn_hudImg.layer.borderColor = UIColor.main_line.cgColor
        self.btn_hudVideo.layer.borderWidth = 0.5
        self.btn_hudVideo.layer.borderColor = UIColor.main_line.cgColor
        
        self.lab_hudImg.text = sp_localized("图片")
        self.lab_hudVideo.text = sp_localized("视频")
        
    }
    func showHudImg() {
        guard view_hud_B.constant != 0 else {
            return
        }
        self._inputView.text_View.resignFirstResponder()
        self.view_hud_B.constant = 0
        self._hudImgHeight = 100
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.2, animations: { [weak self]_ in
            self?.view.layoutIfNeeded()
            
        }) { (bool) in
            
        }
        self.toRowBottom(true)
    }
    func hiddenHudImg(_ time:TimeInterval = 0.2) {
        
        self.view_hud_B.constant = -100
        self._hudImgHeight = 0
        self.view.setNeedsLayout()
        UIView.animate(withDuration: time, animations: { [weak self]_ in
            self?.view.layoutIfNeeded()
            
        }) { (bool) in
            
        }
        
    }
    
    @IBAction func clickHudBtn(_ sender: UIButton) {
        switch sender {
        case btn_hudImg:
            self.selectPhoto()
        case btn_hudVideo:
            self.selectVideo()
        default:
            break
        }
    }
    
    
}

extension JH_IM {
    //MARK:--- 选择图片 -----------------------------
    func selectPhoto(){
        hiddenHudImg()
        
        let vc = HXPhotoViewController()
        self.manager.type = HXPhotoManagerSelectedTypePhoto
        vc.delegate = self
        self.manager.photoMaxNum = 9
        self.manager.emptySelectedList()
        vc.manager = self.manager
        let nVC = UINavigationController(rootViewController: vc)
        UIApplication.shared.statusBarStyle = .default
        self.present(nVC, animated: true, completion: nil)
    }
    //MARK:--- 选择视频 -----------------------------
    func selectVideo(){
        
        hiddenHudImg()
        let vc = HXPhotoViewController()
        self.manager.type = HXPhotoManagerSelectedTypeVideo
        vc.delegate = self
        vc.manager = self.manager
        let nVC = UINavigationController(rootViewController: vc)
        UIApplication.shared.statusBarStyle = .default
        self.present(nVC, animated: true, completion: nil)
    }
}

extension JH_IM:HXPhotoViewControllerDelegate {
    
    func photoViewControllerDidNext(_ allList: [HXPhotoModel]!, photos: [HXPhotoModel]!, videos: [HXPhotoModel]!, original: Bool) {
        
        if photos.count > 0 {
            
            _inpPotos = photos
            
            self.uploadImagesAtIndex()
        }
        
        if videos.count > 0 {
            
            let model = videos[0]
            var videoUrl:URL?
            switch model.type {
            case HXPhotoModelMediaTypeVideo:
                videoUrl = model.avAsset.value(forKey: "URL") as? URL ?? nil
                guard videoUrl != nil else{return}
                SP_ToolOC.zipVideo(withInputURL: videoUrl!, complete: { [weak self](url) in
                    self?.updateVideo(url)
                })
                
            case HXPhotoModelMediaTypeCameraVideo:
                videoUrl = model.videoURL
                self.updateVideo(videoUrl)
            default:
                break
            }
        }
    }
    
    func photoViewControllerDidCancel() {
        print_SP("===================== 取消了 ==================")
    }
}

extension JH_IM {
    func uploadImagesAtIndex() {
        for item in _inpPotos {
            switch item.type {
            case HXPhotoModelMediaTypePhoto:
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                options.deliveryMode = .highQualityFormat
                options.resizeMode = .exact
                PHImageManager.default().requestImage(for: item.asset, targetSize: CGSize(width: item.asset.pixelWidth, height: item.asset.pixelHeight), contentMode: .aspectFit, options: options, resultHandler: { [weak self](image, dact) in
                    guard self != nil else{return}
                    self?.uploadImages([SP_ImageUnit.toJpgData(image!, isZip: true)], index:0)
                })
            case HXPhotoModelMediaTypeCameraPhoto:
                
                self.uploadImages([SP_ImageUnit.toJpgData(item.thumbPhoto, isZip: true)], index:0)
                
            default:
                break
            }
        }
    }
    //MARK:--- 上传图片
    func uploadImages( _ datas:[Data], index:Int){
        guard datas.count > 0 else {
            return
        }
        
        
        for item in datas {
            
            uploadTopImage(item, i:index)
        }
    }
    func uploadTopImage(_ data:Data, i:Int) {
        var p = SP_UploadParam()
        p.fileData = data //as? Data ?? Data()
        p.filename =  Date.sp_Date("yyyyMMddHHmmssSSS") + ".jpg"
        p.serverName = "file"
        p.mimeType = "image/jpg"
        p.type = .tData
        
        
        var model = SP_IM_TabModel()
        model.type = .tImage
        model.loadingImage = UIImage(data: data)
        model.userLogo = SP_UserModel.read().imgUrl
        model.isMe = true
        model.isLoading = true
        model.create_at = String(format: "%.0f", Date().timeIntervalSince1970*1000)
        print_SP(model)
        if self._tabDatas.count > 0 {
            self._tabDatas.insert(model, at: 0)
        }else{
            self._tabDatas.append(model)
        }
        
        self.tableView.reloadData()
        self.toRowBottom()
        SP_HUD.hidden()
        My_API.t_媒体文件上传(uploadParams: [p]).upload(M_MyCommon.self, block: { [weak self](isOk, data, error) in
            if isOk {
                guard let datas = data as? M_MyCommon else{return}
                model.content = datas.media_url
                model.videoImg = datas.media_img
                self?.tableView?.reloadData()
                self?.sendMessage(model)
            }else{
                
            }
            
        }) { (progress) in
            
            let progre = CGFloat(progress!.completedUnitCount)/CGFloat(progress!.totalUnitCount)
            print_SP(progre)
        }
    }
    
    //MARK:--- 上传视频 -----------------------------
    func updateVideo(_ videoUrl:URL?) {
        
        guard videoUrl != nil else {
            SP_HUD.show(type: .tError, text: "读取视频失败", time:1.0)
            return
        }
        
        guard let dat = try? Data(contentsOf: videoUrl!) else {
            SP_HUD.show(type: .tError, text: "读取视频失败", time:1.0)
            return
        }
        var p = SP_UploadParam()
        p.type = .tData
        p.fileURL = videoUrl!
        p.fileData = dat
        p.mimeType = "video/mp4"
        p.serverName = "file"
        p.filename =  Date.sp_Date("yyyyMMddHHmmssSSS") + ".mp4"
        
        var model = SP_IM_TabModel()
        let imgPath:String = "file://"+SP_ToolOC.imagePath(forVideo: videoUrl!)
        model.videoImg = "HuanChong"
        model.content = videoUrl!.absoluteString
        model.userLogo = SP_UserModel.read().imgUrl
        model.type = .tVideo
        model.isMe = true
        model.isLoading = true
        model.create_at = String(format: "%.0f", Date().timeIntervalSince1970*1000)
        print_SP(model)
        if self._tabDatas.count > 0 {
            self._tabDatas.insert(model, at: 0)
        }else{
            self._tabDatas.append(model)
        }
        self.tableView.reloadData()
        self.toRowBottom()
        SP_HUD.hidden()
        My_API.t_媒体文件上传(uploadParams: [p]).upload(M_MyCommon.self, block: { [weak self](isOk, data, error) in
            print_SP(isOk)
            if isOk {
                guard let datas = data as? M_MyCommon else{return}
                model.content = datas.media_url
                model.videoImg = datas.media_img
                for (i,dat) in self!._tabDatas.enumerated() {
                    if model.create_at == dat.create_at {
                        self?._tabDatas[i].content = model.content
                        self?._tabDatas[i].videoImg = model.videoImg
                    }
                    
                }
                self?.tableView?.reloadData()
                self?.sendMessage(model)
                
            }else{
                
            }
            
        }) { (progress) in
            let progre = CGFloat(progress!.completedUnitCount)/CGFloat(progress!.totalUnitCount)
            print_SP(progre)
        }
    }
    
    //MARK:--- 上传音频 -----------------------------
    func updateVoice(_ voiceUrl:URL?, time:String) {
        
        
        guard voiceUrl != nil else {
            SP_HUD.show(type: .tError, text: "读取录音失败", time:1.0)
            return
        }
        //print_SP(voiceUrl)
        //print_SP(voiceUrl?.absoluteString)
        
        var p = SP_UploadParam()
        p.type = .tFileURL
        p.fileURL = voiceUrl!
        p.mimeType = "video/mp3"
        p.serverName = "file"
        p.filename =  Date.sp_Date("yyyyMMddHHmmssSSS") + ".mp3"
        
        var model = SP_IM_TabModel()
        model.content = voiceUrl!.absoluteString
        if model.content.hasPrefix("file://") {
            model.content[0..<7] = ""
        }
        model.videoImg = time
        model.userLogo = SP_UserModel.read().imgUrl
        model.type = .tVoice
        model.isMe = true
        model.isLoading = true
        model.create_at = String(format: "%.0f", Date().timeIntervalSince1970*1000)
        print_SP(model)
        if self._tabDatas.count > 0 {
            self._tabDatas.insert(model, at: 0)
        }else{
            self._tabDatas.append(model)
        }
        self.tableView.reloadData()
        self.toRowBottom()
        SP_HUD.hidden()
        My_API.t_媒体文件上传(uploadParams: [p]).upload(M_MyCommon.self, block: { [weak self](isOk, data, error) in
            guard self != nil else{return}
            if isOk {
                guard let datas = data as? M_MyCommon else{return}
                model.content = datas.media_url
                for (i,dat) in self!._tabDatas.enumerated() {
                    if model.create_at == dat.create_at {
                        self?._tabDatas[i].content = model.content
                    }
                    
                }
                self?.tableView?.reloadData()
                self?.sendMessage(model)
            }else{
                
            }
            
        }) { (progress) in
            let progre = CGFloat(progress!.completedUnitCount)/CGFloat(progress!.totalUnitCount)
            print_SP(progre)
        }
    }
    
}
