//
//  CT_RESTError.swift
//  CT_RESTAPI
//
//  Created by thcanh on 3/2/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import Foundation
import Foundation
import SwiftyJSON

public enum CTNetworkErrorType: Error {
    public static let kNoNetwork = -1
    public static let kTimeout = -2
    public static let kUnauthorized = 401
    public static let kUnspecified = -3
    
    case noNetwork
    case unauthorized
    case timeout
    case errorMessage(code: Int, debug:String, message:String)
    case unspecified(error: Error?)
    
    public var errorCode: Int {
        switch self {
        case .noNetwork:
            return CTNetworkErrorType.kNoNetwork
        case .timeout:
            return CTNetworkErrorType.kTimeout
        case .errorMessage(let code, _, _):
            return code
        case .unspecified(_):
            return CTNetworkErrorType.kUnspecified
        default:
            return -999
        }
    }
}

open class RESTError: NSObject {
    
    open var errorFromResponse:  String = ""
    open var errorFromServer:    String = ""
    open var statusCode:         String = ""
    
    override init() {
        errorFromResponse = "" //set default string here
        errorFromServer = ""
    }
    
    init(typeError : CTNetworkErrorType) {
        switch typeError {
        case .noNetwork:
            errorFromResponse = "No network" //set default string here
            errorFromServer = "No network"
        case .timeout:
            errorFromResponse = "Request Timeout" //set default string here
            errorFromServer = "Request Timeout"
        case .unauthorized:
            errorFromResponse = "Unauthorized" //set default string here
            errorFromServer = "Unauthorized"
        case .unspecified:
            errorFromResponse = "Unspecified" //set default string here
            errorFromServer = "Unspecified"
        default:
            errorFromResponse = "" //set default string here
            errorFromServer = ""
        }
    }
    
    open static func parseError(_ responseData: Data?, error: Error?) -> RESTError {
        
        let restError: RESTError = RESTError.init()
        
        if (responseData != nil) {
            let jsonObj: JSON = JSON(data: responseData!)
            if (jsonObj.null == nil) {
                let message = jsonObj[RESTContants.kDefineMessageKeyFromResponseData].stringValue
                let statusCode = jsonObj[RESTContants.kDefineSuccessKeyFromResponseData].stringValue
                if(message.lengthOfBytes(using: String.Encoding.utf8) > 0) {
                    restError.errorFromServer = message
                    restError.statusCode = statusCode
                }
                else {
                    restError.errorFromServer = RESTContants.kDefineDefaultMessageKeyFromResponseData
                }
            }
            else {
                restError.errorFromServer = (NSString(data: responseData!, encoding: String.Encoding.utf8.rawValue) as String?)!
            }
        }
        
        if(error != nil) {
            let errorString: String! = error!.localizedDescription
            restError.errorFromResponse = errorString
        }
        
        return restError
    }
    
    open static func parseErrorFromJson(_ responseData: Any, error: Error?) -> RESTError {
        
        let restError: RESTError = RESTError.init()
        
        
        let jsonObj: JSON = JSON(responseData)
        if (jsonObj.null == nil) {
            let message = jsonObj[RESTContants.kDefineMessageKeyFromResponseData].stringValue
            let statusCode = jsonObj[RESTContants.kDefineSuccessKeyFromResponseData].stringValue
            if(message.lengthOfBytes(using: String.Encoding.utf8) > 0) {
                restError.errorFromServer = message
                restError.statusCode = statusCode
            }
            else {
                restError.errorFromServer = RESTContants.kDefineDefaultMessageKeyFromResponseData
            }
        }
        else {
            let responseJson = responseData as! [String: Any]
            restError.errorFromServer = (responseJson[RESTContants.kDefineMessageKeyFromResponseData] as! String?)!
        }
        
        
        if(error != nil) {
            let errorString: String! = error!.localizedDescription
            restError.errorFromResponse = errorString
        }
        
        return restError
    }
    
    open func toError() -> Error {
        return CTNetworkErrorType.errorMessage(code: Int(statusCode) ?? 0, debug: errorFromResponse, message: errorFromServer)
    }
}
