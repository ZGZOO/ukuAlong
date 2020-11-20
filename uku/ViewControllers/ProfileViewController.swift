//
//  ProfileViewController.swift
//  uku
//
//  Created by admin on 11/13/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var coversRecSegControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    var userKey = ""
    lazy var ref: DatabaseReference = Database.database().reference()
    var userRef: DatabaseReference!
    var refHandle: DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        profilePhoto.layer.masksToBounds = true
        profilePhoto.layer.borderWidth = 2
        profilePhoto.layer.borderColor = UIColor.lightGray.cgColor
        profilePhoto.layer.cornerRadius = profilePhoto.frame.width/2.0
        editProfileButton.layer.cornerRadius = editProfileButton.frame.width/20.0
        fetchUserData()
        
    }
    
    private lazy var usersCoversViewController: UsersCoversViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "UsersCoversViewController") as! UsersCoversViewController

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()

    private lazy var usersRecordingsViewController: UsersRecordingsViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "UsersRecordingsViewController") as! UsersRecordingsViewController

        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)

        return viewController
    }()
    
    static func viewController() -> ProfileViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
    }
    
    private func add(asChildViewController viewController: UIViewController) {

        // Add Child View Controller
        addChild(viewController)

        // Add Child View as Subview
        containerView.addSubview(viewController.view)

        // Configure Child View
        viewController.view.frame = containerView.bounds
//        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
//        viewController.view.frame.width = containerView.frame.width
//        viewController.view.frame.height = containerView.frame.height

        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)

        // Remove Child View From Superview
        viewController.view.removeFromSuperview()

        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    private func updateView() {
        if coversRecSegControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: usersRecordingsViewController)
            add(asChildViewController: usersCoversViewController)
        } else {
            remove(asChildViewController: usersCoversViewController)
            add(asChildViewController: usersRecordingsViewController)
        }
    }
    
    @IBAction func segValueChanged(_ sender: Any) {
        updateView()
    }
    
    func setupView() {
        updateView()
    }
    
    
    func fetchUserData() {
        userKey = Auth.auth().currentUser!.uid
        print(userKey)
        userRef = ref.child("users").child(userKey)
        refHandle = userRef.observe(DataEventType.value, with: { (snapshot) in
            let userDict = snapshot.value as? [String : AnyObject] ?? [:]
            self.firstName.text = userDict["first_name"] as! String
            self.lastName.text = userDict["last_name"] as! String
            let safeEmail = userDict["safe_email"] as! String
            let filename = safeEmail + "_profile_picture.png"
            let path = "images/"+filename
            
            StorageManager.shared.downloadURL(for: path, completion: { result in
                switch result {
                case .success(let url):
                    self.profilePhoto.sd_setImage(with: url, completed: nil)
                case .failure(let error):
                    print("Failed to get download url: \(error)")
                }
            })
        })
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
