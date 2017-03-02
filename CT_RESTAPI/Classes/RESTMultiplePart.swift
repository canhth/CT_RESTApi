//
//  RESTMultiplePart.swift
//  CT_RESTAPI
//
//  Created by thcanh on 3/2/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import Foundation
import SwiftyJSON

open class RESTMultipart: NSObject {
    
    open var name: String! = ""
    open var contentType: String! = ""
    open var data: Data!
    
    init(name: String!, contentType: String!, data: Data!) {
        self.name = name
        self.contentType = contentType
        self.data = data
    }
    
    open func getHeader() -> [String: String] {
        return ["Content-Disposition" : "form-data; name=\(self.name)", "Content-Type" :  self.contentType]
    }
    
    open class JSONPart: RESTMultipart {
        init(name: String!, jsonObject: NSObject) {
            let data: Data! = NSKeyedArchiver.archivedData(withRootObject: JSON.init(jsonObject).dictionaryObject!)
            
            super.init(name: name, contentType: "application/json; charset=UTF-8", data: data)
        }
    }
    
    open class FilePart: RESTMultipart {
        var fileName: String!
        
        init(name: String!, fileName: String!, data: Data!) {
            super.init(name: name, contentType: "application/octet-stream", data: data)
            self.fileName = fileName
        }
        
        override open func getHeader() -> [String: String] {
            var header = super.getHeader()
            header["Content-Disposition"] = "form-data; name=\"\(self.name)\"; filename=\"\(self.fileName)\""
            return header
        }
    }
}
