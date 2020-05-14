//
//  TokenPair.swift
//  RxAlamofireWrapper
//
//  Created by Artem Eremeev on 14.05.2020.
//  Copyright © 2020 Artem Eremeev. All rights reserved.
//

import Foundation

public class TokenPair {
    let accessToken: String?
    let refreshToken: String?
    
    public init(accessToken: String?, refreshToken: String?) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
