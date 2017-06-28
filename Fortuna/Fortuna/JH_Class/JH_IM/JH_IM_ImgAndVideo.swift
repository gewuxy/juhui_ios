//
//  JH_IM_ImgAndVideo.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/28.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation

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
        
    }
    func photoViewControllerDidCancel() {
        print_SP("===================== 取消了 ==================")
    }
}
