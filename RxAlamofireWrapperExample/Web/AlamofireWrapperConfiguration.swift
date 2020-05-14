//
//  AlamofireWrapperConfiguration.swift
//  RxAlamofireWrapperExample
//
//  Created by Artem Eremeev on 14.05.2020.
//  Copyright © 2020 Artem Eremeev. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofireWrapper

class AlamofireWrapperConfiguration {
    
    static func setup() {
        let refresher = AccessTokenRefresher()
        let provider = AccessTokenProvider(accessTokenType: .bearer, tokenRefresher: refresher)
        let interceptor = AuthorizationRequestInterceptor(tokenProvider: provider)
        let session = Session(interceptor: interceptor)
        AlamofireWrapper.shared.configure(session: session)
    }
    
}
