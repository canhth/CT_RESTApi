//
//  JSONWrapper.swift
//  CT_RESTAPI
//
//  Created by thcanh on 3/2/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

public typealias AlamofireDataResponse = DataResponse<Data>

open class JSONWrapper : NSObject
{
    open var json:JSON = JSON([String: Any]())
    open var response: AlamofireDataResponse?
    open var status: String = ""
    
    public init(json:JSON , response: AlamofireDataResponse? = nil) {
        self.json = json
        self.response = response
        
    }
}

