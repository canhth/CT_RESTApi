//
//  JSON+Alamofire.swift
//  CT_RESTAPI
//
//  Created by thcanh on 3/2/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

public protocol CTAlamofireKey: JSONSubscriptType {
    var rawValue: String {get}
}

public extension ObjectMapper.Map {
    public subscript (key: CTAlamofireKey) -> ObjectMapper.Map {
        return self[key.rawValue]
    }
    public subscript (key: CTAlamofireKey, nested nested: Bool) -> ObjectMapper.Map {
        return self[key.rawValue, nested: nested]
    }
    public subscript (key: CTAlamofireKey, ignoreNil ignoreNil: Bool) -> ObjectMapper.Map {
        return self[key.rawValue, ignoreNil: ignoreNil]
    }
    public subscript (key: CTAlamofireKey, nested nested: Bool, ignoreNil ignoreNil: Bool) -> ObjectMapper.Map {
        return self[key.rawValue, nested: nested, ignoreNil: ignoreNil]
    }
}

public extension CTAlamofireKey {
    public var jsonKey: JSONKey {
        return JSONKey.key(self.rawValue)
    }
}

public extension JSON {
    public func mappingObject<T>(_ keyPath: String? = nil) -> T? where T: Mappable {
        let json: [String: Any]?
        
        if let keyPath = keyPath?.components(separatedBy: ".").map({$0 as JSONSubscriptType}) {
            json = self[keyPath].dictionaryObject
        } else {
            json = self.dictionaryObject
        }
        let result: T?
        if let json = json {
            result = Mapper<T>().map(JSON: json)
        } else {
            result = nil
        }
        
        return result
    }
    
    public func mappingArray<T>(_ keyPath: String? = nil) -> [T] where T: Mappable {
        let arrayJson: JSON
        if let keyPath = keyPath?.components(separatedBy: ".").map({$0 as JSONSubscriptType}) {
            arrayJson = self[keyPath]
        } else {
            arrayJson = self
        }
        
        var results = [T]()
        if let listResults = Mapper<T>().mapArray(JSONObject: arrayJson) {
            results = listResults
        }
        return results
    }
    
    public func mappingObject<T>(_ keyPath: String? = nil) -> T? where T: CTMappable {
        let json: JSON
        if let keyPath = keyPath?.components(separatedBy:".").map({$0 as JSONSubscriptType}) {
            json = self[keyPath]
        } else {
            json = self
        }
        
        return T.init(json: json)
    }
    
    public func mappingArray<T>(_ keyPath: String? = nil) -> [T] where T: CTMappable {
        let arrayJson: JSON
        if let keyPath = keyPath?.components(separatedBy:".").map({$0 as JSONSubscriptType}) {
            arrayJson = self[keyPath]
        } else {
            arrayJson = self
        }
        
        var result = [T]()
        for (_, json) in arrayJson {
            if let object: T = json.mappingObject() {
                result.append(object)
            }
        }
        
        return result
    }
}
