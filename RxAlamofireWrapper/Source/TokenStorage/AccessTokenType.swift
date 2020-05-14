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
    case custom(headerName: String, prefix: String)
    
    var headerName: String {
        switch self {
        case .bearer: return "Authorization"
        case let .custom(headerName, _): return headerName
        }
    }
    var prefix: String {
        switch self {
        case .bearer: return "Bearer"
        case let .custom(_, prefix): return prefix
        }
    }
}
