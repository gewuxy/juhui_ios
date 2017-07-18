//
//  SP_UMShare.swift
//  IEXBUY
//
//  Created by 刘才德 on 2016/10/12.
//  Copyright © 2016年 IEXBUY. All rights reserved.
//

import Foundation

fileprivate let um_default_shareTitle = "巨汇金融"
fileprivate let um_default_shareText  = "点击查看详情"
fileprivate let um_default_shareImage = "HuanChong"
fileprivate let um_default_shareURL   = key_APPStoree

//弹窗类型
enum UM_viewType {
    case tDefault
    case tCustom(platformType: UMSocialPlatformType)
}
//分享内容类型
enum UM_shareType {
    case text
    case image
    case imageAndText
    case webPage
    case music
    case vedio
}

open class SP_UMShare {
    
    fileprivate static let sharedInstance = SP_UMShare()
    fileprivate init() {}
    //提供静态访问方法
    open static var shared: SP_UMShare {
        return self.sharedInstance
    }
    
    
    
    //创建分享消息对象
    fileprivate lazy var messageObject      = UMSocialMessageObject()
    //创建网页内容对象
    fileprivate lazy var shareWebpageObject = UMShareWebpageObject()
    //创建图片内容对象
    fileprivate lazy var shareImageObject   = UMShareImageObject()
    //创建音乐内容对象
    fileprivate lazy var shareMusicObject   = UMShareMusicObject()
    //创建视频内容对象
    fileprivate lazy var shareVideoObject   = UMShareVideoObject()
    
    //MARK:---------- 友盟分享
    func showDefault(_ parentVC: UIViewController,shareType: UM_shareType = .webPage, viewType: UM_viewType = .tDefault, shareTitle:String = "", shareText:String = "", shareImage:String = "", shareURL:String = "", showAlert: Bool = true, block:((Any) -> Void)? = nil)  {
        guard !key_UMengAppKey.isEmpty else{
            SP_MBHUD.showHUD(type: .tError, text: "尚未注册分享账号", time: 1.0)
            return
        }
        
        let shareImage2 = UIImage(named:shareImage.isEmpty ? um_default_shareImage : shareImage)
        let shareURL2 = shareURL.isEmpty ? um_default_shareURL : shareURL
        let shareTitle2 = shareTitle.isEmpty ? um_default_shareTitle : shareTitle
        let shareText2 = shareText.isEmpty ? um_default_shareText : shareText
        
        // --- 分享类型
        switch shareType {
        case .text:
            messageObject.text = shareText
        case .image:
            //如果有缩略图，则设置缩略图
            shareImageObject.thumbImage = UIImage(named: um_default_shareImage)
            shareImageObject.shareImage = shareImage2
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareImageObject;
        case .imageAndText:
            //设置文本
            messageObject.text = shareText
            //如果有缩略图，则设置缩略图
            shareImageObject.thumbImage = UIImage(named: um_default_shareImage)
            shareImageObject.shareImage = shareImage2
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareImageObject
        case .webPage:
            //创建网页内容对象
            shareWebpageObject = UMShareWebpageObject.shareObject(withTitle: shareTitle2, descr: shareText2, thumImage: shareImage)
            shareWebpageObject.webpageUrl = shareURL2
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareWebpageObject
        case .music:
            //创建音乐内容对象
            shareMusicObject = UMShareMusicObject.shareObject(withTitle: um_default_shareTitle, descr: shareText2, thumImage: shareImage)
            //设置音乐网页播放地址
            shareMusicObject.musicUrl = shareURL2
            //shareObject.musicDataUrl = @"这里设置音乐数据流地址（如果有的话，而且也要看所分享的平台支不支持）";
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareMusicObject;
        case .vedio:
            //创建视频内容对象
            shareVideoObject = UMShareVideoObject.shareObject(withTitle: um_default_shareTitle, descr: shareText2, thumImage: shareImage2)
            //设置视频网页播放地址
            shareVideoObject.videoUrl = shareURL2
            //shareObject.videoStreamUrl = @"这里设置视频数据流地址（如果有的话，而且也要看所分享的平台支不支持）";
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareVideoObject;
        }
        
        // --- 弹窗类型
        switch viewType {
        case .tDefault:
            UMSocialUIManager.setPreDefinePlatforms([UMSocialPlatformType.QQ,UMSocialPlatformType.sina,UMSocialPlatformType.wechatSession,UMSocialPlatformType.wechatTimeLine])
            UMSocialUIManager.showShareMenuViewInWindow(platformSelectionBlock: { [weak self](platformType, data) in
                self?.share(parentVC, platformType: platformType, messageObject: self!.messageObject, showAlert: showAlert) { (shareRespone) in
                    block?(shareRespone)
                }
            })
            
            return
        case .tCustom(let platformType):
            share(parentVC, platformType: platformType, messageObject: messageObject, showAlert: showAlert) { (shareRespone) in
                block?(shareRespone)
            }
        }
    }
    //MARK:---- 分享跳转
    fileprivate func share(_ parentVC: UIViewController, platformType:UMSocialPlatformType, messageObject:UMSocialMessageObject, showAlert: Bool = true, block:@escaping ((Any) -> Void)) {
        UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: parentVC, completion: { [weak self](shareRespone, error) in
            if (error != nil) {
                print("response is \(shareRespone)")
                print("error is \(error)")
                if showAlert {self?.alertWithOk(Ok: false)}
            }else{
                if showAlert {self?.alertWithOk(Ok: true)}
                if let resp = shareRespone as? UMSocialShareResponse {
                    print("response message is \(resp.message)")
                    print("response message is \(resp.originalResponse)")
                }else{
                    print("response is \(shareRespone)")
                }
            }
            block(shareRespone ?? "")
        })
    }
    
    //MARK:---- 弹窗
    private func alertWithOk(Ok: Bool) {
        if Ok {
            SP_MBHUD.showHUD(type: .tSuccess, text:"分享成功", time: 2.0)
        }else{
            SP_MBHUD.showHUD(type: .tError, text:"分享失败", time: 2.0)
        }
        
    }
    
    //MARK:---------- 第三方登录
    func login(_ parentVC: UIViewController, isLogin:Bool, platformType:UMSocialPlatformType, block:@escaping ((Any, Bool) -> Void)) {
        if isLogin {
            UMSocialManager.default().getUserInfo(with: platformType, currentViewController: parentVC, completion: { (result, error) in
                guard let res = result as? UMSocialUserInfoResponse else{
                    block("",false)
                    return
                }
                print("AuthResponse uid: \(res.uid)")
                print("AuthResponse accessToken: \(res.accessToken)")
                print("AuthResponse refreshToken: \(res.refreshToken)")
                print("AuthResponse expiration: \(res.expiration)")
                print("UserInfoResponse name: \(res.name)")
                print("UserInfoResponse iconurl: \(res.iconurl)")
                print("UserInfoResponse gender: \(res.gender)")
                
                block(res,true)
                
            })
            /*  旧版
            UMSocialManager.default().auth(with: platformType, currentViewController: parentVC, completion: { (result, error) in
                print("response is \(result)")
                print("error is \(error)")
                if (error != nil) {
                    print("response is \(result)")
                    print("error is \(error)")
                    block(result ?? "",false)
                }else{
                    guard ((result as? UMSocialAuthResponse) != nil) else{
                        print("response is \(result)")
                        block(result ?? "",false)
                        return
                    }
                    UMSocialManager.default().getUserInfo(with: platformType, currentViewController: parentVC, completion: { (result, error) in
                        guard let res = result as? UMSocialUserInfoResponse else{
                            block("",false)
                            return
                        }
                        print("AuthResponse uid: \(res.uid)")
                        print("AuthResponse accessToken: \(res.accessToken)")
                        print("AuthResponse refreshToken: \(res.refreshToken)")
                        print("AuthResponse expiration: \(res.expiration)")
                        print("UserInfoResponse name: \(res.name)")
                        print("UserInfoResponse iconurl: \(res.iconurl)")
                        print("UserInfoResponse gender: \(res.gender)")
                        
                        block(res,true)
                        
                    })
                }
            })*/
        }else{
            UMSocialManager.default().cancelAuth(with: platformType, completion: { (result, error) in
                if (error != nil) {
                    print("response is \(result)")
                }else{
                    print("response is \(result)")
                }
            })
        }
    }
    
    func checkIsLogin(platformType: UMSocialPlatformType) -> Bool {
        //是否已经授权
        return UMSocialDataManager.default().isAuth(platformType)
    }
    
}


















