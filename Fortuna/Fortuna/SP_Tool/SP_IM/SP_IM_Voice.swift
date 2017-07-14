//
//  SP_IM_Voice.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/12.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation

open class SP_IM_Voice {
    fileprivate static let sharedInstance = SP_IM_Voice()
    fileprivate init() {}
    //提供静态访问方法
    open static var shared: SP_IM_Voice {
        return self.sharedInstance
    }
    //录音器
    var _recorder:AVAudioRecorder?
    var _recorderUrl:URL?
    //播放器
    var _player:AVAudioPlayer?
    //定时器
    var _timer:DispatchSourceTimer?
    var _pageStepTime: DispatchTimeInterval = .seconds(1)
    //图片组
    let volumImages:[String] = []
    var lowPassResults:Double = 0
    lazy var hud:UIView = {
        let view = UIView()
        return view
    }()
    
    func recordBegin(_ pVC:UIViewController?) {
        //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
        //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
        //录音通道数  1 或 2
        //线性采样位数  8、16、24、32
        //录音的质量
        let recordSetting:[String:Any] = [AVFormatIDKey:kAudioFormatMPEG4AAC,
                                          AVSampleRateKey:44100,
                                          AVNumberOfChannelsKey:1,
                                          AVLinearPCMBitDepthKey:16,
                                          AVEncoderAudioQualityKey:AVAudioQuality.high,
                                          ]
        /*
         NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
         playName = [NSString stringWithFormat:@"%@/play.aac",docDir];
         */
        self._recorderUrl = nil
        
        self._recorderUrl = SP_ToolOC.sp_getFilePath(withSuffix: "aac")
        do {
            let recorder = try AVAudioRecorder(url: self._recorderUrl!, settings: recordSetting)
            recorder.isMeteringEnabled = true
            recorder.prepareToRecord()
            
        } catch {
            print(error)
            SP_HUD.showMsg("Error")
            return
        }
        
        AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
            if (granted) {
                self._recorder?.record()
                /*
                self._timer = DispatchSource.makeTimerSource(queue: .main)
                self._timer?.scheduleRepeating(deadline: .now() + self._pageStepTime, interval: self._pageStepTime)
                self._timer?.setEventHandler {
                    self.yourMethod()
                }
                // 启动定时器
                self._timer?.resume()*/
            } else {
                // 可以显示一个提示框告诉用户这个app没有得到允许？
                UIAlertController.showAler(pVC, btnText: [sp_localized("取消"),sp_localized("去开启")], title: sp_localized("app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"), message: "", block: { (str) in
                    if str == sp_localized("去开启") {
                        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                    }
                })
            }
        }
        
        
    }
    func recordStop() {
        _recorder?.stop()
        
        deinitTimer()
        _recorder = nil
    }
    func recordPause() {
        _recorder?.pause()
    }
    func recordRecord() {
        _recorder?.record()
    }
    
    func voicePlay(_ url:URL) {
        do {
            _player = try AVAudioPlayer(contentsOf: url)
            
        } catch {
            print(error)
            
        }
        _player?.play()
    }
    func voiceStop() {
        _player?.stop()
    }
    
    func deinitTimer() {
        //_timer?.cancel()
        //_timer = nil
    }
    
    
    
    func yourMethod() {
        _recorder?.updateMeters()
        let ALPHA:Double = 0.05
        let peakPowerForChannel:Double = pow(10, (Double(_recorder!.peakPower(forChannel: 0)) * 0.05))
        lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults
        
    }
    
    
    
}
