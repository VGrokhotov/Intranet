//
//  LocalMessagesViewController.swift
//  Intranet
//
//  Created by Владислав on 30.06.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

class LocalMessagesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var chat: Chat?
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = (chat?.interlocutorSurname ?? "") + " " + (chat?.interlocutorName ?? "")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
               
        tableView.register(UINib(nibName: String(describing: ChatCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: ChatCell.self))
    }
    
    static func makeVC(with chat: Chat) -> LocalMessagesViewController {
        
        let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: LocalMessagesViewController.self)) as? LocalMessagesViewController
        
        guard let newVC = newViewController else { return LocalMessagesViewController() }
        
        newVC.chat = chat
        
        return newVC
    }
}

extension LocalMessagesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension LocalMessagesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        let identifier = String(describing: MessageCell.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MessageCell else { return MessageCell() }
        
        cell.configure(with: message)
        
        return cell
    }
    
    
}
