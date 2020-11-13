//
//  LoginViewController.swift
//  uku
//
//  Created by admin on 11/2/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func onSignUp(_ sender: Any) {
        self.performSegue(withIdentifier: "signUpSegue", sender: self)
    }
    
    @IBAction func onLogIn(_ sender: Any) {
        
        guard let email = emailField.text,
            let password = passwordField.text,
            !email.isEmpty, !password.isEmpty, password.count >= 6 else {
                alertUserLoginError()
                return
        }
        
        
        Firebase.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            
            guard let result = authResult, error == nil else {
                print("Failed to log in user with email: \(email)")
                return
            }
            let user = result.user
//            DatabaseManager.shared
            print("Logged in user: \(user)")
            self!.performSegue(withIdentifier: "loginToHome", sender: self)
        })
    }
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Error", message: "Please check email and password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
}


//extension LoginViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField == emailField {
//            passwordField.becomeFirstResponder()
//        }
//        else if textField == passwordField {
//            onLogIn(self)
//        }
//        return true
//    }
//}
