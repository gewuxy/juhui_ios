//
//  JH_Search.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/13.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class JH_Search: SP_ParentVC {

    @IBOutlet weak var tableView: UITableView!

    let disposeBag = DisposeBag()
    lazy var _text_search:SP_TextField = {
        let text = SP_TextField.show(self.n_view.n_view_Title)
        text.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(7)
            make.bottom.equalToSuperview().offset(-7)
        }
        text.text_field.placeholder = "搜你喜欢"
        text.text_field.font = UIFont.systemFont(ofSize: 15)
        text.text_field.textColor = UIColor.mainText_1
        text.text_field.tintColor = UIColor.main_1
        text.button_L.setImage(UIImage(named:"Search搜索"), for: .normal)
        text.button_R.setImage(UIImage(named:"Search叉"), for: .normal)
        text.layer.cornerRadius = 15
        text.clipsToBounds = true
        text.backgroundColor = UIColor.white
        text.view_Line.isHidden = true
        text.button_L_W.constant = 50
        text.button_R_W.constant = 40
        text.text_field_L.constant = 0
        text.view_textBg_L.constant = 0
        return text
    }()
}
extension JH_Search {
    override class func initSPVC() -> JH_Search {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_Search") as! JH_Search
    }
    class func show(_ parentVC:UIViewController?) {
        let vc = JH_Search.initSPVC()
        vc.hidesBottomBarWhenPushed = true
        parentVC?.show(vc, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavigation()
        makeUI()
        makeRx()
        makeTextDelegate()
    }
    fileprivate func makeNavigation() {
        n_view.n_btn_R1_R.constant = 15
        
        
    }
    
    fileprivate func makeUI() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    fileprivate func makeRx() {
        let phoneValid_1 = _text_search.text_field.rx.text.map { $0?.characters.count == 0 }.shareReplay(1)
        phoneValid_1
            .asObservable()
            .subscribe(onNext: { [weak self](isOk) in
                self?._text_search.button_R_W.constant = isOk ? 0 : 40
                self?._text_search.button_R.isHidden = isOk
            }).addDisposableTo(disposeBag)
        _text_search.button_R.rx.tap
            .asObservable()
            .subscribe(onNext: { [unowned self](isOK) in
                self._text_search.text_field.text = ""
            }).addDisposableTo(disposeBag)
    }
    
    fileprivate func makeTextDelegate() {
        
        
        _text_search._block = { [weak self] (type,text) in
            switch type {
            case .tChange:
                break
            default:
                break
            }
        }
    }
}

extension JH_Search:UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
}
extension JH_Search:UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JH_SearchCell_List.show(tableView, indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
