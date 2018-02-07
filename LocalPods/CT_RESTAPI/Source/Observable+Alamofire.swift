//
//  Observable+Alamofire.swift
//  CT_RESTAPI
//
//  Created by thcanh on 3/2/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import Foundation
import RxSwift

public extension Observable where Element: ResponseWrapper {
    public func autoMappingObject<T>() -> Observable<T?> where T: Codable {
        
        return self.flatMapLatest({ (responseWrapper) -> Observable<T?> in
            
            guard let object: T? = responseWrapper.mappingObject() else { return Observable<T?>.just(nil) }
            return Observable<T?>.just(object)
        })
    }
    
    public func autoMappingArray<T>(_ keyPath: String? = nil) -> Observable<[T]> where T: Codable {
        return self.flatMapLatest({ (responseWrapper) -> Observable<[T]> in
            let object: [T] = responseWrapper.mappingArray(keyPath)
            return Observable<[T]>.just(object)
        })
    }
}
