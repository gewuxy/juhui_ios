//
//  SP_PhotoPreviewCell.swift
//  IEXBUY
//
//  Created by sifenzi on 16/9/5.
//  Copyright © 2016年 IEXBUY. All rights reserved.
//

import UIKit

class SP_PhotoPreviewCell: UICollectionViewCell, UIScrollViewDelegate {

    var SP_PhotoPreviewCellBlock: (()->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    func configView() {
        self.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        //手势
        self.addGestureRecognizer(singleTap)
        self.addGestureRecognizer(doubleTap)
        
        SP_SVHUD.show()
        /*/self.addSubview(loadingView)
        self.scrollView.zoomScale = self.scrollView.minimumZoomScale
        self.imageView.center = CGPoint(x: self.bounds.width * 0.5, y: self.bounds.height * 0.5)
        self.imageView.bounds = CGRect(x: 0, y: 0, width: sp_ScreenWidth, height: sp_ScreenWidth)
        self.scrollView.contentSize = self.imageView.bounds.size*/
        
    }
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isMultipleTouchEnabled = true//多点触摸
        scrollView.bouncesZoom = true //NO时缩放不可超出最大最小缩放范围
        scrollView.scrollsToTop = false //控制控件滚动到顶部
        //self.scrollView!.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]//变换同等高度和宽度
        scrollView.delaysContentTouches = false//控制视图是否延时调用开始滚动的方法
        scrollView.canCancelContentTouches = true//控制控件是否接触取消touch的事件
        scrollView.alwaysBounceVertical = false //控制垂直方向遇到边框是否反弹
        return scrollView
    }()
    
    fileprivate lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.clipsToBounds = true
        return imgView
    }()
    
    fileprivate lazy var loadingView:SP_PhotoProgressView = {
        //加载进度
        let loadView = SP_PhotoProgressView()
        loadView.isHidden = false
        loadView.progress = 0.1
        let photoViewSize = self.bounds.size;
        loadView.center = CGPoint(x: photoViewSize.width * 0.5 , y: photoViewSize.height * 0.5)
        loadView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        return loadView
    }()
    fileprivate lazy var singleTap:UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(PhotoPreviewCell.singleTap(_:)))
        tap.require(toFail: self.doubleTap)
        return tap
    }()
    fileprivate lazy var doubleTap:UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(PhotoPreviewCell.doubleTap(_:)))
        tap.numberOfTapsRequired = 2
        return tap
    }()
    func singleTap(_ tap:UITapGestureRecognizer) {
        SP_PhotoPreviewCellBlock?()
    }
    
    
    var name:String = "" {
        didSet{
            imageView.sp_ImageName(name)
            setImageViewFrame(name)
        }
    }
    
    fileprivate func setImageViewFrame(_ url:String) {
        guard !url.isEmpty else {return}
        DispatchQueue.global().async {
            if let url = URL(string:url), let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data) ?? UIImage()
                DispatchQueue.main.async(execute: {
                    self.scrollView.zoomScale = self.scrollView.minimumZoomScale
                    
                    let imageSize = image.size
                    var fitSize = imageSize
                    fitSize.width = self.bounds.width
                    fitSize.height = fitSize.width / imageSize.width * imageSize.height
                    self.imageView.center = CGPoint(x: self.bounds.width * 0.5, y: self.bounds.height * 0.5)
                    self.imageView.bounds = CGRect(x: 0, y: 0, width: fitSize.width, height: fitSize.height)
                    self.scrollView.contentSize = self.imageView.bounds.size
                    SP_SVHUD.dismiss()
                })
            }
        }
    }
    
    //MARK:--- 缩放 -----------------------------
    func doubleTap(_ tap:UITapGestureRecognizer) {
        // 状态还原
        if self.scrollView.zoomScale == self.scrollView.minimumZoomScale {
            let tapPoint = tap.location(in: self)
            self.scrollView.zoom(to: CGRect(x: tapPoint.x, y: tapPoint.y, width: 1, height: 1), animated: true)
        } else {
            self.scrollView.setZoomScale(self.scrollView.minimumZoomScale, animated: true)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let contentSize = scrollView.contentSize
        let scrollViewSize = scrollView.bounds.size
        
        let centerX = scrollViewSize.width > contentSize.width ? scrollViewSize.width * 0.5 : contentSize.width * 0.5
        let centerY = scrollViewSize.height > contentSize.height ? scrollViewSize.height * 0.5 : contentSize.height * 0.5
        
        imageView.center = CGPoint(x: centerX, y: centerY)
        
    }

}
