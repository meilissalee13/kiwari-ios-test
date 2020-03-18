//
//  APIInterface.swift
//  kiwari-ios-test
//
//  Created by Meilissa Lee on 3/17/20.
//  Copyright © 2020 chataja. All rights reserved.
//

import ReactiveKit
import SwiftyJSON

class ApiInterface {
    class func getValidUserList() -> Signal<[User], NSError> {
        if let path : String = Bundle.main.path(forResource: "user_list", ofType: "json") {
            if let data = NSData(contentsOfFile: path) {
                let json = try! JSON(data: data as Data)
                return UserListJSONParser(json).toSignal()
            }
        }
        return Signal<[User], NSError>.failed(NSError(localizedDescription: "Unknown Error"))
    }
}
