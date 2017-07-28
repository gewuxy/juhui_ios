//
//  JH_AttentionDetails_Datas.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/7/27.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation

extension JH_AttentionDetails {
    func makeKTimeLineData(_ type:JH_ChartDataType, timeLines:[M_TimeLine]) -> [M_TimeLine] {
        let data = timeLines
        switch type {
        case .t分时:
            return self.makeTimeData(self.makeMidTimeData(data, component:.second, timeCountMax:600, timeNum: 600), component:.second, timeCountMax:600, timeNum: 600)
        case .t5日:
            return self.makeTimeData(self.makeMidTimeData(data, component:.second, timeCountMax:600, timeNum: 600), component:.second, timeCountMax:600, timeNum: 600)
        case .t日K:
            return self.makeTimeData(self.makeMidTimeData(data, component:.second, timeCountMax:3600*24, timeNum: 3600*24), component:.second, timeCountMax:3600*24, timeNum: 3600*24)
        case .t周K:
            return data
        case .t月K:
            return data
        case .t1分:
            return self.makeTimeData(self.makeMidTimeData(data, component:.second, timeCountMax:60, timeNum: 60), component:.second, timeCountMax:60, timeNum: 60)
        case .t5分:
            return self.makeTimeData(self.makeMidTimeData(data, component:.second, timeCountMax:60*5, timeNum: 60*5), component:.second, timeCountMax:60*5, timeNum: 60*5)
        case .t10分:
            return self.makeTimeData(self.makeMidTimeData(data, component:.second, timeCountMax:600, timeNum: 600), component:.second, timeCountMax:600, timeNum: 600)
        case .t30分:
            return self.makeTimeData(self.makeMidTimeData(data, component:.second, timeCountMax:30*60, timeNum: 30*60), component:.second, timeCountMax:30*60, timeNum: 30*60)
        case .t60分:
            return self.makeTimeData(self.makeMidTimeData(data, component:.second, timeCountMax:3600, timeNum: 3600), component:.second, timeCountMax:3600, timeNum: 3600)
        }
        //return data
    }
    //MARK:--- 处理中间分时数据 -----------------------------
    func makeMidTimeData(_ timeLines:[M_TimeLine], component:Calendar.Component, timeCountMax:Int, timeNum:Double) -> [M_TimeLine] {
        guard timeLines.count > 1 else {return timeLines}
        let gregorian = Calendar(identifier: .gregorian)
        
        guard var time0:Double = Double(timeLines.first!.timestamp) else {return timeLines}
        
        var model0 = timeLines.first!
        
        //var tiCount = 0
        var new_TimeLines: [M_TimeLine] = []
        //new_TimeLines.append(item)
        for item in timeLines {
            new_TimeLines.append(item)
            if let time1:Double = Double(item.timestamp) {
                //计算与前一个存储数据的差值
                let time0Date = Date(timeIntervalSince1970: time0/1000)
                let time1Date = Date(timeIntervalSince1970: time1/1000)
                let result = gregorian.dateComponents([component], from: time0Date, to: time1Date)
                var minuteCount:Int = 0
                switch component {
                case .second:
                    minuteCount = result.second!
                case .minute:
                    minuteCount = result.minute!
                case .hour:
                    minuteCount = result.hour!
                case .day:
                    minuteCount = result.day!
                default:
                    break
                }
                //如果差值大于最大差值，则在两两数据中间插入具体相差数据量
                if minuteCount > timeCountMax //10,
                {
                    var timm = time0/1000
                    
                    for j in 0 ..< minuteCount/timeCountMax {
                        
                        if !(minuteCount/timeCountMax - 1 == j && minuteCount%timeCountMax == 0) {
                            
                            var model = model0
                            timm += timeNum //600,
                            model.timestamp = String(format: "%.0f", timm*1000)
                            
                            new_TimeLines.insert(model, at: new_TimeLines.count-1)
                            
                        }
                    }
                }
                //一次循环后将当前数据复制给前一个存储数据
                time0 = time1
                model0 = item
            }
        }
        return new_TimeLines
    }
    //MARK:--- 处理尾部分时数据 -----------------------------
    func makeTimeData(_ timeLines:[M_TimeLine], component:Calendar.Component, timeCountMax:Int, timeNum:Double) -> [M_TimeLine] {
        var m_TimeLines = timeLines
        guard m_TimeLines.count > 0 else {return m_TimeLines}
        
        let gregorian = Calendar(identifier: .gregorian)
        //取当前时间 ---- 在组尾添加数据
        //let nowDate = Date()
        //将时间戳转换成时间
        guard let ti:Double = Double(m_TimeLines.last!.timestamp) else {return m_TimeLines}
        let endDate = Date(timeIntervalSince1970: ti/1000)
        let result = gregorian.dateComponents([component], from: endDate, to: Date())
        var minuteCount:Int = 0
        switch component {
        case .second:
            minuteCount = result.second!
        case .minute:
            minuteCount = result.minute!
        case .hour:
            minuteCount = result.hour!
        case .day:
            minuteCount = result.day!
        default:
            break
        }
        guard minuteCount > timeCountMax else {
            return m_TimeLines
        }
        var tim = ti/1000
        var arr:[M_TimeLine] = []
        for _ in 0 ..< minuteCount/timeCountMax //10
        {
            var model = m_TimeLines.last!
            tim += timeNum//600,
            model.timestamp = String(format: "%.0f", tim*1000)
            arr.append(model)
        }
        
        m_TimeLines += arr
        
        return m_TimeLines
    }
    
    /*
    //MARK:--- 处理中间五日数据 -----------------------------
    func makeMidFiveTimeData(_ timeLines:[M_TimeLine]) -> [M_TimeLine] {
        var m_TimeLines = timeLines
        guard m_TimeLines.count > 1 else {return m_TimeLines}
        let gregorian = Calendar(identifier: .gregorian)
        guard var ti:Double = Double(m_TimeLines.first!.timestamp) else {return m_TimeLines}
        var tiModel = m_TimeLines.first!
        var tiCount = 0
        for (i,item) in timeLines.enumerated() {
            if let tim:Double = Double(item.timestamp) {
                let tiDate = Date(timeIntervalSince1970: ti/1000)
                let timDate = Date(timeIntervalSince1970: tim/1000)
                let result = gregorian.dateComponents([Calendar.Component.hour], from: tiDate, to: timDate)
                let hourCount:Int = result.hour!
                if hourCount > 1 {
                    var timm = ti/1000
                    
                    for j in 0..<hourCount/1 {
                        var model = tiModel
                        timm += 3600
                        model.timestamp = String(format: "%.0f", timm*1000)
                        m_TimeLines.insert(model, at: i + j + tiCount)
                    }
                    ti = tim
                    tiModel = item
                    tiCount += hourCount/1
                }
                
            }
        }
        return m_TimeLines
    }

    //MARK:--- 处理尾部五日数据 -----------------------------
    func makeFiveTimeData(_ timeLines:[M_TimeLine]) -> [M_TimeLine] {
        var m_TimeLines = timeLines
        guard m_TimeLines.count > 0 else {return m_TimeLines}
        
        let gregorian = Calendar(identifier: .gregorian)
        
        //取当前时间 ---- 在组尾添加数据
        //let nowDate = Date()
        //将时间戳转换成时间
        guard let ti:Double = Double(m_TimeLines.last!.timestamp) else {return m_TimeLines}
        let endDate = Date(timeIntervalSince1970: ti/1000)
        print_SP(endDate)
        //let gregorian = Calendar(identifier: .gregorian)
        let result = gregorian.dateComponents([Calendar.Component.hour], from: endDate, to: Date())
        let hourCount:Int = result.hour!
        guard hourCount > 1 else {
            return m_TimeLines
        }
        var tim = ti/1000
        var arr:[M_TimeLine] = []
        for _ in 0 ..< hourCount/1 {
            var model = m_TimeLines.last!
            tim += 3600
            model.timestamp = String(format: "%.0f", tim*1000)
            arr.append(model)
        }
        
        m_TimeLines += arr
        //let secondCount:Int = result.second!
        
        return m_TimeLines
    }*/

}
