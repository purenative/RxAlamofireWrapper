//
//  AccessTokenStorage.swift
//  RxAlamofireWrapper
//
//  Created by Artem Eremeev on 13.05.2020.
//  Copyright © 2020 Artem Eremeev. All rights reserved.
//

import Foundation

public class AccessTokenProvider: AccessTokenProviderProtocol {
    
    public var accessToken: String? { return AccessTokenStorage.accessToken }
    public var refreshToken: String? { return AccessTokenStorage.refreshToken }
    
    public private(set) var accessTokenType: AccessTokenType
    public private(set) var tokenRefresher: AccessTokenRefresherProtocol?
    
    public private(set) var refreshing: Bool = false
    
    public init(accessTokenType: AccessTokenType, tokenRefresher: AccessTokenRefresherProtocol? = nil) {
        self.accessTokenType = accessTokenType
        self.tokenRefresher = tokenRefresher
    }
    
    public func requestNewToken(onCompleted: @escaping (Bool) -> Void) {
        guard let refreshToken = AccessTokenStorage.refreshToken else {
            onCompleted(false)
            return
        }
        refreshing = true
        guard let tokenRefresher = self.tokenRefresher else {
            onCompleted(true)
            return
        }
        tokenRefresher.refreshAccessToken(refreshToken, onCompleted: { tokenPair in
            if let tokenPair = tokenPair {
                AccessTokenStorage.accessToken = tokenPair.accessToken
                AccessTokenStorage.refreshToken = tokenPair.refreshToken
            }
            self.refreshing = false
            onCompleted(tokenPair != nil)
        })
    }
    
}
