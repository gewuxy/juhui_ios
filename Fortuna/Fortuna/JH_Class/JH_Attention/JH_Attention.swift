//
//  JH_Attention.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/8.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class JH_Attention: SP_ParentVC {

    

    

}

extension JH_Attention {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sp_makeNavigation()
        
    }
    fileprivate func sp_makeNavigation() {
        n_view.n_btn_L1_Image = ""
        n_view._detailTitle = "自选股票"
        
    }
}
