//
//  AFWrapperError.swift
//  RxAlamofireWrapper
//
//  Created by Artem Eremeev on 20.05.2020.
//  Copyright © 2020 Artem Eremeev. All rights reserved.
//

import Foundation
import Alamofire

public enum AFWrapperError: Error, LocalizedError {
    
    case af(AFError)
    case api(statusCode: Int, data: Data)
    
    public var data: Data? {
        guard case let .api(_, data) = self else { return nil }
        return data
    }
    public var statusCode: Int? {
        guard case let .api(statusCode, _) = self else { return nil }
        return statusCode
    }
    
    public var localizedDescription: String {
        switch self {
        case let .af(afError): return afError.localizedDescription
        case let .api(statusCode, _): return "Status code: \(statusCode)"
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case let .af(afError): return afError.errorDescription
        case let .api(statusCode, _): return "Status code: \(statusCode)"
        }
    }
    
}

public extension Error {
    func asAFWrapperError() -> AFWrapperError? {
        return self as? AFWrapperError
    }
}
