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
import SwiftyJSON
import ObjectMapper

public typealias AlamofireDataResponse = DataResponse<Data>


/// Response wrapper of Alamofire response
open class ResponseWrapper : NSObject
{
    open var response: AlamofireDataResponse?
    open var status: String = ""
    open var json: JSON = JSON([String: Any]())
    
    public init(json: JSON, response: AlamofireDataResponse? = nil) {
        self.response = response
        self.json = json
        super.init()
    }
}


public extension ResponseWrapper {
    
    /// Map an object to model T for Swift 4
    ///
    /// - Returns: T
    public func mappingObject<T>() -> T? where T: Decodable {
        
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
    
    /// Map an object to array model [T] for Swift 4
    ///
    /// - Returns: T
    public func mappingArray<T>(_ keyPath: String? = nil) -> [T] where T: Decodable {

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
    
    /// Map an object to model T for ObjectMapper
    ///
    /// - Returns: T
    public func mappingObject<T>(_ keyPath: String? = nil) -> T? where T: Mappable {
        let json: [String: Any]?
        
        if let keyPath = keyPath?.components(separatedBy: ".").map({$0 as JSONSubscriptType}) {
            json = self.json[keyPath].dictionaryObject
        } else {
            json = self.json.dictionaryObject
        }
        let result: T?
        if let json = json {
            result = Mapper<T>().map(JSON: json)
        } else {
            result = nil
        }
        
        return result
    }
    
    /// Map an object to array model T for ObjectMapper
    ///
    /// - Returns: [T]
    public func mappingArray<T>(_ keyPath: String? = nil) -> [T] where T: Mappable {
        let arrayJson: JSON
        if let keyPath = keyPath?.components(separatedBy: ".").map({$0 as JSONSubscriptType}) {
            arrayJson = self.json[keyPath]
        } else {
            arrayJson = self.json
        }
        
        var results = [T]()
        if let listResults = Mapper<T>().mapArray(JSONObject: arrayJson.arrayObject) {
            results = listResults
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


















