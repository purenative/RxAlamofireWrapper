//
//  UploadingState.swift
//  RxAlamofireWrapper
//
//  Created by Artem Eremeev on 13.05.2020.
//  Copyright © 2020 Artem Eremeev. All rights reserved.
//

import Foundation

public enum UploadingState {
    case uploading(uploadRequestID: UUID?, progress: Double)
    case completed(uploadRequestID: UUID?, data: Data)
    
    public var uploadRequestID: UUID? {
        switch self {
        case let .uploading(uploadRequestID, _),
             let .completed(uploadRequestID, _):
            return uploadRequestID
        }
    }
}
