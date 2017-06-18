//
//  ViewController.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/5.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.font = SP_InfoOC.sp_fontFit(withSize: 20)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var label: UILabel!
    
    
    

}

