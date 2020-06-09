//
//  AccessTokenType.swift
//  RxAlamofireWrapper
//
//  Created by Artem Eremeev on 13.05.2020.
//  Copyright © 2020 Artem Eremeev. All rights reserved.
//

import Foundation

public enum AccessTokenType {
    case bearer
    case query(key: String)
    case custom(headerName: String, prefix: String)
    
    var forUseInHeader: Bool {
        switch self {
        case .bearer, .custom: return true
        default: return false
        }
    }
    var forUseInQuery: Bool {
        switch self {
        case .query: return true
        default: return false 
        }
    }
    
    var name: String {
        switch self {
        case .bearer: return "Authorization"
        case let .custom(headerName, _): return headerName
        case let .query(key): return key
        }
    }
    var prefix: String {
        switch self {
        case .bearer: return "Bearer"
        case let .custom(_, prefix): return prefix
        case .query: return ""
        }
    }
}
