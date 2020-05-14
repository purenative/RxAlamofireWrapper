//
//  ViewController.swift
//  RxAlamofireWrapperExample
//
//  Created by Artem Eremeev on 13.05.2020.
//  Copyright © 2020 Artem Eremeev. All rights reserved.
//

import UIKit
import RxSwift
import RxAlamofireWrapper

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // default format
        let dataRequest = AlamofireWrapper.shared.dataRequest("some endpoint", method: .get, onSuccess: { data in
            
        }, onError: { error in
            
        })
        
        // reactive format
        AlamofireWrapper.shared.dataRequest("some endpoint", method: .get).subscribe(onSuccess: { data in
            
        }, onError: { error in
            
        }).disposed(by: disposeBag)
    }


}

