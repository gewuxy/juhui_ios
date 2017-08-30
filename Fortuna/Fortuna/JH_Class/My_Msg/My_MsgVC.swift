//
//  My_MsgVC.swift
//  Fortuna
//
//  Created by LCD on 2017/8/24.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class My_MsgVC: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<Int, Int>>()
    
    let dataCells = Variable([SectionModel<Int, Int>]())
}

extension My_MsgVC {
    override class func initSPVC() -> My_MsgVC {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "My_MsgVC") as! My_MsgVC
    }
    class func show(_ parentVC:UIViewController?) {
        let vc = My_MsgVC.initSPVC()
        vc.hidesBottomBarWhenPushed = true
        parentVC?.navigationController?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.makeTableViewRx()
    }
    
}
extension My_MsgVC {
    fileprivate func makeTableViewRx(){
        tableView.rx.setDelegate(self).addDisposableTo(disposeBag)
        dataCells.value = [
            SectionModel(model:0,items:[0,1,2,3,4,5,6,7,8,9]),
            SectionModel(model:1,items:[10,11,12,13,14,15,16,17,18,19])
        ]
        dataSource.configureCell = { (dat,tab,indexPath,mo) in
            let cell = tab.dequeueReusableCell(withIdentifier: "My_MsgVCCell")
            cell?.textLabel?.text = "\(mo)"
            return cell!
        }
        
        dataCells.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
    }
}
extension My_MsgVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
}
