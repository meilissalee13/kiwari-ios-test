//
//  LoginViewModel.swift
//  kiwari-ios-test
//
//  Created by Meilissa Lee on 3/17/20.
//  Copyright © 2020 chataja. All rights reserved.
//

import UIKit
import ReactiveKit

class LoginViewModel {
    var users: [User] = []
    
    init() {
        print("init")
    }
    
    deinit {
        print("deinit")
    }
    
    func getValidUsers() -> Signal<Void, NSError> {
        return ApiInterface.getValidUserList().map { (data) -> Void in
            self.users = data
        }
    }
}
