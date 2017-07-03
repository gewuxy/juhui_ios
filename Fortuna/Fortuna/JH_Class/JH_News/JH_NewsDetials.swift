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
import RxCocoa
import RxSwift
class JH_NewsDetials: SP_ParentVC {

    let disposeBag = DisposeBag()
    lazy var _wkwebView: IMYWebView = {
        let webView = IMYWebView()
        webView.delegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        return webView
    }()
    
    lazy var _bridge: WebViewJavascriptBridge = {
        return WebViewJavascriptBridge(forWebView: self._wkwebView)
    }()
    @IBOutlet weak var view_progress: UIProgressView!
    
    deinit {
        _wkwebView.removeObserver(self, forKeyPath: "estimatedProgress")
        _wkwebView.delegate = nil
    }
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
        makeUI()
        makeWebView()
        
        
    }
    fileprivate func makeUI() {
        n_view.n_btn_R1_Image = "Attention分享"
        n_view.n_btn_R1_R.constant = 15
    }
    override func clickN_btn_R1() {
        
        SP_UMView.show({ [unowned self](type) in
            SP_UMShare.shared.showDefault(self,viewType:.tCustom(platformType: type), shareTitle: "巨汇", shareText: "点击查看详情", shareImage: "http://v1.qzone.cc/pic/201306/29/10/56/51ce4cd6e7eb1111.jpg%21600x600.jpg", shareURL: "http://v1.qzone.cc/pic/201306/29/10/56/51ce4cd6e7eb1111.jpg%21600x600.jpg",  block: { (isOk) in
                
            })
        })
    }
    
    fileprivate func makeWebView() {
        view_progress.isHidden = true
        view_progress.progress = 0.0
        self.view.addSubview(_wkwebView)
        _wkwebView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(64)
            make.leading.trailing.bottom.equalToSuperview()
        }
        _wkwebView.load(URLRequest(url: URL(string: "http://baidu.com")!))
        
        //[self.myWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress"{
            view_progress.isHidden = false
            view_progress.progress = Float(_wkwebView.estimatedProgress)
            
            if _wkwebView.estimatedProgress >= 1.0 {
                view_progress.isHidden = true
                view_progress.progress = 0.0
                
            }
        }
    }
    
}



extension JH_NewsDetials:IMYWebViewDelegate {
    func webViewDidStartLoad(_ webView: IMYWebView!) {
        print(webView.estimatedProgress)
    }
    func webViewDidFinishLoad(_ webView: IMYWebView!) {
        print(webView.estimatedProgress)
    }
    func webView(_ webView: IMYWebView!, didFailLoadWithError error: Error!) {
        print(webView.estimatedProgress)
    }
    
}


