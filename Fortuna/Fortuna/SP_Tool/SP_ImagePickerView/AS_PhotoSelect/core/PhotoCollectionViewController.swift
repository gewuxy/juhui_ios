 //
//  PhotoCollectionViewController.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/6.
//  Copyright © 2016年 dailyios. All rights reserved.
//
//MARK:--- 照片选择
import UIKit
import Photos

private let reuseIdentifier = "photoCollectionViewCell"

protocol PhotoCollectionViewControllerDelegate:class {
    func onPreviewPageBack()
}

class PhotoCollectionViewController: UICollectionViewController, PHPhotoLibraryChangeObserver,PhotoCollectionViewCellDelegate,PhotoCollectionViewControllerDelegate,AlbumToolbarViewDelegate {
	
    let imageManager = PHCachingImageManager()
	fileprivate let toolbarHeight: CGFloat = 44.0
	
	var assetGridThumbnailSize: CGSize?
	var fetchResult: PHFetchResult<PHAsset>?
	var previousPreheatRect: CGRect?
    var toolbar: AlbumToolbarView?
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        let originFrame = self.collectionView!.frame
        self.collectionView!.frame = CGRect(x: originFrame.origin.x, y: originFrame.origin.y, width: originFrame.size.width, height: originFrame.height - self.toolbarHeight)
        
		self.resetCacheAssets()
        
		PHPhotoLibrary.shared().register(self)
		
		self.collectionView?.contentInset = UIEdgeInsetsMake(
            PhotoPickerConfig.MinimumInteritemSpacing,
            PhotoPickerConfig.MinimumInteritemSpacing,
            PhotoPickerConfig.MinimumInteritemSpacing,
            PhotoPickerConfig.MinimumInteritemSpacing
        )
		
		self.collectionView!.register(UINib.init(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
		
		self.configBackground()
        self.configBottomToolBar()
        self.configNavigationBar()
	}
    
	fileprivate func configBottomToolBar() {
        if self.toolbar != nil {return}
		let width = UIScreen.main.bounds.width
        let positionX = UIScreen.main.bounds.height - self.toolbarHeight - 64
        self.toolbar = AlbumToolbarView(frame: CGRect(x: 0,y: positionX,width: width,height: self.toolbarHeight))
        self.toolbar?.delegate = self
		self.view.addSubview(self.toolbar!)
        
        if PhotoImage.instance.selectedImage.count > 0 {
            self.toolbar?.changeNumber(PhotoImage.instance.selectedImage.count)
        }
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.isNavigationBarHidden = false
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        
        if assetGridThumbnailSize == nil {
            let scale = UIScreen.main.scale
            let cellSize = (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
            let size = cellSize.width * scale
            assetGridThumbnailSize = CGSize(width: size, height: size)
        }
	}
    
    // MARK: - AlbumToolbarViewDelegate
    func onFinishedButtonClicked() {
        if let nav = self.navigationController as? PhotoPickerController {
            
            nav.imageSelectFinish()
        }
    }
    //MARK:--- 导航栏
    fileprivate func configNavigationBar(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.main_1
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let cancelButton = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(PhotoCollectionViewController.eventCancel))
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    // MARK: -  cancel
    func eventCancel(){
        PhotoImage.instance.selectedImage.removeAll()
        
        onFinishedButtonClicked()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.updateCacheAssets()
	}
	
	// MARK: -   image caches
	fileprivate func resetCacheAssets() {
		self.imageManager.stopCachingImagesForAllAssets()
		self.previousPreheatRect = CGRect.zero
	}
	
	func updateCacheAssets() {
		let isViewVisible = self.isViewLoaded && self.view.window != nil;
		if !isViewVisible { return; }
		
		// The preheat window is twice the height of the visible rect.
		var preheatRect = self.collectionView?.bounds
		if preheatRect != nil {
			preheatRect = preheatRect!.insetBy(dx: 0, dy: -0.5 * preheatRect!.height) ;
			
			let delta = abs(preheatRect!.midY - self.previousPreheatRect!.midY)
			
			if (delta > self.collectionView!.bounds.height / 3.0) {
				
				var addedIndexPaths = [IndexPath]()
				var removedIndexPaths = [IndexPath]()
				self.computeDifferenceBetweenRect(self.previousPreheatRect!, newRect: preheatRect!, removedHandler: { [weak self](removedRect) -> Void in
						// somde code
						let indexPaths = self?.collectionView!.aapl_indexPathsForElementsInRect(removedRect)
						if indexPaths != nil {
							removedIndexPaths.append(contentsOf: indexPaths!)
						}
					}, addedHandler: { [weak self](addedRect) -> Void in
						
						let indexPaths = self?.collectionView!.aapl_indexPathsForElementsInRect(addedRect)
						if indexPaths != nil {
							addedIndexPaths.append(contentsOf: indexPaths!)
						}
					})
				
				let assetsToStartCaching = self.assetsAtIndexPaths(addedIndexPaths)
				let assetsToStopCaching = self.assetsAtIndexPaths(removedIndexPaths)
				
				if assetsToStartCaching != nil {
					self.imageManager.startCachingImages(for: assetsToStartCaching!, targetSize: self.assetGridThumbnailSize!, contentMode: .aspectFill, options: nil)
				}
				
				if assetsToStopCaching != nil {
					self.imageManager.stopCachingImages(for: assetsToStopCaching!, targetSize: self.assetGridThumbnailSize!, contentMode: .aspectFill, options: nil)
				}
				
				self.previousPreheatRect = preheatRect;
			}
		}
	}
    
    // MARK: -  PhotoCollectionViewCellDelegate
    func eventSelectNumberChange(_ number: Int) {
        if let toolbar = self.toolbar {
            toolbar.changeNumber(number)
        }
    }
    
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		self.updateCacheAssets()
	}
	
	func assetsAtIndexPaths(_ indexPaths: [IndexPath]) -> [PHAsset]? {
		if indexPaths.count == 0 { return nil; }
		var assets = [PHAsset]()
		for indexPath in indexPaths {
            assets.append(self.fetchResult![indexPath.item])
		}
		return assets;
	}
	
	func computeDifferenceBetweenRect(_ oldRect: CGRect, newRect: CGRect, removedHandler: (CGRect) -> Void, addedHandler: (CGRect) -> Void) {
		
		if newRect.intersects(oldRect) {
			let oldMaxY = oldRect.maxY
			let oldMinY = oldRect.maxX
			let newMaxY = newRect.maxY ;
			let newMinY = newRect.minY ;
			
			if newMaxY > oldMaxY {
				let rectToAdd = CGRect(x: newRect.origin.x, y: oldMaxY, width: newRect.size.width, height: (newMaxY - oldMaxY))
				addedHandler(rectToAdd)
			}
			
			if oldMinY > newMinY {
				let rectToAdd = CGRect(x: newRect.origin.x, y: newMinY, width: newRect.size.width, height: (oldMinY - newMinY))
				addedHandler(rectToAdd)
			}
			
			if newMaxY < oldMaxY {
				let rectToRemove = CGRect(x: newRect.origin.x, y: newMaxY, width: newRect.size.width, height: (oldMaxY - newMaxY))
				removedHandler(rectToRemove)
			}
			
			if oldMinY < newMinY {
				let rectToRemove = CGRect(x: newRect.origin.x, y: oldMinY, width: newRect.size.width, height: (newMinY - oldMinY))
				removedHandler(rectToRemove)
			}
		} else {
			addedHandler(newRect) ;
			removedHandler(oldRect) ;
		}
	}
	
	deinit {
		PHPhotoLibrary.shared().unregisterChangeObserver(self)
	}
	
	func photoLibraryDidChange(_ changeInstance: PHChange) {
		if let collectionChanges = changeInstance.changeDetails(for: self.fetchResult!) {
			
			DispatchQueue.main.async(execute: { [weak self]() -> Void in
					
					self?.fetchResult = collectionChanges.fetchResultAfterChanges
                
					let collectionView = self?.collectionView!;
					
					if !(collectionChanges.hasIncrementalChanges || collectionChanges.hasMoves) {
						collectionView?.reloadData()
					} else {
						collectionView?.performBatchUpdates({ () -> Void in
								if let removedIndexes = collectionChanges.removedIndexes {
									
									if removedIndexes.count > 0 {
										collectionView?.deleteItems(at: removedIndexes.aapl_indexPathsFromIndexesWithSection(0))
									}
								}
								
								if let insertedIndexes = collectionChanges.insertedIndexes {
									if insertedIndexes.count > 0 {
										collectionView?.insertItems(at: insertedIndexes.aapl_indexPathsFromIndexesWithSection(0))
									}
								}
							}, completion: nil)
					}
					
					self?.resetCacheAssets()
				})
		}
	}
	
	fileprivate func configBackground() {
		self.collectionView?.backgroundColor = UIColor.white
	}
	
	override init(collectionViewLayout layout: UICollectionViewLayout) {
		super.init(collectionViewLayout: layout)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	class func configCustomCollectionLayout() -> UICollectionViewFlowLayout {
		let collectionLayout = UICollectionViewFlowLayout()
		
		let width = UIScreen.main.bounds.width - PhotoPickerConfig.MinimumInteritemSpacing * 2
		collectionLayout.minimumInteritemSpacing = PhotoPickerConfig.MinimumInteritemSpacing
		
		let cellToUsableWidth = width - (PhotoPickerConfig.ColNumber - 1) * PhotoPickerConfig.MinimumInteritemSpacing
		let size = cellToUsableWidth / PhotoPickerConfig.ColNumber
		collectionLayout.itemSize = CGSize(width: size, height: size)
		collectionLayout.minimumLineSpacing = PhotoPickerConfig.MinimumInteritemSpacing
		return collectionLayout
	}
	
	// MARK: -  UICollectionView delegate
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.fetchResult != nil ? self.fetchResult!.count : 0
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! photoCollectionViewCell
		
		cell.delegate = self;
        cell.eventDelegate = self
        cell.model = self.fetchResult![indexPath.row]
        cell.representedAssetIdentifier = self.fetchResult![indexPath.row].localIdentifier
        self.imageManager.requestImage(for: self.fetchResult![indexPath.row], targetSize: self.assetGridThumbnailSize!, contentMode: .aspectFill, options: nil) { (image, info) -> Void in
            if cell.representedAssetIdentifier == self.fetchResult![indexPath.row].localIdentifier {
                cell.thumbnail.image = image
            }
        }
        cell.updateSelected(PhotoImage.instance.selectedImage.index(of: self.fetchResult![indexPath.row]) != nil)
		
		return cell
	}
	
	// MARK: UICollectionViewDelegate
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let previewController = PhotoPreviewViewController(nibName: nil, bundle: nil)
        previewController.allSelectImage = self.fetchResult as! PHFetchResult<PHObject>?
        previewController.currentPage = indexPath.row
        previewController.fromDelegate = self
        self.navigationController?.show(previewController, sender: nil)
	}
    
    func onPreviewPageBack() {
        self.collectionView?.reloadData()
        self.eventSelectNumberChange(PhotoImage.instance.selectedImage.count)
    }
}
