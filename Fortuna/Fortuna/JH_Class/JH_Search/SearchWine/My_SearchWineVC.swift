//
//  My_SearchWineVC.swift
//  Fortuna
//
//  Created by LCD on 2017/8/29.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
class My_SearchWineVC: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<Int, M_Attention>>()
    
    let dataCells = Variable([SectionModel<Int, M_Attention>]())
    
    var selectBlock:((M_Attention)->Void)?
}
extension My_SearchWineVC {
    override class func initSPVC() -> My_SearchWineVC {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "My_SearchWineVC") as! My_SearchWineVC
    }
    class func show(_ parentVC:UIViewController?, block:((M_Attention)->Void)? = nil) {
        let vc = My_SearchWineVC.initSPVC()
        vc.selectBlock = block
        vc.hidesBottomBarWhenPushed = true
        parentVC?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.makeTableViewRx()
    }
    
}
extension My_SearchWineVC {
    fileprivate func makeTableViewRx(){
        tableView.rx.setDelegate(self).addDisposableTo(disposeBag)
        dataCells.value = [
            SectionModel(model:0,items:[M_Attention()]),
            SectionModel(model:1,items:[M_Attention()])
        ]
        dataSource.configureCell = { (dat,tab,indexPath,mo) in
            let cell = tab.dequeueReusableCell(withIdentifier: "My_MsgVCCell")
            cell?.textLabel?.text = "\(mo)"
            return cell!
        }
        
        dataCells.asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        tableView.rx
            .modelSelected(M_Attention.self)
            .subscribe(onNext: { [weak self](model) in
                self?.tableView.deselectRow(at: self!.tableView.indexPathForSelectedRow!, animated: true)
                self?.selectBlock?(model)
                _ = self?.navigationController?.popViewController(animated: true)
            }).addDisposableTo(disposeBag)
    }
}
extension My_SearchWineVC:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
}
