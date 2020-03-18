//
//  UserJSONParser.swift
//  kiwari-ios-test
//
//  Created by Meilissa Lee on 3/17/20.
//  Copyright © 2020 chataja. All rights reserved.
//

import SwiftyJSON
import ReactiveKit

class UserJSONParser {
    var user: User?
    var error: NSError?
    
    init(_ json: JSON) {
        if let email = json["email"].string {
            user = User(email: email,
                        name: json["name"].stringValue,
                        password: json["password"].stringValue,
                        avatar: json["avatar"].stringValue)
        } else {
            error = NSError(fromJSON: json)
        }
    }
    
    func toSignal() -> Signal<User, NSError> {
        return Signal<User, NSError> { producer in
            if let error = self.error {
                producer.receive(completion: .failure(error))
            } else if let theUser = self.user {
                producer.receive(theUser)
            } else {
                producer.receive(completion: .failure(NSError(localizedDescription: "Unknown error")))
            }
            
            return NonDisposable.instance
        }
    }
}


