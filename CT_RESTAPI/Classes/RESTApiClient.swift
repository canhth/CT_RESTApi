//
//  RESTApiClient.swift
//  CT_RESTAPI
//
//  Created by thcanh on 3/2/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import UIKit
import CocoaLumberjack
import SwiftyJSON
import ObjectMapper
import RxAlamofire
import RxSwift
import Alamofire


public class RESTApiClient: NSObject {

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
    init(subPath: String, functionName: String, method : RESTEnum.RequestMethod, endcoding: RESTEnum.Endcoding) {
        
        //set base url
        baseUrl = RESTContants.kDefineWebserviceUrl + subPath + (functionName.characters.count == 0 ? "" : ("/" + functionName))
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
    open func setQueryParam(_ param: RESTParam)
    {
        parameters = param.toDictionary()
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
    
    open func addPartJson(_ name: String, model: NSObject)
    {
        let part = RESTMultipart.JSONPart(name: name, jsonObject: model)
        self.multiparts.add(part)
    }
    
    open func addPartFile(_ name: String, fileName: String, data: Data)
    {
        let part = RESTMultipart.FilePart(name: name, fileName: fileName, data: data)
        self.multiparts.add(part)
    }
    
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
           result  = baseRequest().autoMappingArray(keyPath)
        } else {
           result  = baseRequest().autoMappingArray()
        }
        return result.map {$0 as! T}
    }
    
    open func baseRequest() -> Observable<JSONWrapper> {
        return Observable.create {[unowned self] observer -> Disposable in
            let completion: (AlamofireDataResponse) -> Void = {[weak self](response) -> Void in
                let json = JSON(data: response.data ?? Data())
                let requestCode = "\(Date().timeIntervalSince1970)"
                DDLogInfo("[\(requestCode)] \(response.response?.statusCode ?? 0) \(self?.baseUrl) \(json) \(response.result.error?.localizedDescription ?? "")")
                
                switch response.result {
                case .success(_):
                    let jsonWrapper = JSONWrapper(json: json, response: response)
                    if let statusCode = Int(json["status"].stringValue), statusCode < 300 {
                        observer.onNext(jsonWrapper)
                        observer.onCompleted()
                    } else {
                        observer.onError(RESTError.parseErrorFromJson(json, error: response.result.error).toError())
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
                .responseData(queue: DispatchQueue.main, completionHandler: completion)
            
            return Disposables.create {}
            }.do(onError: { (error) in
                //self.checkAuthorization(error)
            })
    }

    open func baseUpload(keyName: String, imageName: String, _ completion: @escaping RestAPICompletion)
    {
        
        if let imageData = try? Data(contentsOf: UIImage.getImageProfileURL(fileName: imageName)) {
            
            Alamofire.upload( multipartFormData: { multipartFormData in
                
                multipartFormData.append(imageData, withName: "image", fileName: imageName, mimeType: "image/png")
                
                for (key, value) in self.parameters {
                    multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, to: RESTContants.kDefineWebserviceUploadImage
                , encodingCompletion: { (result) in
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (Progress) in
                            print("Upload Progress: \(Progress.fractionCompleted)")
                        })
                        
                        upload.responseJSON { response in
                            
                            if let JSON = response.result.value {
                                print("JSON: \(JSON)")
                                completion(JSON, nil)
                            }
                        }
                        
                    case .failure(let encodingError):
                        let restError = RESTError()
                        restError.errorFromServer = encodingError.localizedDescription
                        completion(nil, restError)
                    }
                    
            })
        }
        
    }
    
    func imageType(_ imgData : Data) -> String
    {
        var c = [UInt8](repeating: 0, count: 1)
        (imgData as NSData).getBytes(&c, length: 1)
        
        let ext : String
        
        switch (c[0])
        {
        case 0xFF: ext = "jpg"
            
        case 0x89: ext = "png"
            
        case 0x47: ext = "gif"
            
        case 0x49, 0x4D : ext = "tiff"
            
        default: ext = "" //unknown
        }
        
        return ext
    }
    
}
