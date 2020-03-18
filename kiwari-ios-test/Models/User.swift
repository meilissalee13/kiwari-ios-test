//
//  User.swift
//  kiwari-ios-test
//
//  Created by Meilissa Lee on 3/17/20.
//  Copyright © 2020 chataja. All rights reserved.
//

import UIKit

public class User: NSObject, NSCoding {
    var email : String
    var name : String
    var password : String
    var avatar : String
    
    init(email: String = "", name: String = "", password: String = "", avatar: String = "") {
        self.email = email
        self.name = name
        self.password = password
        self.avatar = avatar
    }
    
    required convenience public init(coder aDecoder: NSCoder) {
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let password = aDecoder.decodeObject(forKey: "password") as! String
        let avatar = aDecoder.decodeObject(forKey: "avatar") as! String
        self.init(email: email, name: name, password: password, avatar: avatar)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(email, forKey: "email")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(password, forKey: "password")
        aCoder.encode(avatar, forKey: "avatar")
    }
}
