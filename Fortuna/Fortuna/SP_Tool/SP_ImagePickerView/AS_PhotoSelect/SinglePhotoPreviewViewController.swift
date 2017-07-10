//
//  SinglePhotoPreviewViewController.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/12.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import UIKit
import Photos
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class SinglePhotoPreviewViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,PhotoPreviewCellDelegate {
    
    var selectImages:[PhotoImageModel]?
    
    fileprivate var collectionView: UICollectionView?
    fileprivate let cellIdentifier = "cellIdentifier"
    var currentPage: Int = 0
    
    weak var sourceDelegate: SP_AddPhotoPickerVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "back", style: .plain, target: self, action: nil)
        
        self.configNavigationBar()
        self.configCollectionView()
    }
    
    fileprivate func configNavigationBar(){
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = UIColor.white
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.barTintColor = UIColor.main_1
//        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(SinglePhotoPreviewViewController.eventRemoveImage))
    }
    
    func eventRemoveImage(){
        let element = self.selectImages?.remove(at: self.currentPage)
        self.updatePageTitle()
        self.sourceDelegate?.removeElement(element?.data?.localIdentifier)
        
        if self.selectImages?.count > 0{
            self.collectionView?.reloadData()
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.setContentOffset(CGPoint(x: CGFloat(self.currentPage) * self.view.bounds.width, y: 0), animated: false)
        self.updatePageTitle()
    }
    
    fileprivate func updatePageTitle(){
        self.title =  String(self.currentPage+1) + "/" + String(self.selectImages!.count)
    }
    
    func configCollectionView(){
        self.automaticallyAdjustsScrollViewInsets = false
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: self.view.frame.width,height: self.view.frame.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
        self.collectionView!.isPagingEnabled = true
        self.collectionView!.scrollsToTop = false
        self.collectionView!.showsHorizontalScrollIndicator = false
        self.collectionView!.contentOffset = CGPoint(x: 0, y: 0)
        self.collectionView!.contentSize = CGSize(width: self.view.bounds.width * CGFloat(self.selectImages!.count), height: self.view.bounds.height)
        
        self.view.addSubview(self.collectionView!)
        self.collectionView!.register(PhotoPreviewCell.self, forCellWithReuseIdentifier: self.cellIdentifier)
    }
    
    // MARK: -  collectionView dataSource delagate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectImages!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! PhotoPreviewCell
        cell.delegate = self
        if let asset = self.selectImages?[indexPath.row] {
            cell.renderModel(asset.data!)
        }
        
        return cell
    }
    
    // MARK: -  Photo Preview Cell Delegate
    func onImageSingleTap() {
        let status = !UIApplication.shared.isStatusBarHidden
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.setNavigationBarHidden(status, animated: true)
    }
    
    // MARK: -  scroll page
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        self.currentPage = Int(offset.x / self.view.bounds.width)
        self.updatePageTitle()
    }
    
}
