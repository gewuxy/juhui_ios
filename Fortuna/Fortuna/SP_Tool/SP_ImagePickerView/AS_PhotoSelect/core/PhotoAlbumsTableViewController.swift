//
//  PhotoAlbumsTableViewController.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/5.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import UIKit
import Photos

class PhotoAlbumsTableViewController: UITableViewController,PHPhotoLibraryChangeObserver{
    
    // 自定义需要加载的相册
    var customSmartCollections = [
        PHAssetCollectionSubtype.smartAlbumUserLibrary, // All Photos
        PHAssetCollectionSubtype.smartAlbumRecentlyAdded // Rencent Added
    ]
    
    // tableCellIndetifier 
    let albumTableViewCellItentifier = "PhotoAlbumTableViewCell"
    var albums = [ImageModel]()
    let imageManager = PHImageManager.default()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 9.0以上添加截屏图片
        if #available(iOS 9.0, *) {
            customSmartCollections.append(.smartAlbumScreenshots)
        }
        
        PHPhotoLibrary.shared().register(self)
        
        self.setupTableView()
        self.configNavigationBar()
        self.loadAlbums(false)

    }

    
    deinit{
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        self.loadAlbums(true)
    }
    
    fileprivate func setupTableView(){
        self.tableView.register(UINib.init(nibName: self.albumTableViewCellItentifier, bundle: nil), forCellReuseIdentifier: self.albumTableViewCellItentifier)
        
        // 自定义 separatorLine样式
        self.tableView.rowHeight = PhotoPickerConfig.AlbumTableViewCellHeight
        self.tableView.separatorColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.15)
        self.tableView.separatorInset = UIEdgeInsets.zero
        
        // 去除tableView多余空格线
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    
    fileprivate func loadAlbums(_ replace: Bool){
        
        if replace {
            self.albums.removeAll()
        }
        
        // 加载Smart Albumns All Photos
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        
        for i in 0 ..< smartAlbums.count  {
            if customSmartCollections.contains(smartAlbums[i].assetCollectionSubtype){
                self.filterFetchResult(smartAlbums[i])
            }
        }
        
        // 用户相册
        let topUserLibarayList = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        for i in 0 ..< topUserLibarayList.count {
            if let topUserAlbumItem = topUserLibarayList[i] as? PHAssetCollection {
                self.filterFetchResult(topUserAlbumItem)
            }
        }
        
        self.tableView.reloadData()
    }
    
    fileprivate func filterFetchResult(_ collection: PHAssetCollection){
        let fetchResult = PHAsset.fetchAssets(in: collection, options: PhotoFetchOptions.shareInstance)
        if fetchResult.count > 0 {
            let model = ImageModel(result: fetchResult, label: collection.localizedTitle, assetType: collection.assetCollectionSubtype)
            self.albums.append(model)
        }
    }
    
    fileprivate func configNavigationBar(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.main_1
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(PhotoAlbumsTableViewController.eventViewControllerDismiss))
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    func eventViewControllerDismiss(){
        if let nav = self.navigationController as? PhotoPickerController {
            PhotoImage.instance.selectedImage.removeAll()
            
            nav.imageSelectFinish()
        }
        PhotoImage.instance.selectedImage.removeAll()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.albumTableViewCellItentifier, for: indexPath) as! PhotoAlbumTableViewCell
        
        let model = self.albums[indexPath.row]
        
        cell.renderData(model.fetchResult, label: model.label)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.showDetailPageModel(self.albums[indexPath.row])
        
    }
    
    fileprivate func showDetailPageModel(_ model: ImageModel){
        let layout = PhotoCollectionViewController.configCustomCollectionLayout()
        let controller = PhotoCollectionViewController(collectionViewLayout: layout)
    
        controller.fetchResult = model.fetchResult
        self.navigationController?.show(controller, sender: nil)
    }
    

}
