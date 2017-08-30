//
//  SP_RichTextEdit_ToolBar.swift
//  Fortuna
//
//  Created by LCD on 2017/8/28.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import YCXMenu
import RxCocoa
import RxSwift

struct SP_RichTextEdit_ToolBarConfi {
    var isBold = false
    var isBig:Bool = false {
        didSet{
            fontSize = isBig ? 24 : 18
        }
    }
    var fontSize:CGFloat = 18
}

extension SP_RichTextEdit {
    
    func makeToolBar() {
        
        toolBar.tool_B.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self](isOK) in
                self?.toolBarConfi.isBold = !self!.toolBarConfi.isBold
                self?.toolBar.tool_B.titleLabel?.font = self!.toolBarConfi.isBold ? UIFont.boldSystemFont(ofSize: 24) : UIFont.systemFont(ofSize: 18)
                self?.dataTextsAppendItem()
            }).addDisposableTo(disposeBag)
        
        toolBar.tool_A.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self](isOK) in
                self?.toolBarConfi.isBig = !self!.toolBarConfi.isBig
                self?.toolBar.tool_A.titleLabel?.font = UIFont.systemFont(ofSize: self!.toolBarConfi.fontSize)
                self?.dataTextsAppendItem()
            }).addDisposableTo(disposeBag)
        
        toolBar.tool_Img.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self](isOK) in
                self?.selectPhoto()
            }).addDisposableTo(disposeBag)
        
        toolBar.tool_Friend.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self](isOK) in
                self?.selectFriend()
            }).addDisposableTo(disposeBag)
        
        toolBar.tool_Wine.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self](isOK) in
                self?.selectWine()
            }).addDisposableTo(disposeBag)
        
        toolBar.tool_Wine.rx.tap
            .asObservable()
            .subscribe(onNext: { [weak self](isOK) in
                self?.selectLink()
            }).addDisposableTo(disposeBag)
    }
    
    fileprivate func makeMenu(){
        let menuItems = [
            YCXMenuItem.init(sp_localized("短评"), image: nil, tag: 0, userInfo: ["title":"短评"]),
            YCXMenuItem.init(sp_localized("长文"), image: nil, tag: 1, userInfo: ["title":"长文"]),
            YCXMenuItem.init(sp_localized("活动"), image: nil, tag: 2, userInfo: ["title":"活动"])]
        let point = toolBar.tool_B.convert(toolBar.tool_B.center, to: sp_MainWindow)
        let fromRect = CGRect(x: point.x, y: point.y, width: 0, height: 0)
        YCXMenu.setHasShadow(true)
        YCXMenu.setTintColor(UIColor.mainText_1)
        YCXMenu.setSelectedColor(UIColor.black)
        YCXMenu.show(in: sp_MainWindow, from: fromRect, menuItems: menuItems) { (index, item) in
            
        }
    }
    
    func selectFriend() {
        My_SearchFriendsVC.show(self)
    }
    func selectWine() {
        My_SearchWineVC.show(self)
    }
    func selectLink() {
        
    }
    func selectPhoto() {
        let man = HXPhotoManager(type: HXPhotoManagerSelectedTypePhoto)
        man?.photoMaxNum = 1
        man?.selectTogether = false
        
        let vc = HXPhotoViewController()
        
        vc.delegate = self
        
        man?.emptySelectedList()
        vc.manager = man
        let nVC = UINavigationController(rootViewController: vc)
        UIApplication.shared.statusBarStyle = .default
        self.present(nVC, animated: true, completion: nil)
    }
}

extension SP_RichTextEdit:HXPhotoViewControllerDelegate {
    func photoViewControllerDidCancel() {
        print_SP("===================== 取消了 ==================")
    }
    func photoViewControllerDidNext(_ allList: [HXPhotoModel]!, photos: [HXPhotoModel]!, videos: [HXPhotoModel]!, original: Bool) {
    }
    
    
}
