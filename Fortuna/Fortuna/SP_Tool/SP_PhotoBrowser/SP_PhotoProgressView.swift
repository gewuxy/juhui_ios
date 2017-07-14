//
//  SP_PhotoBrowser.swift
//  IEXBUY
//
//  Created by sifenzi on 16/9/5.
//  Copyright © 2016年 IEXBUY. All rights reserved.
//

import UIKit

class SP_PhotoProgressView: UIView {

    var progress: Double = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var mCenter = CGPoint.zero
    
    var mRadius: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        self.layer.masksToBounds = true
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if (mRadius == 0) {
            let w = rect.size.width;
            let h = rect.size.height;
            mCenter = CGPoint(x: w * 0.5, y: h * 0.5);
            mRadius = min(w, h) * 0.5 - 8;
            self.layer.cornerRadius = min(w, h) * 0.5;
        }
        let ctx = UIGraphicsGetCurrentContext();
        
        let center = mCenter;
        let radius = mRadius;
        let startAngle = CGFloat(-M_PI_2);
        let endAngle = CGFloat(-M_PI_2 + progress * M_PI * 2);
        
        let blackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: CGFloat(M_PI * 2.0) + startAngle, clockwise: true)
        ctx?.setLineWidth(3.0);
        UIColor.black.set()
        ctx?.addPath(blackPath.cgPath);
        ctx?.strokePath();
        
        let whitePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        ctx?.setLineWidth(3.0);
        ctx?.setLineCap(.round);
        UIColor.white.set()
        ctx?.addPath(whitePath.cgPath);
        ctx?.strokePath();
    }
}
