//
//  SP_MJDIYHeader.swift
//  SuperApp
//
//  Created by 刘才德 on 2016/11/2.
//  Copyright © 2016年 Friends-Home. All rights reserved.
//

import UIKit
import MJRefresh
class SP_MJDIYHeader: MJRefreshHeader {

    //MARK:----------- 在这里做一些初始化配置（比如添加子控件）
    override func prepare()  {
        super.prepare()
    }
    //MARK:----------- 在这里设置子控件的位置和尺寸
    override func placeSubviews() {
        super.placeSubviews()
    }
    //MARK:----------- 监听scrollView的contentOffset改变监听
    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentOffsetDidChange(change)
    }
    //MARK:----------- scrollView的contentSize改变
    override func scrollViewContentSizeDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewContentSizeDidChange(change)
    }
    //MARK:----------- 监听scrollView的拖拽状态改变
    override func scrollViewPanStateDidChange(_ change: [AnyHashable : Any]!) {
        super.scrollViewPanStateDidChange(change)
    }
    //MARK:----------- 监听控件的刷新状态
    override var state:MJRefreshState {
        didSet{
            switch state {
            case .idle:
                break
            case .pulling:
                break
            case .refreshing:
                break
            default:
                break
            }
            
        }
        
    }
    //MARK:----------- 监听拖拽比例变化（控件被拖出来的比例）
    override var pullingPercent:CGFloat {
        didSet{
            
        }
    }
    
}
