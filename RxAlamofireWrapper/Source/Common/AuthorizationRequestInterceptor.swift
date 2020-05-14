//
//  RequestInterceptor.swift
//  RxAlamofireWrapper
//
//  Created by Artem Eremeev on 13.05.2020.
//  Copyright © 2020 Artem Eremeev. All rights reserved.
//

import Foundation
import Alamofire

public class AuthorizationRequestInterceptor: Alamofire.RequestInterceptor {
    
    private let tokenProvider: AccessTokenProviderProtocol?
    
    public init(tokenProvider: AccessTokenProviderProtocol? = nil) {
        self.tokenProvider = tokenProvider
    }
    
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        var urlRequest = urlRequest
        
        guard let tokenProvider = self.tokenProvider, let accessToken = tokenProvider.accessToken else {
            completion(.success(urlRequest))
            return
        }
        
        urlRequest.headers.update(name: tokenProvider.accessTokenType.headerName, value: "\(tokenProvider.accessTokenType.prefix) \(accessToken)")
        completion(.success(urlRequest))
        
    }
    
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            return completion(.doNotRetryWithError(error))
        }
        
        guard let tokenProvider = tokenProvider else {
            return completion(.doNotRetryWithError(error))
        }
        
        guard !tokenProvider.refreshing else {
            completion(.retryWithDelay(0.5))
            return
        }
        
        tokenProvider.requestNewToken(onCompleted: { success in
            if success {
                completion(.retry)
            } else {
                completion(.doNotRetryWithError(error))
            }
        })
        
    }
    
}
