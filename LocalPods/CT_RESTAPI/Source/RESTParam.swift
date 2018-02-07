//
//  RESTParam.swift
//  CT_RESTAPI
//
//  Created by thcanh on 3/2/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//


// FIXME: Use it when we have diffrent data in response with the same object
//public struct Safe<T: Decodable>: Decodable {
//    public let value: T?
//
//    public init(from decoder: Decoder) throws {
//        do {
//            let container = try decoder.singleValueContainer()
//            self.value = try container.decode(T.self)
//        } catch {
//            assertionFailure("ERROR: \(error)")
//            // TODO: automatically send a report about a corrupted data
//            self.value = nil
//        }
//    }
//}

public extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        let dictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
        return dictionary
    }
}
