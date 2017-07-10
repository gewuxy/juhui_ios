//
//  PhotoPickerController.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/5.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import UIKit
import Photos

enum PageType{
    case list
    case recentAlbum
    case allAlbum
}

protocol PhotoPickerControllerDelegate: class{
    func onImageSelectFinished(_ images: [PHAsset])
}

class PhotoPickerController: UINavigationController {
    
    // the select image max number
    static var imageMaxSelectedNum = 4
    
    // already select total
    static var alreadySelectedImageNum = 0
    
    
    weak var imageSelectDelegate: PhotoPickerControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(type:PageType){
        let rootViewController = PhotoAlbumsTableViewController(style:.plain)
        // clear cache
        PhotoImage.instance.selectedImage.removeAll()
        super.init(rootViewController: rootViewController)
        
        if type == .recentAlbum || type == .allAlbum {
            let currentType = type == .recentAlbum ? PHAssetCollectionSubtype.smartAlbumRecentlyAdded : PHAssetCollectionSubtype.smartAlbumUserLibrary
            let results = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype:currentType, options: nil)
            if results.count > 0 {
                if let model = self.getModel(results[0] ) {
                    if model.count > 0 {
                        let layout = PhotoCollectionViewController.configCustomCollectionLayout()
                        let controller = PhotoCollectionViewController(collectionViewLayout: layout)
                        
                        controller.fetchResult = model
                        self.pushViewController(controller, animated: false)
                    }
                }
            }
        }
    }
    
    
    fileprivate func getModel(_ collection: PHAssetCollection) -> PHFetchResult<PHAsset>?{
        let fetchResult = PHAsset.fetchAssets(in: collection, options: PhotoFetchOptions.shareInstance)
        if fetchResult.count > 0 {
            return fetchResult
        }
        return nil
    }
   
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func imageSelectFinish(){
        if self.imageSelectDelegate != nil {
            self.dismiss(animated: true, completion: nil)
            self.imageSelectDelegate?.onImageSelectFinished(PhotoImage.instance.selectedImage)
        }
    }
    
    
    

}
