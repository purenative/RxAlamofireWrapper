//
//  ApiTokenRefresher.swift
//  RxAlamofireWrapperExample
//
//  Created by Artem Eremeev on 14.05.2020.
//  Copyright © 2020 Artem Eremeev. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofireWrapper

class AccessTokenRefresher: AccessTokenRefresherProtocol {
    
    private let alamofireWrapper = AlamofireWrapper()
    
    private let tokenRefreshingEndpoint: URLConvertible = ""
    private let method: HTTPMethod = .post
    
    func refreshAccessToken(_ refreshToken: String, onCompleted: @escaping (TokenPair?) -> Void) {
        // example refresh reqeust body
        let json = [
            "refresh_token": refreshToken
        ]
        alamofireWrapper.dataRequest(tokenRefreshingEndpoint, method: method, json: json, onSuccess: { data in
            let newAccessToken = "" // parse data response
            let newRefreshToken = "" // parse data response
            let tokenPair = TokenPair(accessToken: newAccessToken, refreshToken: newRefreshToken)
            onCompleted(tokenPair) // you can pass nil if refreshing failed
        }, onError: { error in
            onCompleted(nil)
        })
    }
    
}
