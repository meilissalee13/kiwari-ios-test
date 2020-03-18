//
//  ChatController.swift
//  kiwari-ios-test
//
//  Created by Meilissa Lee on 3/17/20.
//  Copyright © 2020 chataja. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class ChatController: UIViewController {

    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTxt: UITextField!
    @IBOutlet weak var inputViewBottomConstraint: NSLayoutConstraint!
    
    var user: User!
    var messages: [Message] = []
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingFireStore()
        self.setupTable()
        self.inputTxt.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(ChatController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getRoomMessages()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func settingFireStore() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    func setupTable() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: MessageCell.reuseID)
    }
    
    func setupUI() {
        self.avatarImg.cornerRadius = self.avatarImg.frame.size.height/2
        self.avatarImg.clipsToBounds = true
        if user.avatar != "" {
            self.avatarImg.kf.indicatorType = .activity
            self.avatarImg.kf.setImage(with: URL(string: user.avatar))
        }
        self.usernameLabel.text = user.name
    }
    
    @IBAction func backOnClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendOnClick(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .long
        let currentDate = formatter.string(from: Date())
        
        let newMessage = Message(id: -1, user: self.currentUser(), date: currentDate, message: self.inputTxt.text!)
        self.addNewMessage(newMessage)
        self.inputTxt.text = ""
    }
    
    func loadLastMessages() {
        if (!self.messages.isEmpty) {
            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func currentUser() -> User {
        guard let data = UserDefaults.standard.data(forKey: "currentuser") else { return User() }
        return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! User
    }
    
    func addNewMessage(_ msg: Message) {
        var ref: DocumentReference? = nil
        ref = db.collection("messages").addDocument(data: [
            "id": self.messages.count,
            "rooms": ["\(self.user.email)+\(self.currentUser().email)", "\(self.currentUser().email)+\(self.user.email)"],
            "date": msg.date,
            "msg": msg.message,
            "sender_email": msg.user.email,
            "sender_name": msg.user.name,
            "sender_avatar": msg.user.avatar
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func getRoomMessages() {
        db.collection("messages")
            .whereField("rooms", arrayContainsAny: ["\(self.user.email)+\(self.currentUser().email)", "\(self.currentUser().email)+\(self.user.email)"])
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error retreiving snapshots \(error!)")
                    return
                }
                let msgs = snapshot.documents.sorted(by: { $1["id"] as! Int > $0["id"] as! Int }).map { $0.data() }
                if msgs.count > 0 {
                    for msg in msgs {
                        let newMsg = Message(id: msg["id"] as! Int, user: User(email: msg["sender_email"] as! String, name: msg["sender_name"] as! String, avatar: msg["sender_avatar"] as! String), date: msg["date"] as! String, message: msg["msg"] as! String)
                        if !self.messages.contains(where: { (msg_) -> Bool in
                            msg_.id == newMsg.id
                        }) {
                            self.messages.append(newMsg)
                        }
                    }
                    self.tableView.reloadData()
                    self.loadLastMessages()
                }
            }
    }
}

extension ChatController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseID, for: indexPath) as! MessageCell
        cell.dateLabel.text = messages[indexPath.row].date
        cell.messageLabel.text = messages[indexPath.row].message
        cell.nameLabel.text = messages[indexPath.row].user.name
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
}

extension ChatController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}

extension ChatController {
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.inputViewBottomConstraint.constant = keyboardSize.height
        }

    }

    @objc func keyboardWillHide(notification: Notification) {
        self.inputViewBottomConstraint.constant = 0
    }
}
