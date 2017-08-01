//: Playground - noun: a place where people can play

import UIKit
import Foundation


//let gregorian = Calendar(identifier: .gregorian)
//let tiDate = Date(timeIntervalSince1970: 1499184000)
//let timDate = Date(timeIntervalSince1970: 1499270400)
//let result = gregorian.dateComponents([Calendar.Component.second], from: tiDate, to: timDate)
//var minuteCount:Int = result.second!




//MARK:--- 处理中间分时数据 -
func makeMidTimeData(_ timeLines:[(name:Int,timestamp:String)], component:Calendar.Component, timeCountMax:Int, timeNum:Double) -> [(name:Int,timestamp:String)] {
    guard timeLines.count > 1 else {return timeLines}
    let gregorian = Calendar(identifier: .gregorian)
    
    guard var time0:Double = Double(timeLines.first!.timestamp) else {return timeLines}
    
    var model0 = timeLines.first!
    
    //var tiCount = 0
    var new_TimeLines: [(name:Int,timestamp:String)] = []
    //new_TimeLines.append(item)
    for (i,item) in timeLines.enumerated() {
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
                        
                        //if new_TimeLines.count > i + j + tiCount {
                        //}
                        print("-----开始->")
                        print(i )
                        //print(j)
                        //print(tiCount)
                        //print(i + tiCount)
                        new_TimeLines.insert(model, at: new_TimeLines.count-1)//(model, at: i + tiCount)
                        print(new_TimeLines )
                        print("-----结束->")
                    }
                    
                    
                }
                //tiCount += minuteCount/timeCountMax
            }
            //一次循环后将当前数据复制给前一个存储数据
            time0 = time1
            model0 = item
        }
        
        
    }
    return new_TimeLines
}


let data = [(1,"1499184000000"),
            (2,"1499270400000"),
            (3,"1499616000000"),
            (4,"1499702400000"),
            (5,"1500825600000"),
            (6,"1500912000000"),
            (7,"1500998400000"),
            (8,"1501084800000"),
            (9,"1501171200000")]

let datas = makeMidTimeData(data, component:.second, timeCountMax:24*3600, timeNum: 24*3600)


print(datas)




let dic:[String:Any] = ["1":123,
                        "q":"666",
                        "qmwk":666]
_ = dic.contains(where: { (key,value) -> Bool in
    //这里可以根据 key & value 做更多的处理，抛出你想要的
    
    return key == "1"
})
_ = dic.keys.contains("1")


struct M_User {
    var id = ""
}
//有时候不必那么麻烦，简单的if 或 guard 就能获得想要的
func makeDict() {
    if let value = dic["123"] {
        //存在 key "123" 执行
    }else{
        //不存在 key "123" 执行
    }
    
    
    guard let value = dic["123"] else {
        //不存在 key "123" 执行
        return
    }
    //存在 key "123" 往下执行
    
    let dic2:[String:Any] = ["1":123,
                            "q":"666",
                            "qmwk":666,
                            "myModel":M_User(id: "123")
                            ]
    
    guard let value2 = dic2["123"] as? M_User else {
        //不存在 key "123" 执行 || value 不为 M_User
        return
    }
    //存在 key "123" && value 为 M_User 往下执行
    
    
}

