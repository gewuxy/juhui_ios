//
//  VM_Attention.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/26.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import RealmSwift
import RxRealm
import RxSwift
import RxCocoa
import RxDataSources


class VM_Attention {
    //MARK:--- 输入 ----------
    let disposeBag = DisposeBag()
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, M_Attention>>()
    let _datas = Variable([SectionModel<String, M_Attention>]())
    
    
}
