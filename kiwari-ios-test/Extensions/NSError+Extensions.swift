//
//  NSError+Extensions.swift
//  kiwari-ios-test
//
//  Created by Meilissa Lee on 3/17/20.
//  Copyright © 2020 chataja. All rights reserved.
//

import UIKit
import SwiftyJSON

enum ErrorType: Int {
  case genericError = 0
  case invalidToken
}

extension NSError {
  convenience init(localizedDescription: String, code: ErrorType = .genericError) {
    self.init(domain: "", code: code.rawValue, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
  }
  
  convenience init(fromJSON json: JSON) {
    var errors = [String]()
    for (_, value) in json {
      if let errorMessages = value.arrayObject as? [String] {
        errors.append(contentsOf: errorMessages)
      }
    }
    self.init(localizedDescription: errors.joined(separator: "\n"))
  }
  
  convenience init(fromJSONToMessage json: JSON) {
    var errors = [String]()
    if let errorMessages = json["message"].string {
      errors.append(errorMessages)
    }
    self.init(localizedDescription: errors.joined(separator: "\n"))
  }
}
