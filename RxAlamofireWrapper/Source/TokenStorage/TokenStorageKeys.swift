//
//  TokenStorageKeys.swift
//  RxAlamofireWrapper
//
//  Created by Artem Eremeev on 13.05.2020.
//  Copyright © 2020 Artem Eremeev. All rights reserved.
//

import Foundation

public enum TokenStorageKeys: String {
    case bearerTokenStorage
    
    var accessTokenKey: String {
        return "tokenProvider_\(rawValue)_accessToken"
    }
    var refreshTokenKey: String {
        return "tokenProvider_\(rawValue)_refreshToken"
    }
}
