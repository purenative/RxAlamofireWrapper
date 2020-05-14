//
//  AccessTokenRefresher.swift
//  RxAlamofireWrapper
//
//  Created by Artem Eremeev on 14.05.2020.
//  Copyright © 2020 Artem Eremeev. All rights reserved.
//

import Foundation

public typealias TokenRefreshingCompletion = (TokenPair?) -> Void

public protocol AccessTokenRefresherProtocol {
    func refreshAccessToken(_ refreshToken: String, onCompleted: @escaping TokenRefreshingCompletion)
}
