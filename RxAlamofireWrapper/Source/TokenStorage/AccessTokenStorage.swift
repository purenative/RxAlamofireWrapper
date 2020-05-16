//
//  AccessTokenStorage.swift
//  RxAlamofireWrapper
//
//  Created by Artem Eremeev on 16.05.2020.
//  Copyright © 2020 Artem Eremeev. All rights reserved.
//

import Foundation

public class AccessTokenStorage {
    
    private static let accessStorage = UserDefaultsProvider<String>(key: TokenStorageKeys.bearerTokenStorage.accessTokenKey)
    public static var accessToken: String? {
        get { return accessStorage.value }
        set { accessStorage.value = newValue }
    }
    
    private static let refreshStorage = UserDefaultsProvider<String>(key: TokenStorageKeys.bearerTokenStorage.refreshTokenKey)
    public static var refreshToken: String? {
        get { return refreshStorage.value }
        set { refreshStorage.value = newValue }
    }
    
}
