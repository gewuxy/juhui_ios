//
//  My_Questionary.swift
//  Fortuna
//
//  Created by LCD on 2017/8/4.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class My_Questionary: My_Page {

    

}
extension My_Questionary {
    
    override class func initSPVC() -> My_Questionary {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "My_Questionary") as! My_Questionary
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.n_view.n_btn_L1_Image = ""
        self.n_view.n_btn_L1_W.constant = 44
        self.n_view.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.white
        self._addControllerBlock = { (index) -> UIViewController in
            switch index {
            case 0:
                return JH_AttentionDetails_PostVC.initSPVC()
            default:
                return JH_AttentionDetails_NewsVC.initSPVC()
            }
        }
        self._showContentViewBlock = { index in
            
        }
        self._itemMargin = 25
        self._labSelectedColor = UIColor.main_1
        let model0 = M_My_Page(name:"新帖", id:"0")
        let model1 = M_My_Page(name:"新闻", id:"1")
        self.selectedArray = [model0,model1]
        
    }
    
    
}



