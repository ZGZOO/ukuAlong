//
//  HomeViewController.swift
//  uku
//
//  Created by admin on 11/4/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit
import FirebaseAuth
class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }

    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let main = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
            let scene = UIApplication.shared.connectedScenes.first
            if let delegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                delegate.window?.rootViewController = loginViewController
            }
        }
    }
    
    @IBAction func onLogOut(_ sender: Any) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            print("User successfully signed out")
            print(FirebaseAuth.Auth.auth().currentUser)
            validateAuth()

            
            self.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print("error : \(signOutError)")
        }
        
    }
}
