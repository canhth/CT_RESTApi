//
//  RESTApiClient.swift
//  CT_RESTAPI
//
//  Created by thcanh on 3/2/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import UIKit
import CocoaLumberjack
import RxSwift
import Alamofire


open class RESTApiClient: NSObject {

    public typealias RestAPICompletion = (_ result: Any?, _ error: RESTError?) -> Void
    public typealias RestDownloadProgress = (_ bytesRead : Int64, _ totalBytesRead : Int64, _ totalBytesExpectedToRead : Int64) -> Void

    
    fileprivate var ResultCompletion : (Any?, RESTError?)
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
    
    //MARK: Base
    public init(subPath: String, functionName: String, method : RequestMethod, endcoding: Endcoding) {
        
        //set base url
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
    
    //MARK: Properties
    open func setQueryParam(_ param: [String: Any]?)
    {
        parameters = param ?? ["" : ""]
    }
    
    open func addQueryParam(_ name: String, value: Any)
    {
        if let dataValue = value as? Data
        {
            parameters[name] = dataValue as Any?
        }
        else
        {
            parameters[name] = value
        }
    }
    
    open func addHeader(_ name: String, value: Any)
    {
        headers[name] = String(describing: value)
    }
    
    open func setContentType(_ contentType: String)
    {
        headers[RESTContants.kDefineRESTRequestContentTypeKey] = contentType
    }
    
    open func setAccept(_ accept: String)
    {
        headers[RESTContants.kDefineRESTRequestAcceptKey] = accept
    }
    
    open func setAuthorization(_ authorization: String)
    {
        headers[RESTContants.kDefineRESTRequestAuthorizationKey] = authorization
    }
     
    open func requestObject<T: Codable>() -> Observable<T?> {
        return baseRequest().autoMappingObject()
    }
    
    open func requestObjects<T: CTArrayType>(keyPath: String? = nil) -> Observable<T> where T.Element: Codable {
        let result : Observable<[T.Element]> = baseRequest().autoMappingArray(keyPath)
        return result.map {$0 as! T}
    }
    
    open func baseRequest() -> Observable<ResponseWrapper> {
        return Observable.create {[unowned self] observer -> Disposable in
            let completion: (AlamofireDataResponse) -> Void = {[weak self](response) -> Void in 
                let requestCode = "\(Date().timeIntervalSince1970)"
                DDLogInfo("[\(requestCode)] \(response.response?.statusCode ?? 0) \(self?.baseUrl ?? "") \(response.result.debugDescription) \(response.result.error?.localizedDescription ?? "")")
                
                switch response.result {
                case .success( let json ):
                    let responseWrapper = ResponseWrapper(response: response)
                    if responseWrapper.checkStatusCodeIsSuccess(json: json ) {
                        observer.onNext(responseWrapper)
                        observer.onCompleted()
                    } else {
                        observer.onError(RESTError.parseError(response.data, error: response.result.error).toError())
                    }
                case .failure(let error):
                    if let error = error as? URLError {
                        switch error.errorCode {
                        case -1009:
                            observer.onError(RESTError(typeError: .unspecified(error: error)).toError())
                            return
                        case NSURLErrorTimedOut:
                            observer.onError(RESTError(typeError: .timeout).toError())
                            return
                        default: break
                        }
                    }
                    observer.onError(RESTError.parseError(response.data, error: response.result.error).toError())
                }
            }
            
            
            request(self.baseUrl,
                    method: self.requestMethod,
                    parameters: self.parameters)
                .validate()
                .validate(statusCode: self.acceptableStatusCodes)
                .responseJSON(queue: DispatchQueue.main ,completionHandler: completion)
            
            return Disposables.create {}
            }.do(onError: { (error) in
                //self.checkAuthorization(error)
            })
    }

    
}
