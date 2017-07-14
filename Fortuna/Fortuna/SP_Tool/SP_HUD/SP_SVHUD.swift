//
//  SP_SVHUD.swift
//  IEXBUY
//
//  Created by sifenzi on 2016/9/29.
//  Copyright © 2016年 IEXBUY. All rights reserved.
//

/**
 *这是一个对 SVProgressHUD 扩展的类，介绍SVProgressHUD的使用方法
 *#import "SVProgressHUD.h"//请将这个写在桥接文件中
 *
 *
 *
 *
 *
 *
 *
 *
 *
 */


import Foundation
import SVProgressHUD
extension SP_SVHUD {
    //MARK:--- 显示
    class func show(_ type:SP_HUDType, text:String = "", time:TimeInterval = 20.0, progressEnd:Float = 10.0, block:SVProgressHUDDismissCompletion? = nil) {
        
        SP_SVHUD.setStyle(.dark)
        
        switch type {
        case .tNone:
            SP_HUD.show(text:text)
        case .tLoading:
            SVProgressHUD.show(withStatus: text)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(UInt64(time)*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) {
                SVProgressHUD.dismiss(withDelay: 0, completion: block)
            }
        case .tInfo:
            SP_SVHUD.setDismissTime(time)
            SVProgressHUD.showInfo(withStatus: text)
        case .tSuccess:
            SP_SVHUD.setDismissTime(1.0)
            SVProgressHUD.showSuccess(withStatus: text)
        case .tError:
            SP_SVHUD.setDismissTime(1.0)
            SVProgressHUD.showError(withStatus: text)
        case .tProgress: break
            //progressStart = 0.0
            //progressTime = Float(time)
            //progressText = text
            //SVProgressHUD.showProgress(progressStart, status: progressText)
        default:
            break
        }
        
    }
    
    private static var progressStart:Float = 0.0
    private static var progressEnd:Float = 0.0
    private static var progressTime:Float = 0.0
    private static var progressText:String = ""
    private class func increaseProgress() {
        progressStart += progressTime/progressEnd
        SVProgressHUD.showProgress(progressStart, status: progressText)
        if progressStart < 1.0 {
            
        } else {
            
        }
    }
    
}

class SP_SVHUD {
    //MARK:--- 基本设置
    ///背景色 默认是 whiteColor, 仅对 SVProgressHUDStyle.custom 有效
    class func setBgColor(_ color: UIColor) {
        SVProgressHUD.setBackgroundColor(color)
    }
    ///背景色 默认是 White:0 alpha:0.5 仅对 SVProgressHUDMaskType.black 以下有效
    class func setBgLayerColor(_ color: UIColor) {
        SVProgressHUD.setBackgroundLayerColor(color)
    }
    class func setFgColor(_ color: UIColor) {
        // 默认是 blackColor, 仅对 SVProgressHUDStyle.custom 有效
        SVProgressHUD.setForegroundColor(color)
    }
    class func setSuccessImage(_ image: UIImage) {
        SVProgressHUD.setSuccessImage(image)
    }
    class func setErrorImage(_ image: UIImage) {
        SVProgressHUD.setErrorImage(image)
    }
    class func setFont(_ font: UIFont) {
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 16))
    }
    class func setStyle(_ style:SVProgressHUDStyle){
        /*
         .light,  默认 white HUD with black text
         .dark,   black HUD and white text
         .custom  自定义颜色
         */
        SVProgressHUD.setDefaultStyle(style)
    }
    class func setMaskType(_ type:SVProgressHUDMaskType){
        /*
         .none   默认 允许用户交互
         .clear  不允许用户交互
         .black  不允许用户交互且背景半透明
         .gradient  不允许用户交互且背景渐变透明
         .custom    不允许用户交互自定义背景色
         */
        SVProgressHUD.setDefaultMaskType(type)
    }
    class func setAnimationType(_ type:SVProgressHUDAnimationType){
        /*
         .flat   默认 自定义动画环
         .native  菊花
         */
        SVProgressHUD.setDefaultAnimationType(type)
    }
    class func setMinimumSize(_ minimumSize: CGSize) {
        
    }
    class func setRingThickness(_ ringThickness: CGFloat) {
        
    }
    class func setRadius(_ radius: CGFloat) {
        
    }
    class func setCornerRadius(_ cornerRadius: CGFloat) {
        
    }
    class func setDismissTime(_ time:TimeInterval){
        SVProgressHUD.setMinimumDismissTimeInterval(time)
    }
    
    //MARK:--- 显示
    
    
    class func show() {
        SVProgressHUD.show()
    }
    class func show(_ string: String) {
        SVProgressHUD.show(withStatus: string)
    }
    class func showImage(_ image: UIImage, string: String) {
        SVProgressHUD.show(image, status: string)
        SVProgressHUD.showInfo(withStatus: string)
    }
    class func showInfo(_ string: String) {
        SVProgressHUD.showInfo(withStatus: string)
    }
    class func showSuccess(_ string: String) {
        SVProgressHUD.showSuccess(withStatus: string)
    }
    class func showError(_ string: String) {
        SVProgressHUD.showError(withStatus: string)
        
    }
    class func showProgress(_ float: Float) {
        SVProgressHUD.showProgress(float)
    }
    class func showProgress(_ float: Float, string: String) {
        SVProgressHUD.showProgress(float, status: string)
    }
    
    
    //MARK:--- 关闭
    class func dismiss() {
        SVProgressHUD.dismiss()
    }
    class func dismiss(_ time:TimeInterval) {
        SVProgressHUD.dismiss(withDelay: time)
    }
    class func dismiss(_ time:TimeInterval, block:@escaping SVProgressHUDDismissCompletion) {
        SVProgressHUD.dismiss(withDelay: time, completion: block)
    }
    
    
    class func isVisible() -> Bool {
        return SVProgressHUD.isVisible()
    }
    
    
}
