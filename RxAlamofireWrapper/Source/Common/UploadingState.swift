//
//  UploadingState.swift
//  RxAlamofireWrapper
//
//  Created by Artem Eremeev on 13.05.2020.
//  Copyright © 2020 Artem Eremeev. All rights reserved.
//

import Foundation

public enum UploadingState {
    case uploading(progress: Double)
    case completed(data: Data)
}
