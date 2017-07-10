//
//  SP_AddPhotoVC.swift
//  carpark
//
//  Created by 刘才德 on 2017/2/22.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import Photos
class SP_PhotoManager {
    private static let sharedInstance = SP_PhotoManager()
    private init() {}
    //提供静态访问方法
    open static var shared: SP_PhotoManager {
        return self.sharedInstance
    }
    
    var imagePngDatas = [Data]()
    var imageJpgDatas = [Data]()
    var imageStrings = [String]()
    var imageUIs = [UIImage]()
    
    func removeAll(){
        imagePngDatas.removeAll()
        
        imageJpgDatas.removeAll()
        
        imageStrings.removeAll()
        
        imageUIs.removeAll()
    }
}
class SP_AddPhoto:UIView,UINavigationControllerDelegate {

    var sp_AddPhotoBlock:(() ->Void)?
    weak var _parentVC:UIViewController?
    var _alertTextColor = UIColor.main_1
    
    var _imageZip = true
    var _maxNumber = 3
    var _selectNumber = 3
    var _selectNum:Int {
        get{
            return _selectNumber
        }
        set{
            _selectNumber = newValue
        }
    }
    //相册多选
    var _selectModel = [PhotoImageModel]()
    
    lazy var _picker:UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        return UIImagePickerController()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, parentVC:UIViewController?) {
        super.init(frame: frame)
        _parentVC = parentVC
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:--- HXPhotoView
    lazy var photoView:HXPhotoView = {
        let photo = HXPhotoView(frame: CGRect(x:0,y:0,width:sp_ScreenWidth,height:300), with: self.manager)
        photo?.delegate = self
        photo?.backgroundColor = UIColor.white
        photo?.isHidden = true
        return photo!
    }()
    
    lazy var manager:HXPhotoManager = {
        let man = HXPhotoManager(type: HXPhotoManagerSelectedTypePhotoAndVideo)
        man?.outerCamera = true
        man?.openCamera = false
        man?.maxNum = self._maxNumber
        man?.photoMaxNum = self._maxNumber
        return man!
    }()
    
    
    //MARK:---- alert
    func show() {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // change the style sheet text color
        alert.view.tintColor = _alertTextColor
        let actionCancel = UIAlertAction.init(title: "取消", style: .cancel) { (UIAlertAction) -> Void in
            self.removeFromSuperview()
        }
        let actionCamera = UIAlertAction.init(title: "拍照", style: .default) { (UIAlertAction) -> Void in
            self.selectByCamera()
        }
        let actionPhoto = UIAlertAction.init(title: "从相册选择", style: .default) { (UIAlertAction) -> Void in
            self.selectFromPhoto()
        }
        
        alert.addAction(actionCancel)
        alert.addAction(actionCamera)
        alert.addAction(actionPhoto)
        
        _parentVC?.present(alert, animated: true, completion: nil)
    }
    //MARK:--- 拍照获取
    func selectByCamera(){
        SP_PhotoManager.shared.removeAll()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            _picker.delegate = self
            _picker.sourceType = .camera
            _parentVC?.present(_picker, animated: true, completion: nil)
        }else{
            let aler = UIAlertController(title: "温馨提示", message: "您的设备没有相机", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "确定", style: .cancel, handler: { (UIAlertAction) in
                
            })
            aler.addAction(cancel)
            _parentVC?.present(aler, animated: true, completion: nil)
        }
        
    }
    
    //MARK:--- 从相册中选择图片
    func selectFromPhoto(){
        SP_PhotoManager.shared.removeAll()
        if _maxNumber == 1 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
            {
                _picker.delegate = self
                _picker.sourceType = .photoLibrary
                _parentVC?.present(_picker, animated:true, completion:nil)
            }else{
                self.showNoPermissionDailog()
            }
        }else{
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
    }
    //MARK:---- 打开相册
    fileprivate func showLocalPhotoGallery(){
        //_parentVC?.view.addSubview(self.photoView)
//        self.addSubview(self.photoView)
//        self.manager.endSelectedPhotos.removeAllObjects()
//        self.manager.emptySelectedList()
//        self.manager.outerCamera = true
//        self.photoView.goController()
        
        
        let picker = PhotoPickerController(type: PageType.allAlbum)
        //picker.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        picker.imageSelectDelegate = self
        picker.modalPresentationStyle = .popover
        
        PhotoPickerController.imageMaxSelectedNum = _maxNumber
        PhotoPickerController.alreadySelectedImageNum = 0
        _parentVC?.show(picker, sender: nil)
        
    }
    //MARK:---- 没有相册权限
    fileprivate func showNoPermissionDailog(){
        let alert = UIAlertController.init(title: "没有打开相册的权限", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction.init(title: "确定", style: .default, handler: { (UIAlertAction) in
            self.removeFromSuperview()
        })
        let open = UIAlertAction(title: "开启", style: .default, handler: { (UIAlertAction) in
            UIApplication.shared.openURL(URL(string: "prefs:root=Privacy")!)
        })
        alert.addAction(cancel)
        alert.addAction(open)
        _parentVC?.present(alert, animated: true, completion: nil)
    }
    //MARK:---- 判断相机权限
    func cameraPermissions() -> Bool{
        
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if(authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted) {
            let alert = UIAlertController.init(title: "没有打开相机的权限", message: nil, preferredStyle: .alert)
            let cancel = UIAlertAction.init(title: "确定", style: .default, handler: { (UIAlertAction) in
                self.removeFromSuperview()
            })
            let open = UIAlertAction(title: "开启", style: .default, handler: { (UIAlertAction) in
                UIApplication.shared.openURL(URL(string: "prefs:root=Privacy")!)
            })
            alert.addAction(cancel)
            alert.addAction(open)
            _parentVC?.present(alert, animated: true, completion: nil)
            return false
        }else {
            return true
        }
        
    }
    
    
    
}
//MARK:---- PhotoPickerControllerDelegate
extension SP_AddPhoto:PhotoPickerControllerDelegate {
    func onImageSelectFinished(_ images: [PHAsset]) {
        print_SP(images.count)
        
        for item in images {
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            options.deliveryMode = .fastFormat
            options.resizeMode = .exact
            /*
             PHImageManager.default().requestImageData(for: model.asset, options: options, resultHandler: { [weak self](data, str, ii, dat) in
             self?._inputImgDatas.append(data!)
             })*/
            
            PHImageManager.default().requestImage(for: item, targetSize: CGSize(width: item.pixelWidth, height: item.pixelHeight), contentMode: .aspectFit, options: options, resultHandler: { [weak self](image, dact) in
                guard self != nil else{return}
                SP_PhotoManager.shared.imagePngDatas.append(SP_ImageUnit.toPngData(image!, isZip: self!._imageZip))
                SP_PhotoManager.shared.imageJpgDatas.append(SP_ImageUnit.toJpgData(image!, isZip: self!._imageZip))
                SP_PhotoManager.shared.imageStrings.append(SP_ImageUnit.toBase64String(image!, isZip: self!._imageZip))
                SP_PhotoManager.shared.imageUIs.append(image!)
            })
        }
        self.sp_AddPhotoBlock?()
        SP_MBHUD.hideHUD()
        self.removeFromSuperview()
        
//        _picker.dismiss(animated: true) {
//
//        }
        
        //self.renderSelectImages(images)
    }
    //MARK:---- 图片数据处理 转模型
    fileprivate func renderSelectImages(_ images: [PHAsset]){
        for item in images {
            self._selectModel.insert(PhotoImageModel(type: ModelType.image, data: item, imageData:nil), at: 0)
        }
        
        if self._selectModel.count > PhotoPickerController.imageMaxSelectedNum {
            for (i,item) in self._selectModel.enumerated() {
                if item.type == .button {
                    self._selectModel.remove(at: i)
                }
            }
        }
        //self.renderView()
    }
    
}
//MARK:---------- UIImagePickerControllerDelegate
extension SP_AddPhoto:UIImagePickerControllerDelegate {
    /*
     ["UIImagePickerControllerCropRect": NSRect: {{0, 248}, {640, 640}},
     "UIImagePickerControllerOriginalImage": <UIImage: 0x130b9cbd0> size {640, 1136} orientation 0 scale 1.000000,
     "UIImagePickerControllerReferenceURL": assets-library://asset/asset.PNG?id=07C3790B-04DE-460C-A756-67967E482A6F&ext=PNG,
     "UIImagePickerControllerMediaType": public.image,
     "UIImagePickerControllerEditedImage": <UIImage: 0x130bafb80> size {640, 640} orientation 0 scale 1.000000]
     */
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        guard let path = info[UIImagePickerControllerMediaType] as? String, path == "public.image" else {
            let alert = UIAlertController.init(title: nil, message: "您选择的不是图片！", preferredStyle: .alert)
            alert.view.tintColor = _alertTextColor
            alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (UIAlertAction) in
                self.removeFromSuperview()
            }))
            _parentVC?.present(alert, animated: true, completion: nil)
            return
        }
        
        var myImage:UIImage?
        if picker.allowsEditing {
            guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else{
                let alert = UIAlertController.init(title: nil, message: "对不起！出错了！", preferredStyle: .alert)
                
                // change the style sheet text color
                alert.view.tintColor = _alertTextColor
                
                let actionCamera = UIAlertAction.init(title: "哥不玩了", style: .default) { (UIAlertAction) -> Void in
                    picker.dismiss(animated: true) {
                        self.removeFromSuperview()
                    }
                }
                let actionCancel = UIAlertAction.init(title: "原谅你", style: .cancel, handler: nil)
                alert.addAction(actionCamera)
                alert.addAction(actionCancel)
                _parentVC?.present(alert, animated: true, completion: nil)
                return
            }
            myImage = image
        }else{
            guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else{
                let alert = UIAlertController.init(title: nil, message: "对不起！出错了！", preferredStyle: .alert)
                
                // change the style sheet text color
                alert.view.tintColor = _alertTextColor
                let actionCamera = UIAlertAction.init(title: "哥不玩了", style: .default) { (UIAlertAction) -> Void in
                    picker.dismiss(animated: true) {
                        self.removeFromSuperview()
                    }
                }
                let actionCancel = UIAlertAction.init(title: "原谅你", style: .cancel, handler: { (UIAlertAction) in
                    self.removeFromSuperview()
                })
                alert.addAction(actionCamera)
                alert.addAction(actionCancel)
                
                _parentVC?.present(alert, animated: true, completion: nil)
                return
            }
            myImage = image
        }
        
        SP_PhotoManager.shared.imagePngDatas.append(SP_ImageUnit.toPngData(myImage!, isZip: _imageZip))
        SP_PhotoManager.shared.imageJpgDatas.append(SP_ImageUnit.toJpgData(myImage!, isZip: _imageZip))
        SP_PhotoManager.shared.imageStrings.append(SP_ImageUnit.toBase64String(myImage!, isZip: _imageZip))
        SP_PhotoManager.shared.imageUIs.append(myImage!)
        self.sp_AddPhotoBlock?()
        SP_MBHUD.hideHUD()
        picker.dismiss(animated: true) {
            self.removeFromSuperview()
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.removeFromSuperview()
        }
    }
    
}


extension SP_AddPhoto:HXPhotoViewDelegate{
    public func photoViewChangeComplete(_ allList: [HXPhotoModel]!, photos: [HXPhotoModel]!, videos: [HXPhotoModel]!, original isOriginal: Bool) {
        
        for item in photos {
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .exact
            PHImageManager.default().requestImage(for: item.asset, targetSize: CGSize(width: item.asset.pixelWidth, height: item.asset.pixelHeight), contentMode: .aspectFit, options: options, resultHandler: { [weak self](image, dact) in
                guard self != nil else{return}
                SP_PhotoManager.shared.imagePngDatas.append(SP_ImageUnit.toPngData(image!, isZip: self!._imageZip))
                SP_PhotoManager.shared.imageJpgDatas.append(SP_ImageUnit.toJpgData(image!, isZip: self!._imageZip))
                SP_PhotoManager.shared.imageStrings.append(SP_ImageUnit.toBase64String(image!, isZip: self!._imageZip))
                SP_PhotoManager.shared.imageUIs.append(image!)
            })
        }
        self.sp_AddPhotoBlock?()
        SP_MBHUD.hideHUD()
        self.removeFromSuperview()
    }

    
    
    func photoViewUpdateFrame(_ frame: CGRect, with view: UIView!) {
        photoView.frame = frame
    }
}
