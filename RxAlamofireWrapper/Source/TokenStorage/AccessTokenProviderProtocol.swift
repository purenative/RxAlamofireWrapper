//
//  AccessTokenProviderProtocol.swift
//  RxAlamofireWrapper
//
//  Created by Artem Eremeev on 14.05.2020.
//  Copyright © 2020 Artem Eremeev. All rights reserved.
//

import Foundation

public typealias TokenRequestingCompletion = (Bool) -> Void
 
public protocol AccessTokenProviderProtocol {
    
    var accessTokenType: AccessTokenType { get }
    var tokenRefresher: AccessTokenRefresherProtocol { get }

    var accessToken: String? { get }
    var refreshToken: String? { get }
    
    var refreshing: Bool { get }
    
    func requestNewToken(onCompleted: @escaping TokenRequestingCompletion)
    
}
