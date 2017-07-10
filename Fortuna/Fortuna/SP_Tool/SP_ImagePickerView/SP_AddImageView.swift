//
//  SP_AddImageView.swift
//  IEXBUY
//
//  Created by sifenzi on 16/6/30.
//  Copyright © 2016年 IEXBUY. All rights reserved.
//

import UIKit
import Photos

//enum AddImageViewType {
//    case Default
//    case LimitThree
//}
//enum SelectCameraOrPhoto {
//    case Camera
//    case Photo
//}



class SP_AddImageView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PhotoPickerControllerDelegate {

    weak var _parentVC: UIViewController?
    //private var _selectCameraOrPhoto:SelectCameraOrPhoto = .Photo
    
    fileprivate var _imageDatas = [AnyObject]()
    fileprivate var _maxNumber = 3
    fileprivate var _selectNumber = 3
    fileprivate var _selectNum:Int {
        get{
            return _selectNumber
        }
        set{
            _selectNumber = newValue
        }
    }
    
    fileprivate let _layout = UICollectionViewFlowLayout()
    fileprivate var collectionView: UICollectionView!
    fileprivate var _frame = CGRect.zero
    //private var _strategyType:AddImageViewType?
    
    
    init(frame: CGRect, parentVC:UIViewController,maxNumber:Int = 3) {
        super.init(frame: frame)
        _imageDatas.removeAll()
        _frame = frame
        _parentVC = parentVC
        _maxNumber = maxNumber
        _selectNum = maxNumber
        setCollectionView()
    }
    fileprivate func setCollectionView() {
        collectionView =  UICollectionView(frame:_frame, collectionViewLayout: _layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource  = self
        collectionView.delegate = self
        addSubview(collectionView)
        collectionView.showsVerticalScrollIndicator   = false  //隐藏滑动条
        collectionView.showsHorizontalScrollIndicator = false
        _layout.scrollDirection = .horizontal
        _layout.itemSize = CGSize(width: _frame.size.height, height: _frame.size.height)
        _layout.minimumLineSpacing      = 5.0
        _layout.minimumInteritemSpacing = 5.0
        
        
        collectionView.register(UINib(nibName: "AS_AddImageCell", bundle: nil), forCellWithReuseIdentifier: "AS_AddImageCell")
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if _imageDatas.count < _maxNumber {
            return _imageDatas.count + 1
        }
        return _imageDatas.count
        
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = AS_AddImageCell.dequeueReusableCell(collectionView, indexPath: indexPath)
        
        if indexPath.row ==  _imageDatas.count{
            cell.removeBtn.isHidden = true
            cell.addBtn.isHidden = false
            cell.addBtn.isEnabled = true
            cell.image.image = UIImage(named: "image_add")
            cell.addBtn.addTarget(self, action: #selector(SP_AddImageView.addImageBtnClick(_:)), for: .touchUpInside)
        }else{
            cell.removeBtn.isHidden = false
            cell.addBtn.isHidden = true
            cell.addBtn.isEnabled = false
            
            if _imageDatas[indexPath.row] is Data  {
                cell.image.image = UIImage(data: _imageDatas[indexPath.row] as! Data)
            }else if _imageDatas[indexPath.row] is PHAsset {
                let asset = _imageDatas[indexPath.row] as! PHAsset
                
                let pixSize = UIScreen.main.scale * 80
                PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: pixSize, height: pixSize), contentMode: PHImageContentMode.aspectFill, options: nil, resultHandler: { (image, info) -> Void in
                    if image != nil {
                        cell.image.image = image
                    }
                })
            }
            //cell.bringSubviewToFront(cell.removeBtn)
            cell.removeBtn.tag = indexPath.row
            cell.removeBtn.addTarget(self, action: #selector(SP_AddImageView.removeBtnClick(_:)), for: .touchUpInside)
            
        }
        
        
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    //MARK:---- 删除图片
    func removeBtnClick(_ button:UIButton) {
        print(button.tag)
        _imageDatas.remove(at: button.tag)
        collectionView.reloadData()
        
    }
    //MARK:---- 添加图片
    func addImageBtnClick(_ button:UIButton) {
        eventAddImage()
    }
    //MARK:---- 触发添加按钮
    func eventAddImage() {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // change the style sheet text color
        //alert.view.tintColor = UIColor.main_1
        let actionCancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let actionCamera = UIAlertAction.init(title: "拍照", style: .default) { (UIAlertAction) -> Void in
            self.selectByCamera()
        }
        let actionPhoto = UIAlertAction.init(title: "图片库", style: .default) { (UIAlertAction) -> Void in
            self.selectFromPhoto()
        }
        
        alert.addAction(actionCancel)
        alert.addAction(actionCamera)
        alert.addAction(actionPhoto)
        
        _parentVC?.present(alert, animated: true, completion: nil)
    }
    
    /**
     拍照获取
     */
    fileprivate func selectByCamera(){
        /*
        let view = SP_ImagePickerView(frame: _parentVC!.view.bounds, parentVC: _parentVC!)
        _parentVC?.view.addSubview(view)
        view._picker.allowsEditing = false
        view.addCarema()
        view.lcd_ImagePickerClosures = { [weak self](image,imageData,fileUrl) in
            self?._imageDatas.append(imageData as AnyObject)
            
            self?.collectionView.reloadData()
            let indexPath = IndexPath(row: self?._imageDatas.count ?? 0, section: 0)
            
            self?.collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
            
        }
        
        self._selectNum = self._selectNum - _imageDatas.count*/
    }
    
    /**
     从相册中选择图片
     */
    fileprivate func selectFromPhoto(){
        
        PHPhotoLibrary.requestAuthorization { [weak self](status) -> Void in
            switch status {
            case .authorized:
                self?.showLocalPhotoGallery()
                break
            default:
                self?.showNoPermissionDailog()
                break
            }
        }
    }
    //MARK:---- 没有相册权限
    fileprivate func showNoPermissionDailog(){
        let alert = UIAlertController.init(title: nil, message: "没有打开相册的权限", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: nil))
        _parentVC?.present(alert, animated: true, completion: nil)
    }
    
    //MARK:---- 打开相册
    
    fileprivate func showLocalPhotoGallery(){
        
        let picker = PhotoPickerController(type: PageType.list)
        picker.imageSelectDelegate = self
        picker.modalPresentationStyle = .popover
        PhotoPickerController.imageMaxSelectedNum = _selectNum
        PhotoPickerController.alreadySelectedImageNum = _imageDatas.count
        _parentVC?.show(picker, sender: nil)
        
    }
    //MARK:---- PhotoPickerControllerDelegate
    func onImageSelectFinished(_ images: [PHAsset]) {
        self.renderSelectImages(images)
    }
    //MARK:---- 图片数据处理 转模型
    var selectModel = [PhotoImageModel]()
    fileprivate func renderSelectImages(_ images: [PHAsset]){
        for item in images {
            self.selectModel.insert(PhotoImageModel(type: ModelType.image, data: item, imageData:nil), at: 0)
            
            _imageDatas.append(PhotoImageModel(type: ModelType.image, data: item, imageData:nil).data!)
            
            //let asset = PhotoImageModel(type: ModelType.Image, data: item, imageData:nil).data!
            
//            var representation =  asset.defaultRepresentation()
//            var imageBuffer = UnsafeMutablePointer<UInt8>.alloc(Int(representation.size()))
//            var bufferSize = representation.getBytes(imageBuffer, fromOffset: Int64(0), length: Int(representation.size()), error: nil)
//            var data:NSData =  NSData(bytesNoCopy:imageBuffer ,length:bufferSize, freeWhenDone:true)
            
//            PHCachingImageManager().requestAVAssetForVideo(asset, options: nil, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [NSObject : AnyObject]?) in
//                dispatch_async(dispatch_get_main_queue(), {
//                    
//                    let asset = asset as? AVURLAsset
//                    let data = NSData(contentsOfURL: asset!.URL)
//                    self._imageDatas.append(data!)
//                })
//            })
            
            
            
//            let pixSize = UIScreen.mainScreen().scale * 80
//            PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(pixSize, pixSize), contentMode: PHImageContentMode.AspectFill, options: nil, resultHandler: { [weak self](image, info) -> Void in
//                if image != nil {
//                    let asset = asset as? AVURLAsset
//                    let data = NSData(contentsOfURL: asset!.URL)
//                    //let imageData = SP_ImageUnit.transferToNetworkImageFrom(image!)
//                    self._imageDatas.append(data!)
//                }
//            })
            
        }
        
        if self.selectModel.count > PhotoPickerController.imageMaxSelectedNum {
            for (i,item) in self.selectModel.enumerated() {
                if item.type == .button {
                    self.selectModel.remove(at: i)
                }
            }
        }
        
        
//        for item in self.selectModel {
//            if item.data != nil {
//                _imageDatas.append(item.data!)
//            }
//            
//        }
        
        collectionView.reloadData()
        if _imageDatas.count < _maxNumber {
            let indexPath = IndexPath(row: _imageDatas.count, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        }else{
            let indexPath = IndexPath(row: _imageDatas.count - 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        }
        
        
    }
    //MARK:---- 提取图片
    fileprivate func getModelExceptButton()->[PhotoImageModel]{
        var newModels = [PhotoImageModel]()
        for (_,item) in self.selectModel.enumerated() {
            if item.type != .button {
                newModels.append(item)
            }
        }
        return newModels
    }
    
    /*/MARK:----------- 选择后的照片数据传回
    func onImageSelectFinished(imagess: [PHAsset]) ->Void {
        print("-----》\(imagess.count)")
        var photoimages = [PhotoImageModel]()
        photoimages.removeAll()
        for item in imagess {
            photoimages.append(PhotoImageModel(type: ModelType.Image, data: item))
        }
        
//        if images.count > PhotoPickerController.imageMaxSelectedNum {
//            for i in 0 ..< images.count {
//                let item = photoimages[i]
//                if item.type == .Button {
//                    photoimages.removeAtIndex(i)
//                }
//            }
//        }
        
        print("-----》》\(photoimages.count)")
        
        var first = true
        
        for itemModel in photoimages {
            guard let asset = itemModel.data else{return}
            
            let pixSize = UIScreen.mainScreen().scale * _frame.size.height
            PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(pixSize, pixSize), contentMode: PHImageContentMode.AspectFill, options: nil, resultHandler: { [weak self](image, info) -> Void in
                guard image != nil else{return}
                if !first {
                    first = true
                    let docData = SP_ImageUnit.transferToNetworkImageFrom(image!)
                    self._imageDatas.append(docData)
                    print("----1-》\(self._imageDatas.count)")
                    self.collectionView.reloadData()
                    self._selectNum = self._selectNum - self._imageDatas.count
                }else{
                    first = false
                }
                
            })
            
            print("----3-》\(self._imageDatas.count)")
        }
        
        print("----4-》\(self._imageDatas.count)")
        
        
    }
    *///MARK:---- 排列图片 --
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
    }
    */

}
