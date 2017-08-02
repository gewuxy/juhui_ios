//
//  JH_IM_Net.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/13.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import SwiftyJSON
//MARK:--- 网络 和 SocketIO -----------------------------
extension JH_IM {
    //MARK:--- SocketIO -----------------------------
    func makeSocketIO() {
        self.socket.on(clientEvent: .connect) { (data, ack) in
            print_SP("//iOS客户端上线\(data)")
            print_SP("//iOS客户端上线\(self.socket.socketURL)")
            //iOS客户端上线
            //self?.socket.emit("login", self!._followData.code)
        }
        self.socket.on(self._followData.code) { [weak self](res, ack) in
            //接收到广播
            //print_SP("data ==> \(res)")
            let jsons = JSON(res).arrayValue
            print_SP("json ==> \(jsons)")
            self?.makeTabDatas(jsons)
        }
        /*
        self.socket.on(clientEvent: .disconnect) { (data, ack) in
            //iOS客户端下线
            print_SP("//iOS客户端下线\(data)")
            print_SP("//iOS客户端下线\(self.socket.socketURL)")
        }*/
        
        self.socket.connect()
    }
    //MARK:--- 发送信息 -----------------------------
    func sendMessage(_ model:SP_IM_TabModel) {
        print_SP(model.create_at)
        let prama:[String:String] = ["code":_followData.code,
                                     "user_id":SP_UserModel.read().userId,
                                     "mobile":SP_UserModel.read().mobile,
                                     "user_img_url":SP_UserModel.read().imgUrl,
                                     "nickname":SP_UserModel.read().nickname,
                                     "wine_name":_followData.name,
                                     "wine_code":_followData.code,
                                     "video_img_url":model.videoImg,
                                     "type":String(format:"%d",model.type.rawValue),
                                     "content":model.content,
                                     "create_at":model.create_at]
        
        //let json = JSON(prama)
        
        
        //print_SP("//iOS客户端发送消息\(self.socket.socketURL)")
        self.socket.emit(self._followData.code, prama)
        /*
        SP_Alamofire.post("http://39.108.142.204:8001/send_msg/", param: prama, block: { (isOk, res, error) in
            print_Json("url_客户端发送消息=>\(JSON(res!))")
            
        })*/
    }
    
    //MARK:--- t_获取最近聊天记录 -----------------------------
    
    func sp_addMJRefreshHeader() {
        self._tabView.tableView?.sp_headerAddMJRefresh { [weak self]_ in
            if self?._tabDatas.count == 0 {
                self?._pageIndex = 1
            }else{
                self?._pageIndex += 1
            }
            self?.t_获取最近聊天记录()
        }
    }
    
    func sp_EndRefresh()  {
        self._tabView.tableView?.sp_headerEndRefresh()
    }
    
    func t_获取最近聊天记录() {
        My_API.t_获取最近聊天记录(code:_followData.code, page:_pageIndex).post(SP_IM_TabModel.self) { [weak self](isOk, data, error) in
            self?.sp_EndRefresh()
            guard self != nil else{return}
            guard var datas = data as? [SP_IM_TabModel] else{return}
            
            datas.sort(by: { (one, two) -> Bool in
                one.create_at < two.create_at
            })
            if self!._pageIndex == 1 {
                self?._tabDatas = datas
                self?._tabView.tableView?.reloadData()
                self?.toRowBottom()
            }else{
                guard datas.count > 0 else{ self!._pageIndex -= 1; return}
                let count = self!._tabDatas.count
                datas += self!._tabDatas
                self!._tabDatas = datas
                self?._tabView.tableView?.reloadData()
                guard self!._tabDatas.count - count > 0 else{return}
                let indexPath = IndexPath(row: self!._tabDatas.count - count, section: 0)
                self?._tabView.tableView?.scrollToRow(at: indexPath, at: .middle, animated: false)
            }
        }
    }
    
    
    func makeTabDatas(_ jsons:[JSON]) {
        
        var models = [SP_IM_TabModel]()
        for item in jsons {
            models.append(SP_IM_TabModel(item))
        }
        for item in models {
            if item.isMsg == "1" {
                if item.isMe {
                    for (i,dat) in self._tabDatas.enumerated() {
                        if item.create_at == dat.create_at {
                            self._tabDatas[i].isLoading = false
                            switch dat.type {
                            case .tText,.tVideo,.tVoice:
                                self._tabDatas[i].content = item.content
                            default:
                                break
                            }
                        }
                        
                    }
                }else{
                    self._tabDatas.append(item)
                }
                
                self._tabView.tableView?.reloadData()
                self.toRowBottom()
            }else{
                self.btn_numRen.setTitle(" "+item.popularity, for: .normal)
                self.btn_numFollow.setTitle(" "+item.select, for: .normal)
            }
            
            
        }
        
    }
    
    
    func t_删除自选数据() {
        
        SP_HUD.show(view: self.view, type: .tLoading, text: sp_localized("正在删除"))
        My_API.t_删除自选数据(code:_followData.code).post(M_Attention.self) { [weak self](isOk, data, error) in
            SP_HUD.hidden()
            if isOk {
                SP_HUD.show(text: sp_localized("已删除"))
                self?.removeDatas()
            }else{
                SP_HUD.show(text:error)
            }
            
        }
    }
    func removeDatas() {
        _followData.isFollow = false
        self.makeBtnFollow()
        sp_Notification.post(name: ntf_Name_自选删除, object: _followData)
        
    }
    
    func t_添加自选数据() {
        
        SP_HUD.show(view:self.view, type:.tLoading, text:sp_localized("+ 自选") )
        My_API.t_添加自选数据(code:_followData.code).post(M_Attention.self) { [weak self](isOk, data, error) in
            SP_HUD.hidden()
            if isOk {
                SP_HUD.show(text:sp_localized("已加自选"))
                self?._followData.isFollow = true
                self?.makeUI()
                sp_Notification.post(name: ntf_Name_自选添加, object: self != nil ? self!._followData : nil)
                self?.makeBtnFollow()
                
            }else{
                SP_HUD.show(text:error)
            }
            
        }
    }
}
