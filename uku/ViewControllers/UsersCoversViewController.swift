//
//  UsersPostsViewController.swift
//  uku
//
//  Created by admin on 11/19/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import CoreServices

class UsersCoversViewController: UIViewController, UITableViewDelegate {
    
    var ref: DatabaseReference!
    var dataSource: FUITableViewDataSource?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        dataSource = FUITableViewDataSource(query: getQuery()) { (tableView, indexPath, snap) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCoversTableViewCell", for: indexPath) as! UserCoversTableViewCell
            
            guard let cover = UkuAlongCover(snapshot: snap) else {
                print("returning default cell")
                return cell
            }
            cell.songTitle.text = cover.songTitle
            cell.songArtist.text = cover.songArtist
//            cell.coverCreator.text = cover.coverCreator
            cell.favCount.text = String(format: "%@", cover.favCount as! CVarArg)
//            var imageName = "suit.heart"
//            if (cover.fav?[self.getUid()]) != nil {
//                print("change icon")
//                imageName = "suit.heart.fill"
//            }
//            cell.favButton.setImage(UIImage(systemName: imageName), for: .normal)
//            cell.coverKey = snap.key
            return cell
        }
        dataSource?.bind(to: tableView)
        
        tableView.delegate = self
    }
    
    func getQuery() -> DatabaseQuery {
        return (ref?.child("user-covers").child(getUid()))!
    }

    public func getUid() -> String {
        return (Auth.auth().currentUser?.uid)!
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
