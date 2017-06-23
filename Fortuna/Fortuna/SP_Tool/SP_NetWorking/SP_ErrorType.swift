//
//  SP_ErrorType.swift
//  Fortuna
//
//  Created by 刘才德 on 2017/6/21.
//  Copyright © 2017年 Friends-Home. All rights reserved.
//

import Foundation


/// 网络请求回调闭包 success:是否成功 result:数据 progress:请求进度 error:错误信息
typealias sp_netComBlock = (_ success: Bool, _ result: Any?, _ error: String?) -> Void
typealias sp_netProgressBlock = (_ progress:Progress?) -> Void

//MARK:--- 罗列错误类型(自定义) -----------------------------
enum SP_ErrorType:Int {
    case noData      = 10000000000
    case nsurlErrorUnknown = -1
    case nsurlErrorCancelled = -999
    case nsurlErrorBadURL = -1000
    case nsurlErrorTimedOut = -1001
    case nsurlErrorUnsupportedURL = -1002
    case nsurlErrorCannotFindHost = -1003
    case nsurlErrorCannotConnectToHost = -1004
    case nsurlErrorDataLengthExceedsMaximum = -1103
    case nsurlErrorNetworkConnectionLost = -1005
    case nsurlErrorDNSLookupFailed = -1006
    case nsurlErrorHTTPTooManyRedirects = -1007
    case nsurlErrorResourceUnavailable = -1008
    case nsurlErrorNotConnectedToInternet = -1009
    case nsurlErrorRedirectToNonExistentLocation = -1010
    case nsurlErrorBadServerResponse = -1011
    case nsurlErrorUserCancelledAuthentication = -1012
    case nsurlErrorUserAuthenticationRequired = -1013
    case nsurlErrorZeroByteResource = -1014
    case nsurlErrorCannotDecodeRawData = -1015
    case nsurlErrorCannotDecodeContentData = -1016
    case nsurlErrorCannotParseResponse = -1017
    case nsurlErrorFileDoesNotExist = -1100
    case nsurlErrorFileIsDirectory = -1101
    case nsurlErrorNoPermissionsToReadFile = -1102
    case nsurlErrorSecureConnectionFailed = -1200
    case nsurlErrorServerCertificateHasBadDate = -1201
    case nsurlErrorServerCertificateUntrusted = -1202
    case nsurlErrorServerCertificateHasUnknownRoot = -1203
    case nsurlErrorServerCertificateNotYetValid = -1204
    case nsurlErrorClientCertificateRejected = -1205
    case nsurlErrorClientCertificateRequired = -1206
    case nsurlErrorCannotLoadFromNetwork = -2000
    case nsurlErrorCannotCreateFile = -3000
    case nsurlErrorCannotOpenFile = -3001
    case nsurlErrorCannotCloseFile = -3002
    case nsurlErrorCannotWriteToFile = -3003
    case nsurlErrorCannotRemoveFile = -3004
    case nsurlErrorCannotMoveFile = -3005
    case nsurlErrorDownloadDecodingFailedMidStream = -3006
    case nsurlErrorDownloadDecodingFailedToComplete = -3007
    
    
    var stringValue:String {
        switch self {
        case .nsurlErrorUnknown:                                 return "未知错误"
        case .nsurlErrorCancelled:                               return "取消了网址"
        case .nsurlErrorBadURL:                                  return "错误URL"
        case .nsurlErrorTimedOut:                                return "请求超时"
        case .nsurlErrorUnsupportedURL:                          return "不支持URL"
        case .nsurlErrorCannotFindHost:                          return "无法找到服务器"
        case .nsurlErrorCannotConnectToHost:                     return "无法连接到服务器"
        case .nsurlErrorDataLengthExceedsMaximum:                return "数据长度超过最大值"
        case .nsurlErrorNetworkConnectionLost:                   return "网络连接丢失"
        case .nsurlErrorDNSLookupFailed:                         return "DNS查找失败"
        case .nsurlErrorHTTPTooManyRedirects:                    return "HTTP重定向"
        case .nsurlErrorResourceUnavailable:                     return "资源不可用"
        case .nsurlErrorNotConnectedToInternet:                  return "网络异常"
        case .nsurlErrorRedirectToNonExistentLocation:           return "重定向到不存在的位置"
        case .nsurlErrorBadServerResponse:                       return "服务器响应错误"
        case .nsurlErrorUserCancelledAuthentication:             return "用户取消认证"
        case .nsurlErrorUserAuthenticationRequired:              return "用户认证要求"
        case .nsurlErrorZeroByteResource:                        return "零字节资源"
        case .nsurlErrorCannotDecodeRawData:                     return "不能解码原始数据"
        case .nsurlErrorCannotDecodeContentData:                 return "无法解码内容数据"
        case .nsurlErrorCannotParseResponse:                     return "无法解析响应"
        case .nsurlErrorFileDoesNotExist:                        return "文件不存在"
        case .nsurlErrorFileIsDirectory:                         return "文件目录错误"
        case .nsurlErrorNoPermissionsToReadFile:                 return "没有权限读取文件"
        case .nsurlErrorSecureConnectionFailed:                  return "安全连接失败"
        case .nsurlErrorServerCertificateHasBadDate:             return "服务器证书已过期"
        case .nsurlErrorServerCertificateUntrusted:              return "服务器证书不可信"
        case .nsurlErrorServerCertificateHasUnknownRoot:         return "服务器证书具有未知的Root"
        case .nsurlErrorServerCertificateNotYetValid:            return "服务器证书无效"
        case .nsurlErrorClientCertificateRejected:               return "客户端证书被拒绝"
        case .nsurlErrorClientCertificateRequired:               return "客户端证书要求"
        case .nsurlErrorCannotLoadFromNetwork:                   return "无法加载网络"
        case .nsurlErrorCannotCreateFile:                        return "无法创建文件"
        case .nsurlErrorCannotOpenFile:                          return "无法打开文件"
        case .nsurlErrorCannotCloseFile:                         return "无法关闭文件"
        case .nsurlErrorCannotWriteToFile:                       return "无法写入文件"
        case .nsurlErrorCannotRemoveFile:                        return "无法删除文件"
        case .nsurlErrorCannotMoveFile:                          return "无法移动文件"
        case .nsurlErrorDownloadDecodingFailedMidStream:         return "下载解码失败"
        case .nsurlErrorDownloadDecodingFailedToComplete:        return "下载解码未能完成"
        case .noData: return "没有获取到数据"
        }
    }
    
    
}

//MARK:--- 罗列错误类型（系统） -----------------------------
func sp_returnNSError(_ error:Error) -> String {
    switch (error as NSError).code {
    case NSURLErrorUnknown:                                 return "未知错误"
    case NSURLErrorCancelled:                               return "取消了网址"
    case NSURLErrorBadURL:                                  return "错误URL"
    case NSURLErrorTimedOut:                                return "请求超时"
    case NSURLErrorUnsupportedURL:                          return "不支持URL"
    case NSURLErrorCannotFindHost:                          return "无法找到服务器"
    case NSURLErrorCannotConnectToHost:                     return "无法连接到服务器"
    case NSURLErrorDataLengthExceedsMaximum:                return "数据长度超过最大值"
    case NSURLErrorNetworkConnectionLost:                   return "网络连接丢失"
    case NSURLErrorDNSLookupFailed:                         return "DNS查找失败"
    case NSURLErrorHTTPTooManyRedirects:                    return "HTTP重定向"
    case NSURLErrorResourceUnavailable:                     return "资源不可用"
    case NSURLErrorNotConnectedToInternet:                  return "网络异常"
    case NSURLErrorRedirectToNonExistentLocation:           return "重定向到不存在的位置"
    case NSURLErrorBadServerResponse:                       return "服务器响应错误"
    case NSURLErrorUserCancelledAuthentication:             return "用户取消认证"
    case NSURLErrorUserAuthenticationRequired:              return "用户认证要求"
    case NSURLErrorZeroByteResource:                        return "零字节资源"
    case NSURLErrorCannotDecodeRawData:                     return "不能解码原始数据"
    case NSURLErrorCannotDecodeContentData:                 return "无法解码内容数据"
    case NSURLErrorCannotParseResponse:                     return "无法解析响应"
    case NSURLErrorFileDoesNotExist:                        return "文件不存在"
    case NSURLErrorFileIsDirectory:                         return "文件目录错误"
    case NSURLErrorNoPermissionsToReadFile:                 return "没有权限读取文件"
    case NSURLErrorSecureConnectionFailed:                  return "安全连接失败"
    case NSURLErrorServerCertificateHasBadDate:             return "服务器证书已过期"
    case NSURLErrorServerCertificateUntrusted:              return "服务器证书不可信"
    case NSURLErrorServerCertificateHasUnknownRoot:         return "服务器证书具有未知的Root"
    case NSURLErrorServerCertificateNotYetValid:            return "服务器证书无效"
    case NSURLErrorClientCertificateRejected:               return "客户端证书被拒绝"
    case NSURLErrorClientCertificateRequired:               return "客户端证书要求"
    case NSURLErrorCannotLoadFromNetwork:                   return "无法加载网络"
    case NSURLErrorCannotCreateFile:                        return "无法创建文件"
    case NSURLErrorCannotOpenFile:                          return "无法打开文件"
    case NSURLErrorCannotCloseFile:                         return "无法关闭文件"
    case NSURLErrorCannotWriteToFile:                       return "无法写入文件"
    case NSURLErrorCannotRemoveFile:                        return "无法删除文件"
    case NSURLErrorCannotMoveFile:                          return "无法移动文件"
    case NSURLErrorDownloadDecodingFailedMidStream:         return "下载解码失败"
    case NSURLErrorDownloadDecodingFailedToComplete:        return "下载解码未能完成"
    default: return"连接错误"
    }
}



