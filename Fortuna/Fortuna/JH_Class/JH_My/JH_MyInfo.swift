//
//  JH_MyInfo.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/4.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources


struct M_JH_MyInfo {
    var name = ""
    var title = ""
}

class JH_MyInfo: SP_ParentVC {

    let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view_foot: UIView!
    @IBOutlet weak var btn_save: UIButton!
    
    
    enum JH_MyInfoRow:String {
        case t头像 = "头像"
        case t昵称 = "昵称"
        case t手机号码 = "手机号码"
    }
    var dataArr:[M_JH_MyInfo] = []
    
}

extension JH_MyInfo {
    override class func initSPVC() -> JH_MyInfo {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JH_MyInfo") as! JH_MyInfo
    }
    class func show(_ parentVC:UIViewController?) {
        let vc = JH_MyInfo.initSPVC()
        vc.hidesBottomBarWhenPushed = true
        parentVC?.navigationController?.show(vc, sender: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataArr = [M_JH_MyInfo(name:JH_MyInfoRow.t头像.rawValue,title:SP_UserModel.read().imgUrl),
                   M_JH_MyInfo(name:JH_MyInfoRow.t昵称.rawValue,title:SP_UserModel.read().nickname),
                   M_JH_MyInfo(name:JH_MyInfoRow.t手机号码.rawValue,title:SP_UserModel.read().mobile)]
        
        makeTableView()
        makeNavigation()
        makeNotification()
    }
    fileprivate func makeNavigation() {
        n_view._title = sp_localized("个人信息")
        btn_save.setTitle(sp_localized("保存修改"), for: .normal)
        view_foot.isHidden = true
        //changeFootView()
    }
    fileprivate func makeTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    fileprivate func makeNotification() {
        sp_Notification.rx
            .notification(SP_User.shared.ntfName_更新用户信息)
            .takeUntil(self.rx.deallocated)
            .asObservable()
            .subscribe(onNext: { [weak self](n) in
                self?.dataArr = [M_JH_MyInfo(name:JH_MyInfoRow.t头像.rawValue,title:SP_UserModel.read().imgUrl),
                                 M_JH_MyInfo(name:JH_MyInfoRow.t昵称.rawValue,title:SP_UserModel.read().nickname),
                                 M_JH_MyInfo(name:JH_MyInfoRow.t手机号码.rawValue,title:SP_UserModel.read().mobile)]
                self?.tableView.reloadData()
            }).addDisposableTo(disposeBag)
    }
    fileprivate func changeFootView() {
        let arr = [M_JH_MyInfo(name:JH_MyInfoRow.t头像.rawValue,title:SP_UserModel.read().imgUrl),
                   M_JH_MyInfo(name:JH_MyInfoRow.t昵称.rawValue,title:SP_UserModel.read().nickname),
                   M_JH_MyInfo(name:JH_MyInfoRow.t手机号码.rawValue,title:SP_UserModel.read().mobile)]
        var srt0 = ""
        for item in arr {
            srt0 += item.title
        }
        var srt1 = ""
        for item in dataArr {
            srt1 += item.title
        }
        if srt0 == srt1 {
            view_foot.isHidden = true
        }else{
            view_foot.isHidden = true
        }
        self.url_用户信息修改()
    }
    
    @IBAction func clickSave(_ sender: UIButton) {
        self.url_用户信息修改()
        
    }
}

extension JH_MyInfo:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 80 : 50
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sp_SectionH_Min
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch dataArr[indexPath.row].name {
        case JH_MyInfoRow.t头像.rawValue:
            let cell = JH_MyInfoCell_Img.show(tableView, indexPath)
            cell.lab_name.text = sp_localized(dataArr[indexPath.row].name)
            cell.img_logo.sp_ImageName(dataArr[indexPath.row].title)
            return cell
        case JH_MyInfoRow.t昵称.rawValue, JH_MyInfoRow.t手机号码.rawValue:
            let cell = JH_MyInfoCell_Name.show(tableView, indexPath)
            cell.lab_name.text = sp_localized(dataArr[indexPath.row].name)
            cell.text_field.text = dataArr[indexPath.row].title
            cell.text_field.isEnabled = false
            cell._block = { [weak self](type, str) in
                self?.textChange(type, str,indexPath.row)
            }
            cell.btn_go.isHidden = dataArr[indexPath.row].name == JH_MyInfoRow.t手机号码.rawValue
            cell.selectionStyle = dataArr[indexPath.row].name==JH_MyInfoRow.t手机号码.rawValue ? .none : .default
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.row {
        case 0:
            uploadTopImage()
        case 1:
            JH_MyChange.show(self, type: .t昵称)
        case 2:
            break
        default:
            break
        }
    }
    
    
    func textChange(_ type:SP_TextField_Type, _ text:String, _ index:Int) -> Void {
        switch type {
        case .tChange:
            dataArr[index].title = text
            changeFootView()
            
        default:
            break
        }
    }
    
}

class JH_MyInfoCell_Img: UITableViewCell {
    class func show(_ tableView: UITableView, _ indexPath: IndexPath)->JH_MyInfoCell_Img {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JH_MyInfoCell_Img", for: indexPath) as! JH_MyInfoCell_Img
        return cell
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        lab_name.font = sp_fitFont18
        lab_name.textColor = UIColor.mainText_1
        view_line.backgroundColor = UIColor.main_line
    }
    
    
    @IBOutlet weak var view_line: UIView!
    @IBOutlet weak var lab_name: UILabel!
    @IBOutlet weak var img_logo: UIImageView!
    
}
class JH_MyInfoCell_Name: UITableViewCell,UITextFieldDelegate {
    class func show(_ tableView: UITableView, _ indexPath: IndexPath)->JH_MyInfoCell_Name {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JH_MyInfoCell_Name", for: indexPath) as! JH_MyInfoCell_Name
        return cell
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        lab_name.font = sp_fitFont18
        lab_name.textColor = UIColor.mainText_1
        text_field.font = sp_fitFont18
        text_field.textColor = UIColor.mainText_2
        text_field.placeholder = sp_localized("请输入")
        text_field.delegate = self
        view_line.backgroundColor = UIColor.main_line
    }
    @IBOutlet weak var lab_name: UILabel!
    @IBOutlet weak var text_field: UITextField!
    @IBOutlet weak var view_line: UIView!
    @IBOutlet weak var btn_go: UIButton!
    
    var _block:((_ type:SP_TextField_Type, _ text:String)->Void)?
    var _shouldChangeCharactersBlock:((_ textField: UITextField, _ range: NSRange, _ string: String)->Bool)?
    var _shouldReturnBlock:((_ textField: UITextField)->Bool)?
    var _shouldClearBlock:((_ textField: UITextField)->Bool)?
    
    @IBAction func begin(_ sender: UITextField) {
        _block?(.tBegin,sender.text!)
    }
    
    @IBAction func changed(_ sender: UITextField) {
        _block?(.tChange,sender.text!)
    }
    @IBAction func end(_ sender: UITextField) {
        _block?(.tEnd,sender.text!)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return _shouldReturnBlock?(textField) ?? true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        return _shouldClearBlock?(textField) ?? true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return _shouldChangeCharactersBlock?(textField,range,string) ?? true
    }
    
}

extension JH_MyInfo {
    fileprivate func url_用户信息修改() {
        SP_HUD.show(view: self.view, type: .tLoading)
        My_API.t_用户信息修改(nickname: dataArr[1].title, email: "", img_url: dataArr[0].title).post(M_MyCommon.self) { (isOk, data, error) in
            SP_HUD.hidden()
            if isOk {
                //SP_HUD.show(text:sp_localized("保存成功"))
                SP_User.shared.url_用户信息()
                //_ = self?.navigationController?.popViewController(animated: true)
            }else{
                SP_HUD.show(text:error)
            }
        }
    }
    
    //MARK:---------- 上传 头像
    func uploadTopImage() {
        let photoView = SP_AddPhoto(frame: self.view.bounds, parentVC: self)
        self.view.addSubview(photoView)
        photoView._picker.allowsEditing = true
        photoView._maxNumber = 1
        photoView.show()
        photoView.sp_AddPhotoBlock = { [weak self]() in
            
            var p = SP_UploadParam()
            p.fileData = SP_PhotoManager.shared.imageJpgDatas[0] //图片的Data数据流
            p.filename =  Date.sp_Date("yyyyMMddHHmmssSSS") + ".jpg"
            p.serverName = "file"
            p.mimeType = "image/jpg"
            p.type = .tData
            
            SP_HUD.show(text: "进入后台上传")
            My_API.t_媒体文件上传(uploadParams: [p]).upload(M_MyCommon.self, block: { [weak self](isOk, data, error) in
                if isOk {
                    guard let datas = data as? M_MyCommon else{return}
                    self?.dataArr[0].title = datas.media_url
                    self?.tableView.reloadData()
                    self?.changeFootView()
                    
                }else{
                    
                }
                
            }) { (progress) in
                
                //let progre = CGFloat(progress!.completedUnitCount)/CGFloat(progress!.totalUnitCount)
                //print_SP(progre)
            }
            
        }
    }
    
    
}

