//
//  CoverTableViewCell.swift
//  uku
//
//  Created by admin on 11/12/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit
import Firebase

class CoverTableViewCell: UITableViewCell {

    
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songArtist: UILabel!
    @IBOutlet weak var coverCreator: UILabel!
    @IBOutlet weak var favCount: UILabel!
    
    var coverKey: String?
    var coverRef: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }


    @IBAction func didTapFavButton(_ sender: Any) {
        print("button tapped")
        if let coverKey = coverKey {
          coverRef = Database.database().reference().child("covers").child(coverKey)
          incrementFavCount(forRef: coverRef)
          coverRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let uid = value?["coverCreatorId"] as? String {
              let userPostRef = Database.database().reference()
                .child("user-posts")
                .child(uid)
                .child(coverKey)
              self.incrementFavCount(forRef: userPostRef)
            }
          })
        }
    }
    
    func incrementFavCount(forRef ref: DatabaseReference) {
      // [START post_stars_transaction]
      ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
        if var cover = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
          var fav: Dictionary<String, Bool>
          fav = cover["fav"] as? [String : Bool] ?? [:]
          var favCount = cover["favCount"] as? Int ?? 0
          if let _ = fav[uid] {
            // Unstar the post and remove self from stars
            favCount -= 1
            fav.removeValue(forKey: uid)
          } else {
            // Star the post and add self to stars
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
      // [END post_stars_transaction]
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
