//
//  NewChordsViewController.swift
//  uku
//
//  Created by admin on 11/12/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit
import Firebase

class NewChordsViewController: UIViewController {

    @IBOutlet weak var songName: UITextField!
    
    @IBOutlet weak var songArtist: UITextField!
    
    @IBOutlet weak var chordContent: UITextView!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.ref = Database.database().reference()
        
    }
    
    
    @IBAction func onPost(_ sender: Any) {
        guard let songName = songName.text,
            let songArtist = songArtist.text,
            let chordContent = chordContent.text,
            !songName.isEmpty, !songArtist.isEmpty, !chordContent.isEmpty else {
                alertCoverPostError()
                return
            }
        
        let userId = Auth.auth().currentUser?.uid
        ref.child("users").child(userId!).observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            let firstname = value?["first_name"] as? String ?? ""
            let lastname = value?["last_name"] as? String ?? ""
            let fullname = "\(firstname) \(lastname)"
            
            self.postNewCover(withCoverId: UUID().uuidString, fullname: fullname, songTitle: songName, songArtist: songArtist, coverContent: chordContent, userId: userId!)
            _ = self.navigationController?.popViewController(animated: true)
        }) { (error) in
            print(error)
        }
    }
    
    public func postNewCover(withCoverId coverId: String, fullname: String, songTitle: String, songArtist: String, coverContent: String, userId: String) {
        
        guard let key = ref.child("covers").childByAutoId().key else { return }
        let cover = [ "coverId": coverId,
                      "coverCreator": fullname,
                      "songTitle": songTitle,
                      "songArtist": songArtist,
                      "coverContent": coverContent,
                      "coverCreatorId": userId,
                      "favCount": 0
            ] as [String : Any]
        
        let childUpdates = ["/covers/\(key)": cover,
                            "/user-covers/\(userId)/\(key)/": cover]
        ref.updateChildValues(childUpdates)
    }
    
    func alertCoverPostError() {
        let alert = UIAlertController(title: "Error", message: "Please check all fields are not empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

}
