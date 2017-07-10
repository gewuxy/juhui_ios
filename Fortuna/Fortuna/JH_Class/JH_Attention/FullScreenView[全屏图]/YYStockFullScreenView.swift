//
//  YYStockFullScreenView.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/4.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class YYStockFullScreenView: UIView {

    

}

extension YYStockFullScreenView {
    class func show()->YYStockFullScreenView {
        for item in sp_MainWindow.subviews {
            if let view = item as? YYStockFullScreenView {
                //view._clickBlock = block
                return view
            }
        }
        let view = (Bundle.main.loadNibNamed("YYStockFullScreenView", owner: nil, options: nil)!.first as? YYStockFullScreenView)!
        sp_MainWindow.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.width.equalTo(sp_MainWindow.snp.height)
            make.height.equalTo(sp_MainWindow.snp.width)
            make.center.equalToSuperview()
        }
        //view._clickBlock = block
        
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
