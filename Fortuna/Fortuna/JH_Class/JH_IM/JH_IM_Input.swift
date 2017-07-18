//
//  JH_IM_Input.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/13.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
//MARK:--- TextInput -----------------------------
extension JH_IM {
    func makeTextInput(){
        self._inputView._block = { [weak self](type,text) in
            switch type {
            case .tBtn_R:
                self?.showHudImg()
            case .tBtn_L:
                self?._inputView._isTalk = !self!._inputView._isTalk
                self?.hiddenHudImg()
            case .tBegin:
                self?.hiddenHudImg()
            default:
                break
            }
        }
        self._inputView._heightBlock = { [weak self](type,height) in
            switch type {
            case .tH:
                if height <= 40 {
                    self?.view_Bot_H.constant = 50
                    self?.view_Bot.setNeedsLayout()
                    self?.view_Bot.layoutIfNeeded()
                    /*
                    self?.view_Bot.snp.updateConstraints({ (make) in
                        make.height.equalTo(50)
                    })*/
                }else if height < 100 {
                    self?.view_Bot_H.constant = height + 10
                    self?.view_Bot.setNeedsLayout()
                    self?.view_Bot.layoutIfNeeded()
                    /*
                    self?.view_Bot.snp.updateConstraints({ (make) in
                        make.height.equalTo(height + 10)
                    })*/
                }else{
                    self?.view_Bot_H.constant = 110
                    self?.view_Bot.setNeedsLayout()
                    self?.view_Bot.layoutIfNeeded()
                    /*
                    self?.view_Bot.snp.updateConstraints({ (make) in
                        make.height.equalTo(110)
                    })*/
                }
                self?.toRowBottom()
            case .tB:
                break
                //self?._keyBoardHeight = height
                //self?.toRowBottom()
            }
        }
        
        self._inputView._recordBlock = { [weak self] type in
            guard self != nil else {return}
            switch type {
            case UIControlEvents.touchDown://开始录音
                self?.startRecordVoice()
                //SP_IM_Voice.shared.recordBegin(self)
            case UIControlEvents.touchUpOutside://取消录音
                LGSoundRecorder.shareInstance().soundRecordFailed(self!.view)
                //SP_IM_Voice.shared.recordStop()
            case UIControlEvents.touchUpInside://录音结束
                //SP_IM_Voice.shared.recordStop()
                self?.confirmRecordVoice()
                
            case UIControlEvents.touchDragExit:
                // 更新录音显示状态,手指向上滑动后 提示松开取消录音
                //SP_IM_Voice.shared.recordPause()
                
                LGSoundRecorder.shareInstance().readyCancelSound()
            case UIControlEvents.touchDragEnter:
                //更新录音状态,手指重新滑动到范围内,提示向上取消录音
                //SP_IM_Voice.shared.recordRecord()
                LGSoundRecorder.shareInstance().resetNormalRecord()
                
            default:
                break
            }
        }
        
        self._inputView._shouldReturnBlock = { [unowned self]_ in
            guard !self._inputView.text_View.text.isEmpty else {return}
            var model = SP_IM_TabModel()
            model.content = self._inputView.text_View.text
            model.userLogo = SP_UserModel.read().imgUrl
            model.type = .tText
            model.isMe = true
            model.isLoading = true
            model.create_at = String(format: "%.0f", Date().timeIntervalSince1970*1000)
            if self._tabDatas.count > 0 {
                self._tabDatas.insert(model, at: 0)
            }else{
                self._tabDatas.append(model)
            }
            
            self.sendMessage(model)
            
            self.tableView?.reloadData()
            self.toRowBottom()
            self._inputView.text_View.text = ""
            self._inputView.textViewDidChange(self._inputView.text_View)
            
        }
    }
    
}

extension JH_IM {
    func showKeyboard(){
        sp_Notification.addObserver(self, selector:#selector(JH_IM.keyBoardWillShow(_:)), name:sp_ntfNameKeyboardWillShow, object: nil)
        sp_Notification.addObserver(self, selector:#selector(JH_IM.keyBoardWillHide(_:)), name:sp_ntfNameKeyboardWillHide, object: nil)
    }
    func removeKeyboard() {
        sp_Notification.removeObserver(self, name: sp_ntfNameKeyboardWillShow, object: nil)
        sp_Notification.removeObserver(self, name:sp_ntfNameKeyboardWillHide, object: nil)
        sp_Notification.removeObserver(self)
    }
    
    func keyBoardWillShow(_ note:NSNotification) {
        let userInfo  = note.userInfo
        let keyBoardBounds = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let _keyBoardHeight = keyBoardBounds.size.height
        
        self.view_Bot_B.constant = _keyBoardHeight
        self.view_Bot.setNeedsLayout()
        let animations:(() -> Void) = {
            //self.transform = CGAffineTransform(translationX: 0,y: -_keyBoardHeight)
            self.view_Bot.layoutIfNeeded()
            
            
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            
            animations()
        }
        self.toRowBottom()
    }
    
    func keyBoardWillHide(_ note:NSNotification)
    {
        
        let userInfo  = note.userInfo
        
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        self.view_Bot_B.constant = 0.0
        self.view_Bot.setNeedsLayout()
        let animations:(() -> Void) = {
            //self.transform = .identity
            self.view_Bot.layoutIfNeeded()
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            
            animations()
        }
        self.toRowBottom()
    }
}

extension JH_IM {
    //MARK:--- 开始录音 -----------------------------
    func startRecordVoice() {
        if isVideo {
            player?.stop()
        }
        if AVAudioSession.sharedInstance().responds(to: #selector(AVAudioSession.requestRecordPermission(_:))) {
            AVAudioSession.sharedInstance().requestRecordPermission { [weak self](granted) in
                if (granted) {
                    self?.recordVoices()
                } else {
                    // 可以显示一个提示框告诉用户这个app没有得到允许？
                    UIAlertController.showAler(self, btnText: [sp_localized("取消"),sp_localized("去开启")], title: sp_localized("app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"), message: "", block: { (str) in
                        if str == sp_localized("去开启") {
                            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                        }
                    })
                }
            }
        }
    }
    func recordVoices() {
        LGAudioPlayer.share().stopAudioPlayer()
        LGSoundRecorder.shareInstance().startSoundRecord(self.view, recordPath: SP_ToolOC.sp_recordPath())
        
        self.timerOf60Second?.invalidate()
        self.timerOf60Second = nil
        self.timerOf60Second = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(JH_IM.sixtyTimeStopSendVodio(_:)), userInfo: nil, repeats: true)
    }
    func sixtyTimeStopSendVodio( _ timer:Timer ) {
        let countDown:Int = 60 - Int(LGSoundRecorder.shareInstance().soundRecordTime())
        print_SP("countDown is \(countDown)")
        if countDown <= 10 {
            LGSoundRecorder.shareInstance().showCountdown(Int32(countDown-1))
        }
        if LGSoundRecorder.shareInstance().soundRecordTime() >= 59 && LGSoundRecorder.shareInstance().soundRecordTime() <= 60 {
            self._inputView.btn_voice.sendActions(for: .touchUpInside)
            self.timerOf60Second?.invalidate()
            self.timerOf60Second = nil
        }
    }
    
    //MARK:--- 录音结束 -----------------------------
    func confirmRecordVoice() {
        if LGSoundRecorder.shareInstance().soundRecordTime() < 1.0 {
            self.timerOf60Second?.invalidate()
            self.timerOf60Second = nil
            LGSoundRecorder.shareInstance().showShotTimeSign(self.view)
            return
        }
        
        if LGSoundRecorder.shareInstance().soundRecordTime() < 61 {
            self.sendSound()
            LGSoundRecorder.shareInstance().stopSoundRecord(self.view)
        }
        
        self.timerOf60Second?.invalidate()
        self.timerOf60Second = nil
        
    }
    func sendSound() {
        let soundFile:String = LGSoundRecorder.shareInstance().soundFilePath
        //let mp3FilePath:String = SP_ToolOC.sp_audio_PCMtoMP3(withFilePath: LGSoundRecorder.shareInstance().soundFilePath)
        let time = String(format: "%.0f\"", LGSoundRecorder.shareInstance().soundRecordTime())
        print_SP(time)
        self.updateVoice(URL(fileURLWithPath: soundFile), time:time)
        
    }
    
    func playRecord(_ urlStr:String, index:Int, playBtn:UIButton) {
        if self.isVideo {
            player?.stop()
        }
        
        LGAudioPlayer.share().playAudio(withURLString: urlStr, at: UInt(index), withParentButton: playBtn)
        
    }
}
