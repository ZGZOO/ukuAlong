//
//  UserCoversTableViewCell.swift
//  uku
//
//  Created by admin on 11/19/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit
import Firebase

class UserCoversTableViewCell: UITableViewCell {

    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songArtist: UILabel!
    @IBOutlet weak var favCount: UILabel!
    
    var userCoverKey: String?
    var userCoverRef: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
