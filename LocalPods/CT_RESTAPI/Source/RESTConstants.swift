//
//  CT_RESTConstants.swift
//  CT_RESTAPI
//
//  Created by thcanh on 3/2/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import Foundation

public struct RESTContants {
    
    //MARK: Keys for parser
    static let kDefineSuccessKeyFromResponseData        = "status"
    static let kDefineMessageKeyFromResponseData        = "message"
    static let kDefineDefaultMessageKeyFromResponseData = "unknow_error"
    
    //MARK: Prepairing request
    static let kDefineRequestTimeOut                    = 90.0
    static let kDefineStatusCodeSuccess                 = 200
    
    //MARK: Webservice url
    #if DEBUG
        static let kDefineWebserviceUrl                 = "http://api.themoviedb.org/3/"
    #else
        static let kDefineWebserviceUrl                 = "http://api.themoviedb.org/3/"
    #endif

    #if DEBUG
        public static let kDefineWebserviceResourceUrl             = "http://image.tmdb.org/t/p/"
    #else
        public static let kDefineWebserviceResourceUrl             = "http://image.tmdb.org/t/p/"
    #endif
    
    static let headers                                  = ["Content-Type" : "application/json"]
}

public enum StatusCode: NSInteger {
    case success = 200
}

public enum RequestMethod : String {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}

public enum Endcoding : String {
    case URL, JSON, CUSTOM
}


public enum RESTRequestBodyType {
    case json
    case form
}
