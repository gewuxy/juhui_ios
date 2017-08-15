//
//  SP_ParentVC.swift
//  carpark
//
//  Created by 刘才德 on 2017/4/17.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//
/**
 在我大天朝，系统的导航栏无论怎么自定义都无法满足用户多姿多彩的需求。
 并且在系统导航栏之上自定义引发的诸多麻烦，会让你崩溃。
 因此最有效的解决办法就是，将系统导航栏彻底隐藏掉，用xib做了一个view代替导航栏。
 达到了随意修改，随意扩展，能应对客户诸般神奇的需求。
 同时直接继承于UITabViewController/UICollectionViewController的控制器
 应对客户后期需求的修改维护也不方便，
 因此也将舍弃VC直接继承UITabViewController/UICollectionViewController的做法。
 从而SP_ParentVC作为底层父控制器，之后所有控制器继承于SP_ParentVC。
 */

import UIKit

import CYLTableViewPlaceHolder
enum sp_PlaceHolderType {
    case tOnlyImage
    case tNoData(labTitle:String, btnTitle:String)
    case tNetError(labTitle:String)
}

class SP_ParentVC: UIViewController {
    
    var _placeHolderType = sp_PlaceHolderType.tOnlyImage {
        didSet{
            switch _placeHolderType {
            case .tOnlyImage:
                _placeHolderView.lab_title.text = ""
                _placeHolderView.btn_title.setTitle("", for: .normal)
            case .tNoData(let lab, let btn):
                _placeHolderView.lab_title.text = lab
                _placeHolderView.btn_title.setTitle(btn, for: .normal)
            case .tNetError(let lab):
                _placeHolderView.lab_title.text = lab
                if lab == My_NetCodeError.t需要登录.stringValue {
                    _placeHolderView.btn_title.setTitle(sp_localized("点我登录"), for: .normal)
                }else{
                    _placeHolderView.btn_title.setTitle(sp_localized("点击刷新"), for: .normal)
                }
                
            }
        }
    }
    lazy var _placeHolderView:SP_PlaceHolderView = {
        let view = SP_PlaceHolderView.show()
        view.lab_detalTitle_T.constant = 0
        view.lab_title.font = sp_fitFont20
        view.lab_title.textColor = UIColor.mainText_3
        view.btn_title.setTitleColor(UIColor.main_1, for: .normal)
        view.btn_title.titleLabel?.font = sp_fitFont20
        view._titleBlock = { [weak self]_ in
            self?.placeHolderViewClick()
        }
        return view
    }()
    
    
    lazy var n_view:SP_NavigationView = {
        let view = SP_NavigationView.show(self.view)
        view.backgroundColor = UIColor.white
        return view
    }()
    
    var _footRefersh = true//底部加载更多
    
    
    
}

extension SP_ParentVC:CYLTableViewPlaceHolderDelegate {
    func makePlaceHolderView() -> UIView! {
        return _placeHolderView
    }
    
//    func enableScrollWhenPlaceHolderViewShowing() -> Bool {
//        return true
//    }
    
    func placeHolderViewClick() {
        
    }
    
}



extension SP_ParentVC {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.main_bg
        self.navigationController?.isNavigationBarHidden = true
        //全屏幕右划返回，隐藏导航栏
        self.fd_prefersNavigationBarHidden = true
        sp_makeNaviDefault()
        n_view._clickBlock = { [unowned self]tag in
            switch tag {
            case 0:
                self.clickN_btn_L1()
            case 1:
                self.clickN_btn_L2()
            case 2:
                self.clickN_btn_C1()
            case 3:
                self.clickN_btn_R3()
            case 4:
                self.clickN_btn_R2()
            case 5:
                self.clickN_btn_R1()
            default:
                break
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.view.bringSubview(toFront: n_view)
        
        
    }
    //MARK:--- 设置各按钮默认值 -----------------------------
    open func sp_makeNaviDefault() {
        n_view._title = self.title ?? ""
        //NSLocalizedString("sp_key", tableName: "Localization",  comment: "")
        n_view._logoImage = ""
        n_view.n_btn_L1_Text = ""
        n_view.n_btn_L2_Text = ""
        n_view.n_btn_R1_Text = ""
        n_view.n_btn_R2_Text = ""
        n_view.n_btn_R3_Text = ""
        
        n_view.n_btn_L1_Image = sp_navigationViewLeftButtonImg
        n_view.n_btn_L2_Image = ""
        n_view.n_btn_R1_Image = ""
        n_view.n_btn_R2_Image = ""
        n_view.n_btn_R3_Image = ""
        n_view.n_view_ActShow = false
        
        
        n_view.n_view_NaviLine.isHidden = false
        
        n_view.backgroundColor = UIColor.main_1
        n_view._tintColor = UIColor.white
        n_view._titleColor = UIColor.white
    }
    //MARK:--- 响应事件
    open func clickN_btn_L1()  {
        if (navigationController?.popViewController(animated: true)) != nil {
            print("点击Button_L1返回")
        }else{
            print("点击Button_L1")
        }
    }
    
    open func clickN_btn_L2()  {
        print("点击Button_L2")
    }
    open func clickN_btn_R1()  {
        print("点击Button_R1")
    }
    open func clickN_btn_R2()  {
        print("点击Button_R2")
    }
    open func clickN_btn_R3()  {
        print("点击Button_R3")
    }
    open func clickN_btn_C1()  {
        print("点击Button_C1")
    }

}


