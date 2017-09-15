//
//  SP_Realm.swift
//  Fortuna
//
//  Created by LCD on 2017/8/15.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation

import RealmSwift

class SP_Realm {
    
    /// realm 数据库的名称
    static let username = "MY-DB"
    
    static let sharedInstance = try! Realm()
    
    //--MARK: 初始化 Realm
    /// 初始化进过加密的 Realm， 加密过的 Realm 只会带来很少的额外资源占用（通常最多只会比平常慢10%）
    static func initEncryptionRealm() {
        // 说明： 以下内容是可以合并操作的，但为了能最大限度的展示各个操作内容，故分开设置 Realm
        
        // 产生随机密钥
        var key = Data(count: 64)
        
        _ = key.withUnsafeMutableBytes {mutableBytes in
            SecRandomCopyBytes(kSecRandomDefault, key.count, mutableBytes)
        }
        
        // 获取加密 Realm 文件的配置文件
        var config = Realm.Configuration(encryptionKey: key)
        
        // 使用默认的目录，但是使用用户名来替换默认的文件名
        config.fileURL =  config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(username).realm")
        
        // 获取我们的 Realm 文件的父级目录
        let folderPath = config.fileURL!.deletingLastPathComponent().path
        
        /**
         *  设置可以在后台应用刷新中使用 Realm
         *  注意：以下的操作其实是关闭了 Realm 文件的 NSFileProtection 属性加密功能，将文件保护属性降级为一个不太严格的、允许即使在设备锁定时都可以访问文件的属性
         */
        // 解除这个目录的保护
        try! FileManager.default.setAttributes([FileAttributeKey.protectionKey: FileProtectionType.none], ofItemAtPath: folderPath)
        
        
        // 将这个配置应用到默认的 Realm 数据库当中
        Realm.Configuration.defaultConfiguration = config
        
    }
    
    /// 初始化默认的 Realm
    static func initRealm() {
        var config = Realm.Configuration()
        
        // 使用默认的目录，但是使用用户名来替换默认的文件名
        config.fileURL =  config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(username).realm")
        
        // 获取我们的 Realm 文件的父级目录
        let folderPath = config.fileURL!.deletingLastPathComponent().path
        
        // 解除这个目录的保护
        try! FileManager.default.setAttributes([FileAttributeKey.protectionKey: FileProtectionType.none],
                                               ofItemAtPath: folderPath)
        
        // 将这个配置应用到默认的 Realm 数据库当中
        Realm.Configuration.defaultConfiguration = config
    }
    
    //--- MARK: 操作 Realm
    /// 做写入操作
    static func doWriteHandler(_ clouse: @escaping ()->()) { // 这里用到了 Trailing 闭包
        try! sharedInstance.write {
            clouse()
        }
    }
    
    ///后台做写入操作
    
    static func BGDoWriteHandler(_ clouse: @escaping ()->()) {
        try! Realm().write {
            clouse()
        }
    }
    
    /// 添加一条数据
    static func addCanUpdate<T: Object>(_ object: T) {
        try! sharedInstance.write {
            sharedInstance.add(object, update: true)
        }
    }
    static func add<T: Object>(_ object: T) {
        try! sharedInstance.write {
            sharedInstance.add(object)
        }
    }
    /// 后台单独进程写入一组数据
    static func addListDataAsync<T: Object>(_ objects: [T]) {
        
        
        let queue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)
        // Import many items in a background thread
        queue.async {
            // 为什么添加下面的关键字，参见 Realm 文件删除的的注释
            autoreleasepool {
                // 在这个线程中获取 Realm 和表实例
                let realm = try! Realm()
                // 批量写入操作
                realm.beginWrite()
                // add 方法支持 update ，item 的对象必须有主键
                for item in objects {
                    realm.add(item, update: true)
                }
                // 提交写入事务以确保数据在其他线程可用
                try! realm.commitWrite()
            }
        }
    }
    
    static func addListData<T: Object>(_ objects: [T]) {
        autoreleasepool {
            // 在这个线程中获取 Realm 和表实例
            let realm = try! Realm()
            // 批量写入操作
            realm.beginWrite()
            // add 方法支持 update ，item 的对象必须有主键
            for item in objects {
                realm.add(item, update: true)
            }
            // 提交写入事务以确保数据在其他线程可用
            try! realm.commitWrite()
        }
    }
    
    /// 删除某个数据
    static func delete<T: Object>(_ object: T) {
        try! sharedInstance.write {
            sharedInstance.delete(object)
        }
    }
    
    /// 批量删除数据
    static func delete<T: Object>(_ objects: [T]) {
        try! sharedInstance.write {
            sharedInstance.delete(objects)
        }
    }
    /// 批量删除数据
    static func delete<T: Object>(_ objects: List<T>) {
        try! sharedInstance.write {
            sharedInstance.delete(objects)
        }
    }
    /// 批量删除数据
    static func delete<T: Object>(_ objects: Results<T>) {
        try! sharedInstance.write {
            sharedInstance.delete(objects)
        }
    }
    
    /// 批量删除数据
    static func delete<T: Object>(_ objects: LinkingObjects<T>) {
        try! sharedInstance.write {
            sharedInstance.delete(objects)
        }
    }
    
    
    /// 删除所有数据。注意，Realm 文件的大小不会被改变，因为它会保留空间以供日后快速存储数据
    static func deleteAll() {
        try! sharedInstance.write {
            sharedInstance.deleteAll()
        }
    }
    
    /// 根据条件查询数据
    static func selectByNSPredicate<T: Object>(_: T.Type , predicate: NSPredicate) -> Results<T>{
        return sharedInstance.objects(T.self).filter(predicate)
    }
    
    /// 后台根据条件查询数据
    static func BGselectByNSPredicate<T: Object>(_: T.Type , predicate: NSPredicate) -> Results<T>{
        return try! Realm().objects(T.self).filter(predicate)
    }
    
    
    /// 查询所有数据
    static func selectByAll<T: Object>(_: T.Type) -> Results<T>{
        return sharedInstance.objects(T.self)
    }
    //--- MARK: 删除 Realm
    /*
     参考官方文档，所有 fileURL 指向想要删除的 Realm 文件的 Realm 实例，都必须要在删除操作执行前被释放掉。
     故在操作 Realm实例的时候需要加上 autoleasepool 。如下:
     autoreleasepool {
     //所有 Realm 的使用操作
     }
     */
    /// Realm 文件删除操作
    static func deleteRealmFile() {
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        let realmURLs = [
            realmURL,
            realmURL.appendingPathExtension("lock"),
            realmURL.appendingPathExtension("log_a"),
            realmURL.appendingPathExtension("log_b"),
            realmURL.appendingPathExtension("note")
        ]
        let manager = FileManager.default
        for URL in realmURLs {
            do {
                try manager.removeItem(at: URL)
            } catch {
                // 处理错误
            }
        }
        
    }
}
