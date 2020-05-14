//
//  UserDefaultsProvider.swift
//  RxAlamofireWrapper
//
//  Created by Artem Eremeev on 13.05.2020.
//  Copyright © 2020 Artem Eremeev. All rights reserved.
//

import Foundation

public class UserDefaultsProvider<T: Decodable> {
    
    let key: String
    
    var value: T? {
        get { return UserDefaults.standard.value(forKey: key) as? T }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
    
    init(key: String) {
        self.key = key
    }
    
}
