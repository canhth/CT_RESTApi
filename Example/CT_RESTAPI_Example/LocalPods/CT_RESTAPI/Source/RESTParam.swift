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
    
    convenience required public init?(map: Map) {
        self.init()
    }
    
    open func mapping(map: Map) {
        
    }
    
}
    
