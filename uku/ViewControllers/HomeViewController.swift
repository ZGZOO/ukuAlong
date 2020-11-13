//
//  HomeViewController.swift
//  uku
//
//  Created by admin on 11/4/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class HomeViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    var dataSource: FUITableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
//        let identifier = "cover"
//        let nib = UINib(nibName: "CoverTableViewCell", bundle: nil)
//        tableView.register(nib, forCellReuseIdentifier: identifier)
        
        dataSource = FUITableViewDataSource(query: getQuery()) { (tableView, indexPath, snap) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CoverTableViewCell", for: indexPath) as! CoverTableViewCell
            
            guard let cover = UkuAlongCover(snapshot: snap) else { return cell }
            cell.songTitle.text = cover.songTitle
            cell.songArtist.text = cover.songArtist
            cell.coverCreator.text = cover.coverCreator
            cell.favCount.text = cover.favCount as? String
            
            return cell
        }
        dataSource?.bind(to: tableView)
        tableView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    private func validateAuth() {
        let currentUser = FirebaseAuth.Auth.auth().currentUser
        if  currentUser == nil {
            let main = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
            let scene = UIApplication.shared.connectedScenes.first
            if let delegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                delegate.window?.rootViewController = loginViewController
            }
        }
        else {
            let currentUserUID = currentUser!.uid
            DatabaseManager.shared.getUserDetails(with: currentUserUID, completion: {
                result in
                switch result {
                case .success(let fullname):
                    UserDefaults.standard.set(fullname, forKey:"fullname")
                case.failure(let error):
                    print(error)
                }
            })
        }

    }
    
    func getUid() -> String {
        return (Auth.auth().currentUser?.uid)!
    }
    
    func getQuery() -> DatabaseQuery {
        let recentCoversQuery = ref.child("covers")
        return recentCoversQuery
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      guard let indexPath: IndexPath = sender as? IndexPath else { return }
      guard let detail: CoverDetailViewController = segue.destination as? CoverDetailViewController else {
        return
      }
      if let dataSource = dataSource {
        print("Key:\(dataSource.snapshot(at: indexPath.row).key)")
        detail.coverKey = dataSource.snapshot(at: indexPath.row).key
      }
    }

    
    @IBAction func onLogOut(_ sender: Any) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            print("User successfully signed out")
            validateAuth()            
            self.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print("error : \(signOutError)")
        }
    }
}
