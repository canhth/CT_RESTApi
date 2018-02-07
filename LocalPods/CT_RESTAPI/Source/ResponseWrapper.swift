//
//  ResponseWrapper.swift
//  CT_RESTAPI
//
//  Created by thcanh on 3/2/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import Foundation
import Alamofire
import CocoaLumberjack

public typealias AlamofireDataResponse = DataResponse<Any>

open class ResponseWrapper : NSObject
{
    open var response: AlamofireDataResponse?
    open var status: String = ""
    
    public init(response: AlamofireDataResponse? = nil) {
        self.response = response
    }
}


public extension ResponseWrapper {
    
    public func mappingObject<T>() -> T? where T: Codable {
        
        var result: T?
        if let data = self.response?.data {
            do {
                result = try JSONDecoder().decode(T.self, from: data)
            } catch {
                DDLogInfo("Error when parsing JSON: \(error)")
            }
        }
        
        return result
    }
    
    public func mappingArray<T>(_ keyPath: String? = nil) -> [T] where T: Codable {
        
        var results = [T]()
        if let data = self.response?.data {
            do {
                if let _ = keyPath {
                    let dictResults = try JSONDecoder().decode([String: T].self, from: data)
                    results = dictResults.values.flatMap {$0}
                } else {
                    results = try JSONDecoder().decode([T].self, from: data)
                }
            } catch {
                DDLogInfo("Error when parsing JSON: \(error)")
            }
        }
        return results
    }
    
    
    public func checkStatusCodeIsSuccess(json: Any) -> Bool {
        if let jsonData = json as? [String: Any] {
            return (jsonData["status"] as? Bool) ?? false
        }
        return false
    }
}


















