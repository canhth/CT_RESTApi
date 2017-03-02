//
//  CT_RESTConstants.swift
//  CT_RESTAPI
//
//  Created by thcanh on 3/2/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import Foundation


public struct RESTContants {
    
    //MARK: RESTRequest Header Keys
    static let kDefineRESTRequestHeaderKey              = "Header"
    static let kDefineRESTRequestAuthorizationKey       = "Authorization"
    static let kDefineRESTRequestContentTypeKey         = "Content-Type"
    static let kDefineRESTRequestAcceptKey              = "Accept"
    
    //MARK: Keys for parser
    static let kDefineSuccessKeyFromResponseData        = "status"
    static let kDefineMessageKeyFromResponseData        = "message"
    static let kDefineDefaultMessageKeyFromResponseData = "unknow_error"
    
    //MARK: Prepairing request
    static let kDefineRequestTimeOut                    = 90.0
    static let kDefineStatusCodeSuccess                 = 200
    
    //MARK: Webservice url
    static let kDefineWebserviceUrl                     = "http://gameon.generdev.com/apis/"
    static let kDefineWebserviceResourceUrl             = ""
    static let kDefineWebserviceUploadImage             = "http://gameon.generdev.com/apis/updateProfilePicture.php"
    
    static let headers                                  = ["Content-Type" : "application/json"]
}


open class RESTEnum: NSObject {
    
    enum StatusCode: NSInteger {
        case success = 200
    }
    
    enum RequestMethod : String {
        case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
    }
    
    enum Endcoding : String {
        case URL, JSON, CUSTOM
    }
}


public enum RESTRequestBodyType {
    case json
    case form
}
