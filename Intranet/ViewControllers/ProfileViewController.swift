//
//  ProfileViewController.swift
//  Intranet
//
//  Created by Владислав on 28.06.2020.
//  Copyright © 2020 Vladislav. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var authorizeButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func authorizeButtonPressed(_ sender: Any) {
        activityIndicator.startAnimating()

        disable(views: nameTextField, surnameTextField, authorizeButton)

        guard
            let name = nameTextField.text,
            let surname = surnameTextField.text,
            let id = UIDevice.current.identifierForVendor
        else { return }
        
        let newUser = User(id: id, name: name, surname: surname)
        
        UsersStorageManager.shared.saveUser(user: newUser) { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.successAlert()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Identification"
        
        configurate(button: authorizeButton)
        
        setupToHideKeyboardOnTapOnView()
        
        nameTextField.delegate = self
        surnameTextField.delegate = self
        
        addTargetTo(textField: nameTextField)
        addTargetTo(textField: surnameTextField)
    }
    
    func addTargetTo(textField: UITextField) {
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    static func makeVC() -> ProfileViewController {
        
        let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: ProfileViewController.self)) as? ProfileViewController
        
        guard let newVC = newViewController else { return ProfileViewController() }

        return newVC
    }
    
    //MARK: Alerts
    
    func successAlert(){
        
        let allert = UIAlertController(title: "Success", message: "You identified successfully!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        
        allert.addAction(okAction)
        present(allert, animated: true)
    }

}


extension ProfileViewController: UITextFieldDelegate{
    
    //To close the keyboard after Done pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged() {
        
        if areFieldsEmpty()  {
            hide(view: authorizeButton)
        } else {
            show(view: authorizeButton)
        }
    }
    
    func areFieldsEmpty() -> Bool {
        return nameTextField.text?.isEmpty ?? true || surnameTextField.text?.isEmpty ?? true
    }
    
}
