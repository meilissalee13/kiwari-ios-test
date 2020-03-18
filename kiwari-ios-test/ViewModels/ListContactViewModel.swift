//
//  ListContactViewModel.swift
//  kiwari-ios-test
//
//  Created by Meilissa Lee on 3/17/20.
//  Copyright © 2020 chataja. All rights reserved.
//

import UIKit
import ReactiveKit

class ListContactViewModel {
    var users: [User] = []
    
    init() {
        print("init")
    }
    
    deinit {
        print("deinit")
    }
    
    func getUsers() -> Signal<Void, NSError> {
        return ApiInterface.getValidUserList().map { (data) -> Void in
            self.users = data.filter({ (user) -> Bool in
                return user.email != self.currentUser().email
            })
        }
    }
    
    func currentUser() -> User {
        guard let data = UserDefaults.standard.data(forKey: "currentuser") else { return User() }
        return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! User
    }
}
