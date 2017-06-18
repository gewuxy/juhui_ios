//
//  JH_NewsDetials.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/13.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import WebKit
import IMYWebView
import WebViewJavascriptBridge
class JH_NewsDetials: SP_ParentVC {

    lazy var _wkwebView: IMYWebView = {
        let webView = IMYWebView()
        return webView
    }()
    
    lazy var _bridge: WebViewJavascriptBridge = {
        return WebViewJavascriptBridge(forWebView: self._wkwebView)
    }()
}

extension JH_NewsDetials {
    override class func initSPVC() -> JH_NewsDetials {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_NewsDetials") as! JH_NewsDetials
    }
    class func show(_ parentVC:UIViewController?) {
        let vc = JH_NewsDetials.initSPVC()
        vc.hidesBottomBarWhenPushed = true
        parentVC?.navigationController?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeWebView()
        
        
    }
    fileprivate func makeWebView() {
        self.view.addSubview(_wkwebView)
        _wkwebView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(64)
            make.leading.trailing.bottom.equalToSuperview()
        }
        _wkwebView.load(URLRequest(url: URL(string: "http://baidu.com")!))
        
        
    }
    
}
