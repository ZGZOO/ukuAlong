//
//  RegisterViewController.swift
//  uku
//
//  Created by admin on 11/4/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
class SignUpViewController: UIViewController {


    @IBOutlet weak var firstNameField: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = imageView.frame.width/2.0
    }
    
    
    @IBAction func onProfilePhoto(_ sender: Any) {
        presentPhotoActionSheet()
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCreateAccount(_ sender: Any) {
        guard let firstname = firstNameField.text,
            let lastname = lastNameField.text,
            let email = emailField.text,
            let password = passwordField.text,
            !firstname.isEmpty,
            !lastname.isEmpty,
            !email.isEmpty,
            !password.isEmpty,
            password.count >= 6 else {
                alertUserCreateError()
                return
        }
        
        // FireBase Create Account
        
        DatabaseManager.shared.userExists(with: email, completion: { [weak self] exists in
            
            guard let strongSelf = self else {
                return
            }
            
            guard !exists else {
                // user exists
                strongSelf.alertUserCreateError(message: "User with email already exists")
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                guard authResult != nil, error == nil else {
                    print("Error Creating User")
                  return
                }
                
                let ukuAlongUser = UkuAlongUser(firstName: firstname,
                                                lastName: lastname,
                                                emailAddress: email)
                
                DatabaseManager.shared.insertUser(with: ukuAlongUser, completion: { success in
                    if success {
                        //uploadImage
                        guard let image = strongSelf.imageView.image, let data = image.pngData() else {
                            return
                        }
                        
                        let fileName = ukuAlongUser.profilePictureFileName
                        
                        StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName, completion: { result in
                            switch result {
                            case .success(let downloadURL):
                                UserDefaults.standard.set(downloadURL, forKey:"profilePictureURL")
                                print(downloadURL)
                            case .failure(let error):
                                print("Storage Manager Error in Sign Up Controller: \(error)")
                            }
                        })
                    }
                })
                
                let main = UIStoryboard(name: "Main", bundle: nil)
                let homeNavigationController = main.instantiateViewController(withIdentifier: "HomeNavigationController")
                let scene = UIApplication.shared.connectedScenes.first
                if let delegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                    delegate.window?.rootViewController = homeNavigationController
                }
            }
        })
    }
    
    func alertUserCreateError(message: String = "Please enter all details to create account") {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture ?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in self?.presentCamera() } ))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in self?.presentPhotoPicker() } ))
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func presentPhotoPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let selectedImage = info[.editedImage] as! UIImage
        self.imageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
