//
//  AccessTokenStorage.swift
//  RxAlamofireWrapper
//
//  Created by Artem Eremeev on 13.05.2020.
//  Copyright © 2020 Artem Eremeev. All rights reserved.
//

import Foundation

public class AccessTokenProvider: AccessTokenProviderProtocol {
    
    public private(set) var accessTokenType: AccessTokenType
    public private(set) var tokenRefresher: AccessTokenRefresherProtocol?
    
    private let accessTokenStorage = UserDefaultsProvider<String>(key: TokenStorageKeys.bearerTokenStorage.accessTokenKey)
    public var accessToken: String? { return accessTokenStorage.value }
    
    private let refreshTokenStorage = UserDefaultsProvider<String>(key: TokenStorageKeys.bearerTokenStorage.refreshTokenKey)
    public var refreshToken: String? { return refreshTokenStorage.value }
    
    public private(set) var refreshing: Bool = false
    
    public init(accessTokenType: AccessTokenType, tokenRefresher: AccessTokenRefresherProtocol? = nil) {
        self.accessTokenType = accessTokenType
        self.tokenRefresher = tokenRefresher
    }
    
    public func requestNewToken(onCompleted: @escaping (Bool) -> Void) {
        guard let refreshToken = self.refreshTokenStorage.value else {
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
                self.accessTokenStorage.value = tokenPair.accessToken
                self.refreshTokenStorage.value = tokenPair.refreshToken
            }
            self.refreshing = false
            onCompleted(tokenPair != nil)
        })
    }
    
}
