//
//  CT_RESTAPI_Utils.swift
//  CT_RESTAPI
//
//  Created by thcanh on 3/2/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import Foundation
import RxSwift

public protocol CTArrayType {
    associatedtype Element
}

// MARK: - To Support generic func for array
extension Array: CTArrayType {}

public extension Observable {
    public func continueWithSuccessClosure(block: @escaping (_ element: Element) -> Observable<Element>) -> Observable<Element> {
        return self.flatMapLatest({ (element) -> Observable<Element> in
                return block(element)
        })
    }
}

