//
//  PhotoPreviewViewController.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/8.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import UIKit
import Photos


class PhotoPreviewViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,PhotoPreviewBottomBarViewDelegate,PhotoPreviewToolbarViewDelegate,PhotoPreviewCellDelegate {

    var allSelectImage: PHFetchResult<PHObject>?
    var collectionView: UICollectionView?
    var currentPage: Int = 1
    
    let cellIdentifier = "PhotoPreviewCell"
    weak var fromDelegate: PhotoCollectionViewControllerDelegate?
    
    fileprivate var toolbar: PhotoPreviewToolbarView?
    fileprivate var bottomBar: PhotoPreviewBottomBarView?
    
    fileprivate var isAnimation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configCollectionView()
        self.configToolbar()
    }
    
    fileprivate func configToolbar(){
        self.toolbar = PhotoPreviewToolbarView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        self.toolbar?.delegate = self
        self.toolbar?.sourceDelegate = self
        let positionY = self.view.bounds.height - 50
        self.bottomBar = PhotoPreviewBottomBarView(frame: CGRect(x: 0,y: positionY,width: self.view.bounds.width,height: 50))
        self.bottomBar?.delegate = self
        self.bottomBar?.changeNumber(PhotoImage.instance.selectedImage.count, animation: false)
        
        self.view.addSubview(toolbar!)
        self.view.addSubview(bottomBar!)
    }
    
    // MARK: -  delegate
    func onDoneButtonClicked() {
        if let nav = self.navigationController as? PhotoPickerController {
            
            nav.imageSelectFinish()
        }
    }
    
    // MARK: -  from page delegate 
    func onToolbarBackArrowClicked() {
        _ = self.navigationController?.popViewController(animated: true)
        if let delegate = self.fromDelegate {
            delegate.onPreviewPageBack()
        }
    }
    
    func onSelected(_ select: Bool) {
        let currentModel = self.allSelectImage![self.currentPage]
        if select {
            PhotoImage.instance.selectedImage.append(currentModel as! PHAsset)
        } else {
            if let index = PhotoImage.instance.selectedImage.index(of: currentModel as! PHAsset){
                PhotoImage.instance.selectedImage.remove(at: index)
            }
        }
        self.bottomBar?.changeNumber(PhotoImage.instance.selectedImage.count, animation: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // fullscreen controller
        self.navigationController?.isNavigationBarHidden = true
        UIApplication.shared.isStatusBarHidden = true
        UIApplication.shared.statusBarStyle = .lightContent
        
        self.collectionView?.setContentOffset(CGPoint(x: CGFloat(self.currentPage) * self.view.bounds.width, y: 0), animated: false)
        
        self.changeCurrentToolbar()
    }
    
    func configCollectionView(){
        self.automaticallyAdjustsScrollViewInsets = false
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: self.view.frame.width,height: self.view.frame.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        self.collectionView!.backgroundColor = UIColor.black
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
        self.collectionView!.isPagingEnabled = true
        self.collectionView!.scrollsToTop = false
        self.collectionView!.showsHorizontalScrollIndicator = false
        self.collectionView!.contentOffset = CGPoint(x: 0, y: 0)
        self.collectionView!.contentSize = CGSize(width: self.view.bounds.width * CGFloat(self.allSelectImage!.count), height: self.view.bounds.height)
        
        self.view.addSubview(self.collectionView!)
        self.collectionView!.register(PhotoPreviewCell.self, forCellWithReuseIdentifier: self.cellIdentifier)
    }
    
    // MARK: -  collectionView dataSource delagate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allSelectImage!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! PhotoPreviewCell
        cell.delegate = self
        if let asset = self.allSelectImage![indexPath.row] as? PHAsset {
            cell.renderModel(asset)
        }
        
        return cell
    }
    
    // MARK: -  Photo Preview Cell Delegate
    func onImageSingleTap() {
        if self.isAnimation {
            return
        }
        
        self.isAnimation = true
        if self.toolbar!.frame.origin.y < 0 {
            UIView.animate(withDuration: 0.3, delay: 0, options: [UIViewAnimationOptions.curveEaseOut], animations: { [unowned self]() -> Void in
                self.toolbar!.frame.origin = CGPoint(x: 0, y: 0)
                var originPoint = self.bottomBar!.frame.origin
                originPoint.y = originPoint.y - self.bottomBar!.frame.height
                self.bottomBar!.frame.origin = originPoint
                }, completion: { [unowned self](isFinished) -> Void in
                    if isFinished {
                        self.isAnimation = false
                    }
            })
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, options: [UIViewAnimationOptions.curveEaseOut], animations: { [unowned self]() -> Void in
                self.toolbar!.frame.origin = CGPoint(x: 0, y: -self.toolbar!.frame.height)
                var originPoint = self.bottomBar!.frame.origin
                originPoint.y = originPoint.y + self.bottomBar!.frame.height
                self.bottomBar!.frame.origin = originPoint
                
                }, completion: { [unowned self](isFinished) -> Void in
                    if isFinished {
                        self.isAnimation = false
                    }
            })
        }
        
    }
    
    
    // MARK: -  scroll page
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        self.currentPage = Int(offset.x / self.view.bounds.width)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.changeCurrentToolbar()
    }
    
    fileprivate func changeCurrentToolbar(){
        let model = self.allSelectImage![self.currentPage] as! PHAsset
        if let _ = PhotoImage.instance.selectedImage.index(of: model){
            self.toolbar!.setSelect(true)
        } else {
            self.toolbar!.setSelect(false)
        }
    }
    
}
