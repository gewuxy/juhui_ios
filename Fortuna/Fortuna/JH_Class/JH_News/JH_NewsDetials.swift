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
    var _datas = M_News()
    deinit {
        _wkwebView.removeObserver(self, forKeyPath: "estimatedProgress")
        _wkwebView.delegate = nil
    }
}

extension JH_NewsDetials {
    override class func initSPVC() -> JH_NewsDetials {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_NewsDetials") as! JH_NewsDetials
    }
    class func show(_ parentVC:UIViewController?, data:M_News) {
        let vc = JH_NewsDetials.initSPVC()
        vc._datas = data
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
        n_view._title = _datas.title
    }
    override func clickN_btn_R1() {
        
        SP_UMView.show({ [unowned self](type) in
            SP_UMShare.shared.showDefault(self,viewType:.tCustom(platformType: type), shareTitle: self._datas.title, shareText: self._datas.text, shareImage: self._datas.thumb_img, shareURL: self._datas.href,  block: { (isOk) in
                
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
        let strUrl = "<html><head><style type=\"text/css\">body{ font-size:50px;} img{width: 100%;height: auto;} </style><title>巨汇</title></head><body>" + _datas.article + "</body></html>"
        _wkwebView.loadHTMLString(strUrl, baseURL: nil)
        /*
        guard _datas.href.hasPrefix("http://") || _datas.href.hasPrefix("https://") else {
            return
        }
        _wkwebView.load(URLRequest(url: URL(string: _datas.href)!))
        */
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
        //self.n_view._title = webView.title
        print(webView.estimatedProgress)
        /*
        webView.evaluateJavaScript("var meta = document.createElement('meta');meta.name='viewport';meta.content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, target-densitydpi=device-dpi';var head = document.getElementsByTagName('head')[0];head.appendChild(meta);") { (te, error) in
            
        }*/
        
    }
    func webView(_ webView: IMYWebView!, didFailLoadWithError error: Error!) {
        print(webView.estimatedProgress)
    }
    
}


