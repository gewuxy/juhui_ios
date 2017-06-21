//
//  Observable+ObjectMapper.swift
//  PalmCivet
//
//  Created by DianQK on 16/2/4.
//  Copyright © 2016年 DianQK. All rights reserved.
//
import RxSwift
import Moya
import ObjectMapper
import SwiftyJSON

extension Observable {
    
    func mapObject<T: Mappable>(_ type: T.Type) -> Observable<T> {
        return self.map { response in
            //if response is a dictionary, then use ObjectMapper to map the dictionary
            //if not throw an error
            guard let dict = response as? [String: Any] else {
                throw RxSwiftMoyaError.tParseJSONError
            }
            return Mapper<T>().map(JSON: dict)!
        }
    }
    
    func mapArray<T: Mappable>(_ type: T.Type) -> Observable<[T]> {
        return self.map { representor in
            //if response is an array of dictionaries, then use ObjectMapper to map the dictionary
            //if not, throw an error
            // get Moya.Response
            guard let response = representor as? Moya.Response else {
                throw RxSwiftMoyaError.tNoRepresentor
            }
            // check http status
            guard ((200...209) ~= response.statusCode) else {
                throw RxSwiftMoyaError.tNotSuccessfulHTTP
            }
            
            guard let array = representor as? [Any] else {
                throw RxSwiftMoyaError.tParseJSONError
            }
            guard let dicts = array as? [[String: Any]] else {
                throw RxSwiftMoyaError.tParseJSONError
            }
            
            return Mapper<T>().mapArray(JSONArray: dicts)!
        }
    }
}


extension Observable {
    private func resultFromJSON<T: Mapable>(_ jsonData:JSON, classType: T.Type) -> T? {
        return T(jsonData: jsonData)
    }
    func mapSwiftyJsonObj<T: Mapable>(_ type: T.Type) -> Observable<T?> {
        return map { representor in
            // get Moya.Response
            guard let response = representor as? Moya.Response else {
                throw RxSwiftMoyaError.tNoRepresentor
            }
            // check http status
            guard ((200...209) ~= response.statusCode) else {
                throw RxSwiftMoyaError.tNotSuccessfulHTTP
            }
            
            // unwrap biz json shell
            let json = JSON.init(data: response.data)
            
            // check biz status
            if let code = json[RESULT_CODE].string {
                if code == BizStatus.BizSuccess.rawValue {
                    // bizSuccess -> return biz obj
                    return self.resultFromJSON(json[RESULT_DATA], classType:type)
                } else {
                    // bizError -> throw biz error
                    throw RxSwiftMoyaError.tBizError(resultCode: json[RESULT_CODE].int, resultMsg: json[RESULT_MSG].string)
                }
            } else {
                throw RxSwiftMoyaError.tCouldNotMakeObjectError
            }
        }
    }
    
    func mapSwiftyJsonArray<T: Mapable>(_ type: T.Type) -> Observable<[T]> {
        return map { response in
            
            // get Moya.Response
            guard let response = response as? Moya.Response else {
                throw RxSwiftMoyaError.tNoRepresentor
            }
            
            // check http status
            guard ((200...209) ~= response.statusCode) else {
                throw RxSwiftMoyaError.tNotSuccessfulHTTP
            }
            
            // unwrap biz json shell
            let json = JSON.init(data: response.data)
            
            // check biz status
            if let code = json[RESULT_CODE].string {
                if code == BizStatus.BizSuccess.rawValue {
                    // bizSuccess -> wrap and return biz obj array
                    var objects = [T]()
                    let objectsArrays = json[RESULT_DATA].array
                    if let array = objectsArrays {
                        for object in array {
                            if let obj = self.resultFromJSON(object, classType:type) {
                                objects.append(obj)
                            }
                        }
                        return objects
                    } else {
                        throw RxSwiftMoyaError.tNoData
                    }
                    
                } else {
                    throw RxSwiftMoyaError.tBizError(resultCode: json[RESULT_CODE].int, resultMsg: json[RESULT_MSG].string)
                }
            } else {
                throw RxSwiftMoyaError.tCouldNotMakeObjectError
            }
            
        }
    }
    
    
}

enum RxSwiftMoyaError {
    case tParseJSONError
    case tNoRepresentor
    case tNotSuccessfulHTTP
    case tNoData
    case tCouldNotMakeObjectError
    case tBizError(resultCode: Int?, resultMsg: String?)
    case tOtherError
}
extension RxSwiftMoyaError: Swift.Error { }

enum BizStatus: String {
    case BizSuccess = "000000"
    case BizError
}

public protocol Mapable {
    init?(jsonData:JSON)
}

let RESULT_CODE = "code"
let RESULT_MSG = "msg"
let RESULT_DATA = "data"



