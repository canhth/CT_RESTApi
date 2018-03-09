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

public extension Observable where Element: ResponseWrapper {
    
    /// Auto Mapping object with Decodable
    ///
    /// - Returns: Observable<T>
    public func autoMappingObject<T>() -> Observable<T?> where T: Decodable {
        
        return self.flatMapLatest({ (responseWrapper) -> Observable<T?> in
            
            guard let object: T? = responseWrapper.mappingObject() else { return Observable<T?>.just(nil) }
            return Observable<T?>.just(object)
        })
    }
    
    /// Auto Mapping array objects with Decodable
    ///
    /// - Returns: Observable<T>
    public func autoMappingArray<T>(_ keyPath: String? = nil) -> Observable<[T]> where T: Decodable {
        return self.flatMapLatest({ (responseWrapper) -> Observable<[T]> in
            let object: [T] = responseWrapper.mappingArray(keyPath)
            return Observable<[T]>.just(object)
        })
    }
    
    /// Auto Mapping object with ObjectMapper model
    ///
    /// - Returns: Observable<T>
    public func autoMappingObject<T>(_ keyPath: String? = nil) -> Observable<T?> where T: Mappable {
        
        return self.flatMapLatest({ (jsonWrapper) -> Observable<T?> in
            
            let jsonWrapper = jsonWrapper as ResponseWrapper
            let object: T? = jsonWrapper.mappingObject(keyPath)
            
            return Observable<T?>.just(object)
        })
    }
    
    /// Auto Mapping Array object with ObjectMapper model
    ///
    /// - Returns: Observable<T>
    public func autoMappingObjectsArray<T>(_ keyPath: String? = nil) -> Observable<[T]> where T: Mappable {
        return self.flatMapLatest({ (jsonWrapper) -> Observable<[T]> in
            
            let jsonWrapper = jsonWrapper as ResponseWrapper
            let object: [T] = jsonWrapper.mappingArray(keyPath)
            
            return Observable<[T]>.just(object)
        })
    }
}
