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
import CoreServices

class HomeViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var ref: DatabaseReference!
    var dataSource: FUITableViewDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        dataSource = FUITableViewDataSource(query: getQuery()) { (tableView, indexPath, snap) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CoverTableViewCell", for: indexPath) as! CoverTableViewCell
            
            guard let cover = UkuAlongCover(snapshot: snap) else {
                print("returning default cell")
                return cell
            }
            cell.songTitle.text = cover.songTitle
            cell.songArtist.text = cover.songArtist
            cell.coverCreator.text = cover.coverCreator
            cell.favCount.text = String(format: "%@", cover.favCount as! CVarArg)
            var imageName = "suit.heart"
            if (cover.fav?[self.getUid()]) != nil {
                print("change icon")
                imageName = "suit.heart.fill"
            }
            cell.favButton.setImage(UIImage(systemName: imageName), for: .normal)
            cell.coverKey = snap.key
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
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150
//    }

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
    }
    
    public func getUid() -> String {
        return (Auth.auth().currentUser?.uid)!
    }
    
    func getQuery() -> DatabaseQuery {
        let recentCoversQuery = ref.child("covers")
        return recentCoversQuery
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let detailViewController = segue.destination as! CoverDetailViewController
            detailViewController.coverKey = (dataSource?.snapshot(at: indexPath.row).key)!
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
