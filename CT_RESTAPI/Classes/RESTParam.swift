//
//  RESTParam.swift
//  CT_RESTAPI
//
//  Created by thcanh on 3/2/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import Foundation
import ObjectMapper

open class RESTParam: NSObject, Mappable {
    
    override init() {
        super.init()
    }
    
    convenience required public init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
        
    }
    
    func toDictionary() -> [String : Any] {
        return self.toJSON()
    }
}
    
