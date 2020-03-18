//
//  ListContactController.swift
//  kiwari-ios-test
//
//  Created by Meilissa Lee on 3/17/20.
//  Copyright © 2020 chataja. All rights reserved.
//

import UIKit
import Kingfisher

class ListContactController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: ListContactViewModel!
    var users: [User] = []
    
    lazy var loginController: UIViewController = { [weak self] in
        guard let controller = FlowControllers.loginController else { return UIViewController() }
        return controller
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ListContactViewModel()
        self.setupTable()
        self.loadUsers()
    }
    
    func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: ContactCell.reuseID)
    }
    
    @IBAction func logoutOnClick(_ sender: Any) {
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        window.rootViewController = self.loginController
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.3
        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion:
        { completed in
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        })
    }

}

extension ListContactController {
    func loadUsers() {
        if let viewModel = viewModel {
            viewModel.getUsers().observeCompleted {
                self.users = viewModel.users
                self.tableView.reloadData()
            }.dispose(in: self.reactive.bag)
        }
    }
}

extension ListContactController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.reuseID, for: indexPath) as! ContactCell
        cell.usernameLabel.text = users[indexPath.row].name
        cell.avatarImg.cornerRadius = cell.avatarImg.frame.size.height/2
        cell.avatarImg.clipsToBounds = true
        if users[indexPath.row].avatar != "" {
            cell.avatarImg.kf.indicatorType = .activity
            cell.avatarImg.kf.setImage(with: URL(string: users[indexPath.row].avatar))
        }
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            guard let controller = FlowControllers.chatController else { return }
            controller.user = self.users[indexPath.row]
            self.present(controller, animated: true, completion: nil)
        }
    }
    
}
