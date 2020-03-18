//
//  Message.swift
//  kiwari-ios-test
//
//  Created by Meilissa Lee on 3/18/20.
//  Copyright © 2020 chataja. All rights reserved.
//

import UIKit

struct Message {
    var user : User!
    var date: String = ""
    var message: String = ""
    
    init(user: User, date: String, message: String) {
        self.user = user
        self.date = date
        self.message = message
    }
}
