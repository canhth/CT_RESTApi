//
//  CT_RESTAPI_Utils.swift
//  CT_RESTAPI
//
//  Created by thcanh on 3/2/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift

public protocol CTMappable {
    init?(json: JSON)
}


infix operator ++
func ++(left: String, right: String) -> String {
    return (left as NSString).appendingPathComponent(right)
}


public protocol CTArrayType {
    associatedtype Element
}

extension Array: CTArrayType {}


public extension UIImage {
    class func getImageProfileURL(fileName: String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsURL = paths[0]
        let filePath = documentsURL.appendingPathComponent(fileName)
        return filePath
    }
    
    class func getImageProfile(fileName: String) -> UIImage {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsURL = paths[0]
        let filePath = documentsURL.appendingPathComponent(fileName)
        let image  = UIImage(contentsOfFile: filePath.path)
        return image ?? UIImage(named: "ic_avatar")!
    }
}


public extension Observable {
    public func continueWithSuccessClosure(block: @escaping (_ element: Element) -> Observable<Element>) -> Observable<Element> {
        return self.flatMapLatest({ (element) -> Observable<Element> in
           
                return block(element)
            
        })
    }
}
