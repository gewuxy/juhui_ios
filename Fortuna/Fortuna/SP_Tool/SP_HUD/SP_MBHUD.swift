//
//  SP_MBHUD.swift
//  IEXBUY
//
//  Created by sifenzi on 2016/9/29.
//  Copyright © 2016年 IEXBUY. All rights reserved.
//
/**
 *这是一个对 SP_MBProgressHUD 扩展封装的类，介绍SP_MBProgressHUD的使用方法
 *#import "SP_MBProgressHUD.h"//请将这个写在桥接文件中
 *
 *
 *
 *
 *
 SP_MBProgressHUD.showAdded(to: SP_MainWindow, animated: true)
 SP_MBHUD.showHUD(view:self.view, type:.tLoading,detailText:"成功成功")
//3秒关闭
DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(3*NSEC_PER_SEC))/Double(NSEC_PER_SEC)) {
    //SP_MBHUD.hideHUD()
    }
 *
 *
 *
 *
 */

import Foundation

/**
 typedef enum {
 
 // 使用UIActivityIndicatorView来显示进度，这是默认值
 SP_MBProgressHUDModeIndeterminate,
 // 使用一个圆形饼图来作为进度视图
 SP_MBProgressHUDModeDeterminate,
 // 使用一个水平进度条
 SP_MBProgressHUDModeDeterminateHorizontalBar,
 // 使用圆环作为进度条
 SP_MBProgressHUDModeAnnularDeterminate,
 // 显示一个自定义视图，通过这种方式，可以显示一个正确或错误的提示图
 SP_MBProgressHUDModeCustomView,
 // 只显示文本
 SP_MBProgressHUDModeText
 } SP_MBProgressHUDMode;
 typedef enum {
	/** Opacity animation */
	SP_MBProgressHUDAnimationFade,
	/** Opacity + scale animation */
	SP_MBProgressHUDAnimationZoom,
	SP_MBProgressHUDAnimationZoomOut = SP_MBProgressHUDAnimationZoom,
	SP_MBProgressHUDAnimationZoomIn
 } SP_MBProgressHUDAnimation;

 */
class SP_MBHUD {
    fileprivate static let sharedInstance = SP_MBHUD()
    fileprivate init() {}
    //提供静态访问方法
    open static var shared: SP_MBHUD {
        return self.sharedInstance
    }
    
    private var mbhud:SP_MBProgressHUD?
    // 是否需要蒙版效果
    var dimBackground:Bool? {
        willSet{
            
        }
    }
    // 隐藏时候从父控件中移除
    var removeFromSuperViewOnHide:Bool? {
        willSet{
            
        }
    }
    // 背景框的透明度，默认值是0.8
    var opacity:Float? {
        willSet{
            
        }
    }
    // 背景框的颜色
    // 需要注意的是如果设置了这个属性，则opacity属性会失效，即不会有半透明效果
    var color:UIColor? {
        willSet{
            SP_MBHUD.shared.mbhud?.color = newValue!
        }
    }
    // 背景框的圆角半径。默认值是10.0
    var cornerRadius:Float? {
        willSet{
            
        }
    }
    // 标题文本的字体及颜色
    var labelFont:UIFont? {
        willSet{
            
        }
    }
    var labelColor:UIColor? {
        willSet{
            
        }
    }
    // 详情文本的字体及颜色
    var detailsLabelFont:UIFont? {
        willSet{
            SP_MBHUD.shared.mbhud?.detailsLabelFont = newValue
        }
    }
    var detailsLabelColor:UIColor? {
        willSet{
            
        }
    }
    // 菊花的颜色，默认是白色
    var activityIndicatorColor:UIColor? {
        willSet{
            
        }
    }
    // HUD相对于父视图中心点的x轴偏移量和y轴偏移量
    var xOffset:Float? {
        willSet{
            
        }
    }
    var yOffset:Float? {
        willSet{
            
        }
    }
    // HUD各元素与HUD边缘的间距
    var margin:Float? {
        willSet{
            SP_MBHUD.shared.mbhud?.margin = newValue!
        }
    }
    // HUD背景框的最小大小
    var minSize:CGSize? {
        willSet{
            
        }
    }
    // HUD的实际大小
    var size:CGSize? {
        willSet{
            
        }
    }
    // 是否强制HUD背景框宽高相等
    var square:Bool? {
        willSet{
            SP_MBHUD.shared.mbhud?.isSquare = newValue!
        }
    }
    
    private class func imageview(_ type:SP_HUDType) {
        switch type {
        case .tNone:
            break
        case .tLoading:
            break
        case .tSuccess:
            let name = SP_MBHUD.shared.mbhud?.color == nil ? "SP_HUD.bundle/success-w" : "SP_HUD.bundle/success"
            SP_MBHUD.shared.mbhud?.customView = UIImageView(image: UIImage(named:name))
            // 自定义
            SP_MBHUD.shared.mbhud?.mode = SP_MBProgressHUDModeCustomView
        case .tInfo:
            let name = SP_MBHUD.shared.mbhud?.color == nil ? "SP_HUD.bundle/info-w" : "SP_HUD.bundle/info"
            SP_MBHUD.shared.mbhud?.customView = UIImageView(image: UIImage(named:name))
            // 只显示文本
            SP_MBHUD.shared.mbhud?.mode = SP_MBProgressHUDModeCustomView
        case .tError:
            let name = SP_MBHUD.shared.mbhud?.color == nil ? "SP_HUD.bundle/error-w" : "SP_HUD.bundle/error"
            SP_MBHUD.shared.mbhud?.customView = UIImageView(image: UIImage(named:name))
            // 只显示文本
            SP_MBHUD.shared.mbhud?.mode = SP_MBProgressHUDModeCustomView
        case .tProgress:
            // 只显示文本
            SP_MBHUD.shared.mbhud?.mode = SP_MBProgressHUDModeAnnularDeterminate
        default:
            break
        }
    }
    
    class func showHUD(view:UIView = sp_MainWindow, type:SP_HUDType = .tLoading, text:String = "", detailText:String="", image:String = "", time:TimeInterval = 20, block:SP_MBProgressHUDCompletionBlock? = nil) {
        SP_MBHUD.hideHUD()
        SP_MBHUD.shared.mbhud = SP_MBProgressHUD.showAdded(to: view, animated: true)
        SP_MBHUD.shared.mbhud?.animationType = SP_MBProgressHUDAnimationZoom
        SP_MBHUD.shared.mbhud?.removeFromSuperViewOnHide = true
        SP_MBHUD.shared.mbhud?.isUserInteractionEnabled = false
        var open = false
        if !text.isEmpty {
            SP_MBHUD.shared.mbhud?.labelText = text
            open = true
        }
        if !detailText.isEmpty {
            SP_MBHUD.shared.mbhud?.detailsLabelText = detailText
            open = true
        }
        SP_MBHUD.shared.margin = 20.0
        if !image.isEmpty {
            SP_MBHUD.shared.mbhud?.customView = UIImageView(image: UIImage(named:image))
            open = true
        }else{
            SP_MBHUD.imageview(type)
        }
        
        switch type {
        case .tNone:
            guard open else {
                SP_MBHUD.shared.mbhud?.hide(true)
                return
            }
            // 只显示文本
            SP_MBHUD.shared.mbhud?.mode = SP_MBProgressHUDModeText
            SP_MBHUD.shared.margin = 10.0
            SP_MBHUD.shared.mbhud?.yOffset = Float(sp_ScreenHeight/2 - 70.0)
            SP_MBHUD.shared.square = false
            SP_MBHUD.shared.mbhud?.hide(true, afterDelay: 1.5)
        case .tLoading:
            // 菊花
            SP_MBHUD.shared.mbhud?.mode = SP_MBProgressHUDModeIndeterminate
            SP_MBHUD.shared.mbhud?.hide(true, afterDelay: time)
        case .tSuccess:
            
            // 自定义
            SP_MBHUD.shared.mbhud?.mode = SP_MBProgressHUDModeCustomView
            SP_MBHUD.shared.mbhud?.hide(true, afterDelay: 1.5)
        case .tInfo:
            // 自定义
            SP_MBHUD.shared.mbhud?.mode = SP_MBProgressHUDModeCustomView
            SP_MBHUD.shared.mbhud?.hide(true, afterDelay: time)
        case .tError:
            // 自定义
            SP_MBHUD.shared.mbhud?.mode = SP_MBProgressHUDModeCustomView
            SP_MBHUD.shared.mbhud?.hide(true, afterDelay: 1.5)
        case .tProgress:
            // 圆环进度条
            SP_MBHUD.shared.mbhud?.mode = SP_MBProgressHUDModeAnnularDeterminate
        default:
            break
        }
        SP_MBHUD.shared.mbhud?.completionBlock = block
    }
    class func hideHUD() {
        SP_MBHUD.shared.mbhud?.hide(true, afterDelay: 0.0)
    }
    
}
