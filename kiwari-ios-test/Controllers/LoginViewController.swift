//
//  ViewController.swift
//  kiwari-ios-test
//
//  Created by Meilissa Lee on 3/17/20.
//  Copyright © 2020 chataja. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var activityLoaderBg: UIView!
    @IBOutlet weak var activityLoader: NVActivityIndicatorView!
    
    var iconClick = true
    var viewModel: LoginViewModel!
    var validUsers: [User] = []
    
    lazy var listContact: ListContactController = { [weak self] in
        guard let controller = FlowControllers.listContactController else { return ListContactController() }
        return controller
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = LoginViewModel()
        self.loadValidUsers()
    }
    
    @IBAction func loginOnClick(_ sender: Any) {
        if (emailTxt.text! == "" || passwordTxt.text! == "") {
            let alert = UIAlertController(title: "Warning", message: "Email and Password cannot be empty.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if !(emailTxt.text!.isValid(regex: .email)) {
            let alert = UIAlertController(title: "Warning", message: "Email is not valid.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.view.endEditing(true)
            self.emailTxt.isEnabled = false
            self.passwordTxt.isEnabled = false
            self.showActivityLoader()
            self.executeLogin()
        }
    }
    
    func executeLogin() {
        if let idx = validUsers.firstIndex(where: { (user) -> Bool in
            user.email == emailTxt.text!
        }) {
            if validUsers[idx].password == self.passwordTxt.text! {
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: validUsers[idx])
                UserDefaults.standard.set(encodedData, forKey: "currentuser")
                self.loginSuccess(withName: validUsers[idx].name)
            } else {
                self.loginFailed()
            }
        } else {
            self.loginFailed()
        }
        self.emailTxt.isEnabled = true
        self.passwordTxt.isEnabled = true
    }
    
    func loginSuccess(withName name: String) {
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
            self.hideActivityLoader()
            guard let window = UIApplication.shared.windows.first else {
                return
            }
            window.rootViewController = self.listContact
            let options: UIView.AnimationOptions = .transitionCrossDissolve
            let duration: TimeInterval = 0.3
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion:
            { completed in
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            })
        }
    }
    
    func loginFailed() {
        self.hideActivityLoader()
        let alert = UIAlertController(title: "Warning", message: "Email atau Password salah.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension LoginViewController {
    func loadValidUsers() {
        if let viewModel = viewModel {
            viewModel.getValidUsers().observeCompleted {
                self.validUsers = viewModel.users
            }.dispose(in: self.reactive.bag)
        }
    }
}


extension LoginViewController {
    func showActivityLoader() {
        UIView.animate(withDuration: 0.1, animations: {
            self.activityLoaderBg.alpha = 1
            self.activityLoaderBg.isHidden = false
            self.activityLoader.startAnimating()
            self.view.layoutIfNeeded()
        })
    }
    
    func hideActivityLoader() {
        self.activityLoader.stopAnimating()
        self.activityLoaderBg.alpha = 0
        self.activityLoaderBg.isHidden = true
    }
}
