//
//  TestViewController.swift
//  Example
//
//  Created by tangbl93 on 2021/4/23.
//

import UIKit


import WSBinder
import whenTapped

class TestViewController: UIViewController {
    
    deinit {
        print("TestViewController deinit")
    }

    override func viewDidLoad() {
        
        let binder = WSBinder(self)
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        
        self.view.whenTapped {
            
            binder.strongify { (strongSelf) in
                NSLog("strongify")
            }
            
            binder.throttle(threshold: 3, dispatchQueue: dispatchQueue, context: "throttle") { (strongSelf) in
                NSLog("throttle")
            }
            
            binder.debounce(threshold: 3, dispatchQueue: dispatchQueue, context: "debounce") { (strongSelf) in
                NSLog("debounce")
            }
        }
    }
}
