//
//  ViewController.swift
//  RxAlamofireWrapperExample
//
//  Created by Artem Eremeev on 13.05.2020.
//  Copyright © 2020 Artem Eremeev. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire
import RxAlamofireWrapper

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // default format
        let dataRequest = AlamofireWrapper.shared.dataRequest("some endpoint", method: .get, onSuccess: { data in

        }, onError: { error in
            if let afwError = error.asAFWrapperError() {

                // error handling 1st type
                switch afwError {
                case let .af(afError): // error from alamofire
                    print(afError.localizedDescription)
                    // do something there...

                case let .api(statusCode, data): // error from api response
                    print("status code: \(statusCode)")
                    // do something there...
                }

                // or
                // error handling 2nd type
                guard let statusCode = afwError.statusCode, let data = afwError.data else {
                    return
                }
                print("status code: \(statusCode)")
                // do something there...

            } else {
                // other errors
                // do something there...
            }
        })
    }


}

