//
//  CT_RESTError.swift
//  CT_RESTAPI
//
//  Created by thcanh on 3/2/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import Foundation

public enum CTNetworkErrorType: Error {
    public static let kNoNetwork = -1
    public static let kTimeout = -2
    public static let kUnauthorized = 401
    public static let kUnspecified = -3
    
    case noNetwork
    case unauthorized
    case timeout
    case errorMessage(code: Int, status:Bool, message:String)
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

open class RESTError: Codable {
    
    open var errorFromResponse:  String = ""
    open var status:         Bool = false
    open var HTTP_response_code: Int = 404
    
    private enum ErrorKey: String, CodingKey {
        case errorResponse = "message"
    }
    
    init(typeError : CTNetworkErrorType) {
        switch typeError {
        case .noNetwork:
            errorFromResponse = "No network" //set default string here
        case .timeout:
            errorFromResponse = "Request Timeout" //set default string here
        case .unauthorized:
            errorFromResponse = "Unauthorized" //set default string here
        case .unspecified:
            errorFromResponse = "Unspecified" //set default string here
        default:
            errorFromResponse = "" //set default string here
        }
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ErrorKey.self)
        errorFromResponse = try values.decode(String.self, forKey: .errorResponse)

    }
    
    open static func parseError(_ responseData: Data?, error: Error?) -> RESTError {
        
        var restError: RESTError = RESTError.init(typeError: .noNetwork)
        
        if let responseData = responseData {
            do {
                let decoder = JSONDecoder()
                restError = try decoder.decode(RESTError.self, from: responseData)
            } catch { print(error) }
        }
        else {
            restError.errorFromResponse = (NSString(data: responseData!, encoding: String.Encoding.utf8.rawValue) as String?)!
        }
        
        if (error != nil) {
            let errorString: String! = error!.localizedDescription
            restError.errorFromResponse = errorString
        }
        
        return restError
    }
    

    open func toError() -> Error {
        return CTNetworkErrorType.errorMessage(code: HTTP_response_code, status: status, message: errorFromResponse)
    }
}
