//
//  FlowController.swift
//  kiwari-ios-test
//
//  Created by Meilissa Lee on 3/17/20.
//  Copyright © 2020 chataja. All rights reserved.
//

import UIKit

class FlowControllers {
    weak class var loginController: UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewControllerID")
        controller.modalPresentationStyle = .overFullScreen
        return controller
    }
    
    weak class var chatController: ChatController? {
        let controller: ChatController = ChatController(nibName: "ChatController", bundle: nil)
        controller.loadViewIfNeeded()
        controller.modalPresentationStyle = .overCurrentContext
        return controller
    }
    
    weak class var listContactController: ListContactController? {
        let controller: ListContactController = ListContactController(nibName: "ListContactController", bundle: nil)
        controller.loadViewIfNeeded()
        controller.modalPresentationStyle = .overCurrentContext
        return controller
    }
}
