//
//  SP_AddPhotoPickerVC.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/4.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import UIKit
import Photos

//var addPhoto_ParentVC:UIViewController?

class SP_AddPhotoPickerVC: UIViewController,PhotoPickerControllerDelegate {
    
    fileprivate var _imageDatas = [AnyObject]()
    var selectModel = [PhotoImageModel]()
    
    
    var containerView = UIView()
    var triggerRefresh = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.containerView)
        self.checkNeedAddButton()
        self.renderView()
    }
    //MARK:---- 添加一个添加图片按钮
    fileprivate func checkNeedAddButton(){
        if self.selectModel.count < PhotoPickerController.imageMaxSelectedNum && !hasButton() {
            selectModel.append(PhotoImageModel(type: ModelType.button, data: nil, imageData:nil))
        }
    }
    //MARK:---- 判断所有按钮中是否有添加按钮
    fileprivate func hasButton() -> Bool{
        for item in self.selectModel {
            if item.type == ModelType.button {
                return true
            }
        }
        return false
    }
    //MARK:---- 删除照片 -- 代理
    func removeElement(_ element: String?){
        if let localIdentifier = element {
            for (i,item) in self.selectModel.enumerated() {
                
                if item.data?.localIdentifier == localIdentifier {
                    self.selectModel.remove(at: i)
                    self.triggerRefresh = true
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.navigationBar.barStyle = .default
        
        if self.triggerRefresh {
            self.triggerRefresh = false
            self.updateView()
        }
        
    }
    
    fileprivate func updateView(){
        self.clearAll()
        self.checkNeedAddButton()
        self.renderView()
    }
    //MARK:---- 计算坐标
//    private func renderView(){
//        if selectModel.count <= 0 {return;}
//        
//        let totalWidth = UIScreen.mainScreen().bounds.width
//        let space:CGFloat = 10
//        let lineImageTotal = 4
//        
//        let line = self.selectModel.count / lineImageTotal
//        let lastItems = self.selectModel.count % lineImageTotal
//        
//        let lessItemWidth = (totalWidth - (CGFloat(lineImageTotal) + 1) * space)
//        let itemWidth = lessItemWidth / CGFloat(lineImageTotal)
//    }
    //MARK:---- 添加图片  按钮
    fileprivate func renderView(){
        
        if selectModel.count <= 0 {return;}
        
        let totalWidth = UIScreen.main.bounds.width
        let space:CGFloat = 10
        let lineImageTotal = 4
        
        let line = self.selectModel.count / lineImageTotal
        let lastItems = self.selectModel.count % lineImageTotal
        
        let lessItemWidth = (totalWidth - (CGFloat(lineImageTotal) + 1) * space)
        let itemWidth = lessItemWidth / CGFloat(lineImageTotal)
        
        
        
        
        for i in 0 ..< line {
            let itemY = CGFloat(i+1) * space + CGFloat(i) * itemWidth
            for j in 0 ..< lineImageTotal {
                let itemX = CGFloat(j+1) * space + CGFloat(j) * itemWidth
                let index = i * lineImageTotal + j
                self.renderItemView(itemX, itemY: itemY, itemWidth: itemWidth, index: index)
            }
        }
        
        // last line
        for i in 0 ..< lastItems {
            let itemX = CGFloat(i+1) * space + CGFloat(i) * itemWidth
            let itemY = CGFloat(line+1) * space + CGFloat(line) * itemWidth
            let index = line * lineImageTotal + i
            self.renderItemView(itemX, itemY: itemY, itemWidth: itemWidth, index: index)
        }
        
        let totalLine = ceil(Double(self.selectModel.count) / Double(lineImageTotal))
        let containerHeight = CGFloat(totalLine) * itemWidth + (CGFloat(totalLine) + 1) *  space
        self.containerView.frame = CGRect(x: 0, y: 0, width: totalWidth,  height: containerHeight)
    }
    //MARK:---- 根据坐标 设置按钮
    fileprivate func renderItemView(_ itemX:CGFloat,itemY:CGFloat,itemWidth:CGFloat,index:Int){
        let itemModel = self.selectModel[index]
        let button = UIButton(frame: CGRect(x: itemX, y: itemY, width: itemWidth, height: itemWidth))
        //button.backgroundColor = UIColor.redColor()
        button.tag = index
        
        if itemModel.type == ModelType.button {
            button.backgroundColor = UIColor.clear
            button.addTarget(self, action: #selector(SP_AddPhotoPickerVC.eventAddImage), for: .touchUpInside)
            button.contentMode = .scaleAspectFill
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
            button.setImage(UIImage(named: "image_select"), for: UIControlState())
        } else {
            button.addTarget(self, action: #selector(SP_AddPhotoPickerVC.eventPreview(_:)), for: .touchUpInside)
            
            if (itemModel.data != nil) {
                if let asset = itemModel.data {
                    let pixSize = UIScreen.main.scale * itemWidth
                    PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: pixSize, height: pixSize), contentMode: PHImageContentMode.aspectFill, options: nil, resultHandler: { (image, info) -> Void in
                        if image != nil {
                            button.setImage(image, for: UIControlState())
                            button.contentMode = .scaleAspectFill
                            button.clipsToBounds = true
                        }
                    })
                }
            }else{
                button.setImage(UIImage(data: itemModel.imageData! as Data), for: UIControlState())
                button.contentMode = .scaleAspectFill
                button.clipsToBounds = true
            }
            
        }
        self.containerView.addSubview(button)
    }
    //MARK:---- 删除所有按钮
    fileprivate func clearAll(){
        for subview in self.containerView.subviews {
            if let view =  subview as? UIButton {
                view.removeFromSuperview()
            }
        }
    }
    
    //MARK:----  图片浏览
    func eventPreview(_ button:UIButton){
        let preview = SinglePhotoPreviewViewController()
        let data = self.getModelExceptButton()
        preview.selectImages = data
        preview.sourceDelegate = self
        preview.currentPage = button.tag
        self.show(preview, sender: nil)
    }
    
    //MARK:---- 触发添加按钮
    func eventAddImage() {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // change the style sheet text color
        //alert.view.tintColor = UIColor.blackColor()
        
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
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
     //MARK:---- 拍照获取
    fileprivate func selectByCamera(){
        if cameraPermissions() {
            /*
            let view = SP_ImagePickerView.init(frame: SP_MainWindow.bounds, parentVC: self)
            self.view.addSubview(view)
            view._picker.allowsEditing = false
            view.addCarema()
            view.lcd_ImagePickerClosures = { [weak self](image,imageData,fileUrl) in
                
                self?.selectModel.insert(PhotoImageModel(type: ModelType.image, data: nil, imageData:imageData), at: 0)
                self?.renderView()
            }*/
        }
        
    }
    //MARK:---- 判断相机权限
    func cameraPermissions() -> Bool{
        
        let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if(authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted) {
            let alert = UIAlertController.init(title: nil, message: "没有打开相机的权限", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }else {
            return true
        }
        
    }
    //MARK:----从相册中选择图片
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
    
    fileprivate func showNoPermissionDailog(){
        let alert = UIAlertController.init(title: nil, message: "没有打开相册的权限", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
     //MARK:---- 打开相册
    fileprivate func showLocalPhotoGallery(){
        let picker = PhotoPickerController(type: PageType.recentAlbum)
        picker.imageSelectDelegate = self
        picker.modalPresentationStyle = .popover
        
        // max select number
        PhotoPickerController.imageMaxSelectedNum = 4
        
        // already selected image num
        let realModel = self.getModelExceptButton()
        PhotoPickerController.alreadySelectedImageNum = realModel.count
        
        self.show(picker, sender: nil)
    }
    //MARK:---- PhotoPickerControllerDelegate
    func onImageSelectFinished(_ images: [PHAsset]) {
        self.renderSelectImages(images)
    }
    //MARK:---- 图片数据处理 转模型
    fileprivate func renderSelectImages(_ images: [PHAsset]){
        for item in images {
            self.selectModel.insert(PhotoImageModel(type: ModelType.image, data: item, imageData:nil), at: 0)
        }
        
        if self.selectModel.count > PhotoPickerController.imageMaxSelectedNum {
            for (i,item) in self.selectModel.enumerated() {
                if item.type == .button {
                    self.selectModel.remove(at: i)
                }
            }
        }
        self.renderView()
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
    
}

