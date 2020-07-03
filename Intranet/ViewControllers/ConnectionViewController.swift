//
//  ConnectionViewController.swift
//  Intranet
//
//  Created by Владислав on 02.07.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConnectionViewController: UIViewController, UINavigationControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var clipButton: UIButton!
    @IBOutlet weak var startConnectionButton: UIBarButtonItem!
    
    var messages: [Message] = []
    var newMessages: [Message] = []
    var hasResivedInterlocutorInfo = false
    var interlocutor: User?
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        guard
            let user = UserAuthorization.shared.user,
            let text = messageTextView.text.data(using: .utf8)
        else { return }
        
        let newMessage = Message(senderID: user.id, content: text, contentType: .text, time: Date())
        send(message: newMessage)
        print("\(newMessage) sended ")
        newMessages.append(newMessage)
        messages.append(newMessage)
        tableView.reloadData()
        messageTextView.text = ""
        increasingPlusDecreasingAnimation(button: sendButton, isEnable: false)
        sendButton.isEnabled = false
    }
    
    @IBAction func photoButtonPressed(_ sender: Any) {
        
    }
    @IBAction func clipButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func startingConnectionButtonPressed(_ sender: Any) {
        
        let allert = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .actionSheet)
        
        let join = UIAlertAction(title: "Join a session", style: .default, handler: joinSession(action:))
        
        let host = UIAlertAction(title: "Host a session", style: .default, handler: startHosting(action:))
        
        let cansel = UIAlertAction(title: "Canсel", style: .cancel)
        
        allert.addAction(host)
        allert.addAction(join)
        allert.addAction(cansel)
        present(allert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //по-хорошему, что-то вернуть, но из-за логики приложения такого произойти не может
        guard let user = UserAuthorization.shared.user else { return }
        
        peerID = MCPeerID(displayName: user.getFullName())
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        
        title = "Chat"
        
        setupToHideKeyboardOnTapOnView()
        
        registerForKeyboardNotification()
        
        sendButton.isEnabled = false
        
        configurate(textView: messageTextView)
        disableViews()
        
        messageTextView.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
               
        tableView.register(UINib(nibName: String(describing: MessageCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: MessageCell.self))
        
        startAlert()

    }
    
    deinit {
        removeKeyboardNotification()
    }
    
    func disableViews() {
        messageTextView.isEditable = false
        disable(views: sendButton, photoButton, clipButton)
    }
    
    func activateViews() {
        messageTextView.isEditable = true
        activate(views: photoButton, clipButton)
    }
    
    //MARK: Alerts
    
    func startAlert(){
        
        let allert = UIAlertController(title: nil, message: "To continue, you should start or join a session by clicking on the button in the upper right corner", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        allert.addAction(okAction)
        present(allert, animated: true)
    }
    
    //MARK: Multipeer Connectivity
    
    func startHosting(action: UIAlertAction!) {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "Intranet", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
    }

    func joinSession(action: UIAlertAction!) {
        let mcBrowser = MCBrowserViewController(serviceType: "Intranet", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            
            DispatchQueue.main.async { [weak self] in
                self?.activateViews()
                self?.startConnectionButton.isEnabled = false
                guard let user = UserAuthorization.shared.user else { return }
                self?.send(userInfo: user)
                print("\(user) sended ")
            }

        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")

        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
            
        @unknown default:
            print("Unknown state: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if !hasResivedInterlocutorInfo {
            hasResivedInterlocutorInfo = true
            if let user = try? JSONDecoder().decode(User.self, from: data) {
                DispatchQueue.main.async { [weak self] in
                    self?.interlocutor = user
                    print("\(user) got")
                }
            }
        } else {
            if let message = try? JSONDecoder().decode(Message.self, from: data) {
                DispatchQueue.main.async { [weak self] in
                    print("\(message) got")
                    self?.messages.append(message)
                    self?.tableView.reloadData()
                    self?.newMessages.append(message)
                }
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func send(userInfo: User) {
        if mcSession.connectedPeers.count > 0 {
            if let userInfo = try? JSONEncoder().encode(userInfo) {
                do {
                    try mcSession.send(userInfo, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch let error as NSError {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    func send(message: Message) {
        if mcSession.connectedPeers.count > 0 {
            if let messageData = try? JSONEncoder().encode(message) {
                do {
                    try mcSession.send(messageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch let error as NSError {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    
}

    //MARK: Work with table


extension ConnectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ConnectionViewController: UITableViewDataSource {
    
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


// MARK: - Text field delegate

extension ConnectionViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text?.count == 0{
            
            increasingPlusDecreasingAnimation(button: sendButton, isEnable: false)
            sendButton.isEnabled = false
        }
        else{
            if !sendButton.isEnabled {
                self.sendButton.isEnabled = true
                increasingPlusDecreasingAnimation(button: sendButton, isEnable: true)
            }
        }
    }
    
    func increasingPlusDecreasingAnimation(button: UIButton, isEnable: Bool) {
        
        UIView.animateKeyframes(
            withDuration: 1,
            delay: 0,
            animations: {
                
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 0.5) {
                        button.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                }
                
                UIView.addKeyframe(
                    withRelativeStartTime: 0.5,
                    relativeDuration: 0.5) {
                        button.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                
        }, completion: nil)
    }
}



//MARK: Show the content above the keyboard

extension ConnectionViewController{
    
    func registerForKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            tableView.setContentOffset(CGPoint(x: 0, y: tableView.contentOffset.y + keyboardSize.size.height), animated: true)
            self.view.frame.size.height -= keyboardSize.size.height
            
        }
    }
    

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.size.height += keyboardSize.size.height
            //tableView.setContentOffset(CGPoint(x: 0, y:             tableView.contentOffset.y - keyboardSize.height), animated: true)
        }
    }
}
