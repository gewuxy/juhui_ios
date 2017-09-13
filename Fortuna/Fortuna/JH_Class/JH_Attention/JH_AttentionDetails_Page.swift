//
//  JH_AttentionDetails_Page.swift
//  Fortuna
//
//  Created by LCD on 2017/9/12.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
/*
struct M_My_Page {
    var name = ""
    var id = ""
}

extension JH_AttentionDetails {
    //MARK:--- 准备视图
    func makePageUI() {
        // 移除原有数据 - 为了排序栏目后的数据清理
        for subView in scrollView_top.subviews {
            subView.removeFromSuperview()
            if subView is SP_PageItem {
                
            }
        }
        for subView in scrollView_conter.subviews {
            subView.removeFromSuperview()
        }
        for vc in childViewControllers {
            vc.removeFromParentViewController()
        }
        
        // 添加内容
        addContent()
    }
    /**
     添加顶部标题栏和控制器
     */
    private func addContent() {
        
        self.naviTitleView.addSubview(_lineView)
        //scrollView_conter.addSubview(popView)
        // 布局用的左边距
        var leftMargin: CGFloat = 0
        
        for (i,item) in selectedArray.enumerated() {
            let label = SP_PageItemLabel()
            label.selectedColor = _labSelectedColor
            label.normalColor = _labNormalColor
            label.text = item.name
            label.tag = i
            label.scale = i == 0 ? 1.0 : 0.0
            label.isUserInteractionEnabled = true
            scrollView_top.addSubview(label)
            
            label.snp.makeConstraints({ (make) -> Void in
                make.left.equalTo(leftMargin+_itemMargin)
                make.centerY.top.equalToSuperview()
            })
            
            // 更新布局和左边距
            scrollView_top.layoutIfNeeded()
            leftMargin = label.frame.maxX
            
            // 添加标签点击手势
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(JH_AttentionDetails.didTappedTopLabel(_:))))
            //添加控制器
            addController(i)
            
            // 默认控制器 和 预加载的一个View
            if i == 0 {
                showContentView(i)
                self.makeLineView(label, 0)
                
            }
        }
        
        naviTitleView.snp.updateConstraints({ (make) in
            make.width.equalTo(leftMargin+_itemMargin)
        })
        
        // 滚动范围
        
        scrollView_top.contentSize = CGSize(width: leftMargin + _itemMargin, height: 0)
        scrollView_conter.contentSize = CGSize(width: CGFloat(childViewControllers.count) * sp_ScreenWidth, height: 0)
        // 滚动到第一个位置
        scrollView_conter.setContentOffset(CGPoint(x: 0, y: scrollView_conter.contentOffset.y), animated: true)
    }
    
    //MARK:--- 顶部标签的点击事件
    func didTappedTopLabel(_ gesture: UITapGestureRecognizer) {
        guard let titleLabel = gesture.view as? SP_PageItemLabel else{return}
        
        // 让内容视图滚动到指定的位置
        scrollView_conter.setContentOffset(CGPoint(x: CGFloat(titleLabel.tag) * scrollView_conter.frame.size.width, y: scrollView_conter.contentOffset.y), animated: false)
        my_scrollViewDidEndScrollingAnimation(scrollView_conter)
    }
    
    func makeLineView(_ lab:UIView, _ offsetW:CGFloat){
        _lineView.snp.removeConstraints()
        _lineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(scrollView_top.snp.bottom)
            make.height.equalTo(_lineViewH)
            make.width.equalTo(_lineViewW)
            make.centerX.equalTo(lab.snp.centerX).offset(offsetW)
        }
    }
}
//MARK:--- 添加内容控制器 + 展示内容控制器 ----------
extension JH_AttentionDetails {
    //MARK:--- 添加控制器 ----------
    fileprivate func addController(_ index:Int) {
        //
        switch index {
        case 0:
            self.addChildViewController(_postVC)
        default:
            self.addChildViewController(_newsVC)
        }
    }
    //MARK:--- 展示内容控制器 ---------
    fileprivate func showContentView(_ index: Int) {
        
        // 获取需要展示的控制器
        let newsVc = self.childViewControllers[index]
        
        // 如果已经展示则直接返回
        if newsVc.view.superview != nil {
            return
        }
        
        newsVc.view.frame = CGRect(x: CGFloat(index) * sp_ScreenWidth, y: 0, width: scrollView_conter.bounds.width, height: scrollView_conter.bounds.height)
        scrollView_conter.addSubview(newsVc.view)
        self._showContentViewBlock?(index)
        
    }
}
extension JH_AttentionDetails: UIScrollViewDelegate {
    // 滚动结束后触发 代码导致
    func my_scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        // 滚动标题栏
        let titleLabel = scrollView_top.subviews[index]
        
        var offsetX = titleLabel.center.x - scrollView_top.frame.size.width * 0.5
        let offsetMax = scrollView_top.contentSize.width - scrollView_top.frame.size.width
        
        if offsetX < 0 {
            offsetX = 0
        } else if (offsetX > offsetMax) {
            offsetX = offsetMax
        }
        
        // 滚动顶部标题
        scrollView_top.setContentOffset(CGPoint(x: offsetX, y: scrollView_top.contentOffset.y), animated: true)
        
        self.makeLineView(titleLabel, 0)
        
        // 恢复其他label缩放
        for i in 0..<selectedArray.count {
            if i != index {
                guard let topLabel = scrollView_top.subviews[i] as? SP_PageItemLabel else{return}
                topLabel.scale = 0.0
            }
        }
        
        // 添加控制器 - 并预加载控制器  左滑预加载下下个 右滑预加载上上个 保证滑动流畅
        let value = (scrollView.contentOffset.x / scrollView.frame.width)
        
        var index1 = Int(value)
        var index2 = Int(value)
        
        // 根据滑动方向计算下标
        if scrollView.contentOffset.x - _contentOffsetX > 2.0 {
            index1 = (value - CGFloat(Int(value))) > 0 ? Int(value) + 1 : Int(value)
            index2 = index1 + 1
        } else if _contentOffsetX - scrollView.contentOffset.x > 2.0 {
            index1 = (value - CGFloat(Int(value))) < 0 ? Int(value) - 1 : Int(value)
            index2 = index1 - 1
        }
        
        // 控制器角标范围
        if index1 > childViewControllers.count - 1 {
            index1 = childViewControllers.count - 1
        } else if index1 < 0 {
            index1 = 0
        }
        if index2 > childViewControllers.count - 1 {
            index2 = childViewControllers.count - 1
        } else if index2 < 0 {
            index2 = 0
        }
        
        showContentView(index1)
        
    }
    
    //MARK:--- UIScrollViewDelegate
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        my_scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    // 滚动结束 手势导致
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    // 开始拖拽视图
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        _contentOffsetX = scrollView.contentOffset.x
        
        //let value = (scrollView.contentOffset.x / scrollView.frame.width)
        //let leftIndex = Int(value)
        //guard let labelLeft = scrollView_top.subviews[leftIndex] as? SP_PageItemLabel else{return}
        //_itemW = labelLeft.frame.width/3*2
    }
    // 正在滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x < -85 {
            _ = self.navigationController?.popViewController(animated: true)
        }
        let value = (scrollView.contentOffset.x / scrollView.frame.width)
        
        let leftIndex = Int(value)
        let rightIndex = leftIndex + 1
        let scaleRight = value - CGFloat(leftIndex)
        let scaleLeft = 1 - scaleRight
        
        guard let labelLeft = scrollView_top.subviews[leftIndex] as? SP_PageItemLabel else{return}
        labelLeft.scale = scaleLeft
        
        
        if rightIndex < scrollView_top.subviews.count {
            guard let labelRight = scrollView_top.subviews[rightIndex] as? SP_PageItemLabel else{return}
            
            labelRight.scale = scaleRight
            
            let www = scaleRight * (labelRight.frame.size.width/2 + labelLeft.frame.size.width/2 + _itemMargin)
            
            self.makeLineView(labelLeft,www)
            
            
        }
        
        
    }
    
}*/
