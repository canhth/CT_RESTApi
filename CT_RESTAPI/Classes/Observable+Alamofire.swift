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
