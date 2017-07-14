//
//  SP_PhotoBrowser.swift
//  IEXBUY
//
//  Created by sifenzi on 16/9/5.
//  Copyright © 2016年 IEXBUY. All rights reserved.
//

import UIKit

class SP_PhotoBrowser: UIViewController {
    //MARK:--- 提供调用接口 -----------------------------
    class func show(_ parentVC:UIViewController?, images:[String], index:Int, block:(()->Void)? = nil){
    
        let vc = SP_PhotoBrowser()
        vc.currentPage = index
        vc.selectImages = images
        vc._backBlock = block
        parentVC?.present(vc, animated: false) {}
    }
    //MARK:--- 主要参数 -----------------------------
    fileprivate let cellIdentifier = "cell_SP_PhotoBrowser"
    fileprivate var currentPage: Int = 0
    fileprivate var _backBlock:(()->Void)?
    fileprivate var selectImages:[String] = [] {
        didSet{
            collectionView.reloadData()
        }
    }
    //MARK:--- 主要控件 -----------------------------
    fileprivate lazy var collectionView: UICollectionView = {
        //self.automaticallyAdjustsScrollViewInsets = false
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: self.view.frame.width,height: self.view.frame.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionV = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionV.dataSource = self
        collectionV.delegate = self
        collectionV.isPagingEnabled = true
        collectionV.scrollsToTop = false
        collectionV.showsHorizontalScrollIndicator = false
        collectionV.contentOffset = CGPoint(x: 0, y: 0)
        collectionV.contentSize = CGSize(width: self.view.bounds.width * CGFloat(self.selectImages.count), height: self.view.bounds.height)
        
        
        collectionV.register(SP_PhotoPreviewCell.self, forCellWithReuseIdentifier: self.cellIdentifier)
        return collectionV
    }()
    fileprivate lazy var titleLab:UILabel = {
        let label = UILabel(frame: CGRect(x: (sp_ScreenWidth - 100)/2,y: 25,width: 100 ,height: 25))
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 17.0)
        return label
    }()
    fileprivate lazy var downBtn:UIButton = {
        let btn = UIButton(frame: CGRect(x: (sp_ScreenWidth - 100),y: 25,width: 100 ,height: 25))
        btn.setTitle("保存到相册", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        btn.addTarget(self, action: #selector(SP_PhotoBrowser.downBtnClick(_:)), for: .touchUpInside)
        
        return btn
    }()
    fileprivate lazy var backButton:UIButton = {
        let btn = UIButton(frame: CGRect(x: 10,y: 22,width: 30 ,height: 30))
        btn.setImage(UIImage(named:"photo_back" ), for: .normal)
        
        btn.addTarget(self, action: #selector(SP_PhotoBrowser.backClick), for: .touchUpInside)
        
        return btn
    }()
    fileprivate lazy var navigationView:UIView = {
        let bgView = UIView(frame: CGRect(x: 0,y: 0,width: self.view.frame.width ,height: 64))
        bgView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        
        bgView.addSubview(self.titleLab)
        bgView.addSubview(self.downBtn)
        bgView.addSubview(self.backButton)
        return bgView
    }()
    
    //MARK:--- 主要方法 -----------------------------
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
        
        setNavigationView()
        
        
    }
    func downBtnClick(_ button:UIButton) {
        guard self.selectImages[self.currentPage].hasPrefix("http://") || self.selectImages[self.currentPage].hasPrefix("https://") else {
            return
        }
        guard let data = try? Data(contentsOf: URL(string:self.selectImages[self.currentPage])!) else {
            return
        }
        let img = UIImage(data: data)!
        SP_SVHUD.show()
        self.downBtn.isEnabled = false
        PHPhotoLibrary.shared().performChanges({
            _ = PHAssetChangeRequest.creationRequestForAsset(from: img)
        }) { [weak self](isOk, error) in
            SP_SVHUD.dismiss()
            self?.downBtn.isEnabled = true
            if isOk {
                SP_SVHUD.show(.tSuccess,text:"已保存到相册")
            }else{
                SP_SVHUD.show(.tError,text:"保存失败，请重试")
                
            }
        }
    }
    func setCollectionView(){
        view.addSubview(self.collectionView)
    }
    
    func setNavigationView() {
        self.view.addSubview(navigationView)
        updatePageTitle()
        let indexPath = IndexPath(row: currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    func backClick() {
        SP_SVHUD.dismiss()
        _backBlock?()
        self.dismiss(animated: false) { 
            
        }
    }
    fileprivate func updatePageTitle(){
        self.titleLab.text =  String(self.currentPage+1) + "/" + String(self.selectImages.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
// MARK: -  collectionView dataSource delagate
extension SP_PhotoBrowser:UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! SP_PhotoPreviewCell
        
        cell.name = self.selectImages[indexPath.row]
        cell.SP_PhotoPreviewCellBlock = { _ in
            self.backClick()
        }
        return cell
    }
    // MARK: -  scroll page
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        self.currentPage = Int(offset.x / self.view.bounds.width)
        self.updatePageTitle()
    }
}
