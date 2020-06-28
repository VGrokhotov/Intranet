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
    

    @IBAction func logOutButtonPressed(_ sender: Any) {
        logOutAlert()
    }
    @IBAction func newConnectionButtonPreesed(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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

        authorizationAlert()

    }
    
    func isAuthorized(){
        logOutButton.isEnabled = true
        newConnectionButton.isEnabled = true
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

