//
//  ChatViewController.swift
//  Intranet
//
//  Created by Владислав on 28.06.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    @IBOutlet weak var newConnectionButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var chats: [Chat] = []
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        logOutAlert()
    }
    
    @IBAction func newConnectionButtonPreesed(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
               
        tableView.register(UINib(nibName: String(describing: ChatCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: ChatCell.self))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkAuthorization()
    }
    
    func checkAuthorization() {
        if UserAuthorization.shared.isAuthorized {
            isAuthorized()
        } else {
            isNotAuthorized()
        }
    }
    
    func isNotAuthorized(){
        logOutButton.isEnabled = false
        newConnectionButton.isEnabled = false
        tableView.isHidden = true
        chats = []

        authorizationAlert()

    }
    
    func isAuthorized(){
        logOutButton.isEnabled = true
        newConnectionButton.isEnabled = true
        tableView.isHidden = false
        
        getLocalChats()
    }
    
    func getLocalChats() {
        chats = ChatsStorageManager.shared.getChats().sorted { (first, second) -> Bool in
            let firstString = first.interlocutorSurname + " " + first.interlocutorName
            let secondString = second.interlocutorSurname + " " + second.interlocutorName
            return firstString < secondString
        }
        tableView.reloadData()
    }
    
    //MARK: Alerts
    
    func authorizationAlert(){
        
        let allert = UIAlertController(title: "You are not authorized", message: "To continue, you should authorize", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Authorize", style: .default) { [weak self] _ in
            
            let destinationViewController = ProfileViewController.makeVC()
            
            self?.navigationController?.pushViewController(destinationViewController, animated: true)
        }
        
        allert.addAction(okAction)
        present(allert, animated: true)
    }
    
    func logOutAlert(){
        
        let allert = UIAlertController(title: "Attention!", message: "Do you really want to log out? You should remember that you account is connected with your device.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Log out", style: .default) { [weak self] _ in
            self?.activityIndicator.startAnimating()
            
            UsersStorageManager.shared.deleteUser {
                self?.activityIndicator.stopAnimating()
                self?.successlogOutAlert()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            
        }
        
        allert.addAction(okAction)
        allert.addAction(cancelAction)
        present(allert, animated: true)
    }
    
    func successlogOutAlert(){
        
        let allert = UIAlertController(title: "Success!", message: "You log out successfuly!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            self?.checkAuthorization()
        }
        
        allert.addAction(okAction)
        present(allert, animated: true)
    }
    
}

extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        guard
            let chatCell = tableView.cellForRow(at: indexPath) as? ChatCell,
            let chat = chatCell.chat
        else { return }

        let destinationViewController = LocalMessagesViewController.makeVC(with: chat)

        navigationController?.pushViewController(destinationViewController, animated: true)
    }
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let chat = chats[indexPath.row]
        
        let identifier = String(describing: ChatCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ChatCell else { return ChatCell() }
        
        cell.configure(with: chat)
        
        return cell
    }
    
    
}
