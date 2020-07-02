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
        
        //MessagesStorageManager.shared.saveNewMessages(interlocutorID: UUID(uuidString: "ED38CB45-1A45-42A2-A049-388D0777B64E")!, messages: [ Message(senderID: UUID(uuidString: "ED38CB45-1A45-42A2-A049-388D0777B64E")!, content: Data("loool".utf8), contentType: "text", time: Date()), Message(senderID: UserAuthorization.shared.user!.id, content: Data("keeeek".utf8), contentType: "text", time: Date() + 1 )], completion: {})

        //(interlocutorID: ED38CB45-1A45-42A2-A049-388D0777B64E, interlocutorName: "lol", interlocutorSurname: "kek")
        //(interlocutorID: A3C55938-17E5-42F9-8869-251AAA8B00BC, interlocutorName: "lo", interlocutorSurname: "zo")
        //(interlocutorID: AAF96E48-04C8-4D3E-9003-F69ABAB6993A, interlocutorName: "zo", interlocutorSurname: "zo")
        title = chat?.getFullName()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
               
        tableView.register(UINib(nibName: String(describing: MessageCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: MessageCell.self))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let chat = chat else { return }
        
        messages = MessagesStorageManager.shared.getMessagesWith(interlocutorID: chat.interlocutorID)
            .sorted(by: { (first, second) -> Bool in
                return first.time < second.time
            })
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
