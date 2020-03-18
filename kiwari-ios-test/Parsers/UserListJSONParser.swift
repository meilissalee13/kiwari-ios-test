//
//  UserListJSONParser.swift
//  kiwari-ios-test
//
//  Created by Meilissa Lee on 3/17/20.
//  Copyright © 2020 chataja. All rights reserved.
//

import SwiftyJSON
import ReactiveKit

class UserListJSONParser {
    var users = [User]()
    var error: NSError?
    
    init(_ json: JSON) {
        if let results = json["data"].array {
            for user in results {
                if let user = UserJSONParser(user).user {
                    users.append(user)
                }
            }
        } else {
            error = NSError(localizedDescription: "No results found")
        }
    }
    
    func toSignal() -> Signal<[User], NSError> {
        if let error = error {
            return Signal<[User], NSError>.failed(error)
        }
        return Signal<[User], NSError>(just: users)
    }
}

