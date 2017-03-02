//
//  Observable+Alamofire.swift
//  CT_RESTAPI
//
//  Created by thcanh on 3/2/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper
import SwiftyJSON

public extension Observable where Element: JSONWrapper {
    public func autoMappingObject<T>(_ keyPath: String? = nil) -> Observable<T?> where T: Mappable {
        
        return self.flatMapLatest({ (jsonWrapper) -> Observable<T?> in
            
            let jsonWrapper = jsonWrapper as JSONWrapper
            let object: T? = jsonWrapper.json.mappingObject(keyPath)
            
            return Observable<T?>.just(object)
        })
    }
    
    public func autoMappingObject<T>(_ keyPath: String? = nil) -> Observable<T?> where T: CTMappable {
        
        return self.flatMapLatest({ (jsonWrapper) -> Observable<T?> in
            
            let jsonWrapper = jsonWrapper as JSONWrapper
            let object: T? = jsonWrapper.json.mappingObject(keyPath)
            
            return Observable<T?>.just(object)
        })
    }
    
    public func autoMappingObject<T>(_ keyPath: String? = nil) -> Observable<T> where T: Mappable {
        
        return self.flatMapLatest({ (jsonWrapper) -> Observable<T> in
            
            let jsonWrapper = jsonWrapper as JSONWrapper
            let object: T? = jsonWrapper.json.mappingObject(keyPath)
            
            guard let obj = object else {
                return Observable<T>.error(RESTError() as! Error)
            }
            
            return Observable<T>.just(obj)
        })
    }
    
    public func autoMappingArray<T>(_ keyPath: String? = nil) -> Observable<[T]> where T: Mappable {
        return self.flatMapLatest({ (jsonWrapper) -> Observable<[T]> in
            
            let jsonWrapper = jsonWrapper as JSONWrapper
            let object: [T] = jsonWrapper.json.mappingArray(keyPath)
            
            return Observable<[T]>.just(object)
        })
    }
    
    public func autoMappingObject<T>(_ keyPath: String? = nil) -> Observable<T> where T: CTMappable {
        return self.flatMapLatest({ (jsonWrapper) -> Observable<T> in
            
            let jsonWrapper = jsonWrapper as JSONWrapper
            let object: T? = jsonWrapper.json.mappingObject(keyPath)
            
            guard let obj = object else {
                return Observable<T>.error(RESTError() as! Error)
            }
            
            return Observable<T>.just(obj)
        })
    }
    
    public func autoMappingArray<T>(_ keyPath: String? = nil) -> Observable<[T]> where T: CTMappable {
        return self.flatMapLatest({ (jsonWrapper) -> Observable<[T]> in
            
            let jsonWrapper = jsonWrapper as JSONWrapper
            let object: [T] = jsonWrapper.json.mappingArray(keyPath)
            
            return Observable<[T]>.just(object)
        })
    }
}
//
//public extension Observable where Element: NKResult {
//    public func mappingObject<T>(_ type: T.Type, keyPath: String? = nil) -> Observable<Element> where T: Mappable {
//        return self.continueWithSuccessCloure({ (element) -> Observable<Element> in
//            guard let jsonWrapper = (element as NKResult).value as? JSONWrapper else {
//                return Observable.just(NKResult(error: NKNetworkErrorType.unspecified(error: nil))  as! Element)
//            }
//            
//            let result: T? = jsonWrapper.json.mappingObject(keyPath)
//            
//            return Observable.just(NKResult(value: result) as! Element)
//        })
//    }
//    
//    public func mappingArray<T>(_ type: T.Type, keyPath: String? = nil) -> Observable<Element> where T: Mappable {
//        return self.continueWithSuccessCloure({ (element) -> Observable<Element> in
//            guard let jsonWrapper = (element as NKResult).value as? JSONWrapper else {
//                return Observable.just(NKResult(error: NKNetworkErrorType.unspecified(error: nil))  as! Element)
//            }
//            
//            let result: [T] = jsonWrapper.json.mappingArray(keyPath)
//            return Observable.just(NKResult(value: result) as! Element)
//        })
//    }
//    
//    public func mappingObject<T>(_ type: T.Type, keyPath: String? = nil) -> Observable<Element> where T: NKMappable {
//        return self.continueWithSuccessCloure({ (element) -> Observable<Element> in
//            guard let jsonWrapper = (element as NKResult).value as? JSONWrapper else {
//                return Observable.just(NKResult(error: NKNetworkErrorType.unspecified(error: nil))  as! Element)
//            }
//            
//            let result: T? = jsonWrapper.json.mappingObject(keyPath)
//            
//            return Observable.just(NKResult(value: result) as! Element)
//        })
//    }
//    
//    public func mappingArray<T>(_ type: T.Type, keyPath: String? = nil) -> Observable<Element> where T: NKMappable {
//        return self.continueWithSuccessCloure({ (element) -> Observable<Element> in
//            guard let jsonWrapper = (element as NKResult).value as? JSONWrapper else {
//                return Observable.just(NKResult(error: NKNetworkErrorType.unspecified(error: nil))  as! Element)
//            }
//            
//            let result: [T] = jsonWrapper.json.mappingArray(keyPath)
//            return Observable.just(NKResult(value: result) as! Element)
//        })
//    }
//    
//    public func mapping(_ closure: @escaping (_ json: JSON) -> Any?) -> Observable<Element> {
//        return self.continueWithSuccessCloure({ (element) -> Observable<Element> in
//            guard let json = ((element as NKResult).value as? JSONWrapper)?.json else {
//                return Observable.just(NKResult(error: NKNetworkErrorType.unspecified(error: nil))  as! Element)
//            }
//            
//            return Observable.just(NKResult(value: closure(json)) as! Element)
//        })
//    }
//}
