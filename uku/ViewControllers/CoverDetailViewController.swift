//
//  CoverDetailViewController.swift
//  uku
//
//  Created by admin on 11/12/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit
import Firebase

class CoverDetailViewController: UIViewController {

    
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songArtist: UILabel!
    @IBOutlet weak var coverCreator: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var coverContent: UITextView!
    
    var coverKey:String?
    let cover: UkuAlongCover = UkuAlongCover()
    lazy var ref: DatabaseReference = Database.database().reference()
    var coverRef: DatabaseReference!
    var refHandle: DatabaseHandle?
    
    var favButtonImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()
    }
    
    func fetchData() {
        print(coverKey)
        coverRef = ref.child("covers").child(coverKey!)
        refHandle = coverRef.observe(DataEventType.value, with: { (snapshot) in
            let coverDict = snapshot.value as? [String : AnyObject] ?? [:]
            self.cover.coverId = coverDict["coverId"] as! String
            self.cover.coverCreator = coverDict["coverCreator"] as! String
            self.cover.coverCreatorId = coverDict["coverCreatorId"] as! String
            self.cover.coverContent = coverDict["coverContent"] as! String
            self.cover.songTitle = coverDict["songTitle"] as! String
            self.cover.songArtist = coverDict["songArtist"] as! String
            self.cover.favCount = coverDict["favCount"]
            if (self.cover.favCount! as! Int) > 0 {
                self.cover.fav = coverDict["fav"] as! Dictionary<String, Bool>
            }
        })
        songTitle.text = self.cover.songTitle
        songArtist.text = self.cover.songArtist
        coverContent.text = self.cover.coverContent
        coverCreator.text = self.cover.coverCreator
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        songTitle.text = self.cover.songTitle
        songArtist.text = self.cover.songArtist
        coverContent.text = self.cover.coverContent
        coverCreator.text = self.cover.coverCreator
//        favButton.setImage(favButtonImage, for: .normal)
        var imageName = "suit.heart"
        if (cover.fav?[(Auth.auth().currentUser?.uid)!]) != nil {
            print("change icon")
            imageName = "suit.heart.fill"
        }
        favButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    

    @IBAction func didTapViewRecButton(_ sender: Any) {
        
    }
    
    @IBAction func didTapFavButton(_ sender: Any) {
        print("button tapped")
        if favButton.image(for: .normal) == UIImage(systemName: "suit.heart") {
            favButtonImage = UIImage(systemName: "suit.heart.fill")
        } else {
            favButtonImage = UIImage(systemName: "suit.heart")
        }
        favButton.setImage(favButtonImage, for: .normal)
        if let coverKey = coverKey {
            print(coverKey)
            coverRef = Database.database().reference().child("covers").child(coverKey)
            incrementFavCount(forRef: coverRef)
            coverRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                if let uid = value?["coverCreatorId"] as? String {
                    let userPostRef = Database.database().reference()
                        .child("user-covers")
                        .child(uid)
                        .child(coverKey)
                    self.incrementFavCount(forRef: userPostRef)
                }
            })
        }
    }
    
    func incrementFavCount(forRef ref: DatabaseReference) {
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var cover = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
                var fav: Dictionary<String, Bool>
                fav = cover["fav"] as? [String : Bool] ?? [:]
                var favCount = cover["favCount"] as? Int ?? 0
                if let _ = fav[uid] {
                    favCount -= 1
                    fav.removeValue(forKey: uid)
                } else {
                    favCount += 1
                    fav[uid] = true
                }
                cover["favCount"] = favCount as AnyObject?
                cover["fav"] = fav as AnyObject?

                // Set value and report transaction success
                currentData.value = cover

                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func didTapPostRecButton(_ sender: Any) {
        
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
