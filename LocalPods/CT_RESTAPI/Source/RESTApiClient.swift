//
//  RESTApiClient.swift
//  CT_RESTAPI
//
//  Created by thcanh on 3/2/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import UIKit
import CocoaLumberjack
import ObjectMapper
import RxSwift
import Alamofire
import SwiftyJSON


/// The main class of CT_RESTAPI
open class RESTApiClient: NSObject {
    
    //MARK: - Variables
    public typealias RestAPICompletion = (_ result: Any?, _ error: RESTError?) -> Void
    fileprivate var baseUrl: String = ""
    var parameters: [String: Any] = [:]
    fileprivate var headers: [String: String] = RESTContants.headers
    fileprivate var multiparts = NSMutableArray()
    fileprivate var requestBodyType: RESTRequestBodyType
    fileprivate var requestMethod : HTTPMethod
    fileprivate var endcoding : ParameterEncoding
    fileprivate var mappingPath: String = ""
    fileprivate let disposeBag = DisposeBag()
    fileprivate let acceptableStatusCodes: [Int]
    
    //MARK: - Main functions
    
    /// Init RESTApiClient object
    ///
    /// - Parameters:
    ///   - subPath: Sub path of API URL
    ///   - functionName: last func of API URL
    ///   - method: API method
    ///   - endcoding: API endcoding
    public init(subPath: String, functionName: String, method : RequestMethod, endcoding: Endcoding) {
        
        // Set base url
        baseUrl = RESTContants.kDefineWebserviceUrl + subPath + (functionName.count == 0 ? "" : ("/" + functionName))
        requestBodyType = RESTRequestBodyType.json
        
        switch endcoding {
        case .JSON:
            self.endcoding = JSONEncoding.default
            break
        case .URL:
            self.endcoding = URLEncoding.default
            break
        case .CUSTOM:
            self.endcoding = URLEncoding.default
            break
        }
        
        switch method
        {
        case .GET:
            requestMethod = Alamofire.HTTPMethod.get
            break
        case .POST:
            requestMethod = Alamofire.HTTPMethod.post
            break
        case .PUT:
            requestMethod = Alamofire.HTTPMethod.put
            break
        case .DELETE:
            requestMethod = Alamofire.HTTPMethod.delete
            break
        default:
            requestMethod = Alamofire.HTTPMethod.get
            break
        }
        
        acceptableStatusCodes = Array(200..<300)
    }
    
    //MARK: - Properties
    open func setQueryParam(_ param: [String: Any]?)
    {
        parameters = param ?? ["" : ""]
    }
    
    open func addHeader(_ name: String, value: Any)
    {
        headers[name] = String(describing: value)
    }
    
    //MARK: - Base request
    
    /// Request with Decoable object
    ///
    /// - Returns: Observable<Decoable>
    open func requestObject<T: Decodable>() -> Observable<T?> {
        return baseRequest().autoMappingObject()
    }
    
    open func requestObjects<T: CTArrayType>(keyPath: String? = nil) -> Observable<T> where T.Element:  Decodable {
        let result : Observable<[T.Element]> = baseRequest().autoMappingArray(keyPath)
        return result.map {$0 as! T}
    }
    
    /// Request with ObjectMapper model
    ///
    /// - Parameter keyPath: keyPath of model
    /// - Returns: Observable<Mappable>
    open func requestObject<T: Mappable>(keyPath: String?) -> Observable<T?> {
        if let keyPath = keyPath {
            return baseRequest().autoMappingObject(keyPath)
        } else {
            return baseRequest().autoMappingObject()
        }
    }
    
    open func requestObjects<T: CTArrayType>(keyPath: String? = nil) -> Observable<T> where T.Element: Mappable {
        var result : Observable<[T.Element]>
        if let keyPath = keyPath {
            result  = baseRequest().autoMappingObjectsArray(keyPath)
        } else {
            result  = baseRequest().autoMappingObjectsArray()
        }
        return result.map {$0 as! T}
    }
    
    
    /// Base request functions
    ///
    /// - Returns: Response wapper steam
    open func baseRequest() -> Observable<ResponseWrapper> {
        return Observable.create { observer -> Disposable in 
            request(self.baseUrl,
                    method: self.requestMethod,
                    parameters: self.parameters)
                .validate()
                .validate(statusCode: self.acceptableStatusCodes)
                .responseData(queue: DispatchQueue.main, completionHandler: { [weak self] (response) in
                    
                    DDLogInfo("[\(Date().timeIntervalSince1970)] \(response.response?.statusCode ?? 0) \(self?.baseUrl ?? "") \(response.result.debugDescription) \(response.result.error?.localizedDescription ?? "")")
                    switch response.result {
                    case .success(_):
                        do {
                            let json = try JSON(data: response.data ?? Data())
                            let responseWrapper = ResponseWrapper(json: json, response: response)
                            observer.onNext(responseWrapper)
                            observer.onCompleted()
                        } catch {
                            observer.onError(RESTError(typeError: .unspecified(error: error)).toError())
                            DDLogInfo("Error when parsing JSON: \(error)")
                        }
                    case .failure(let error):
                        if let error = error as? URLError {
                            switch error.errorCode {
                            case -1009:
                                observer.onError(RESTError(typeError: .unspecified(error: error)).toError())
                                return
                            case NSURLErrorTimedOut:
                                observer.onError(RESTError(typeError: .timeout, code: error.errorCode).toError())
                                return
                            default: break
                            }
                        } 
                        observer.onError(RESTError.parseError(response.data, error: response.result.error).toError())
                    }
                })
            
            return Disposables.create {}
            }.do(onError: { (error) in
                //self.checkAuthorization(error)
            })
    }
    
    
}
