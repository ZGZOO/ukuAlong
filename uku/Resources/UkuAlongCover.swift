//
//  UkuAlongCover.swift
//  uku
//
//  Created by admin on 11/12/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import Foundation
import Firebase

public class UkuAlongCover:NSObject {
    
    var coverId: String
    var coverCreator: String
    var songTitle: String
    var songArtist: String
    var coverContent: String
//    var recordings: [CoverRecording]
    var coverCreatorId: String
    var favCount: AnyObject?
    var fav: Dictionary<String, Bool>?
    
    init(coverId: String, coverCreator: String, songTitle: String, songArtist: String, coverContent: String, coverCreatorId: String) {
        self.coverId = coverId
        self.coverCreator = coverCreator
        self.songTitle = songTitle
        self.songArtist = songArtist
        self.coverContent = coverContent
        self.coverCreatorId = coverCreatorId
        self.favCount = 0 as AnyObject?
    }

    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String:Any] else { return nil }
        guard let coverId  = dict["coverId"] as? String  else { return nil }
        guard let coverCreator = dict["coverCreator"]  as? String else { return nil }
        guard let songTitle = dict["songTitle"]  as? String else { return nil }
        guard let songArtist = dict["songArtist"]  as? String else { return nil }
        guard let coverContent = dict["coverContent"]  as? String else { return nil }
        guard let coverCreatorId = dict["coverCreatorId"]  as? String else { return nil }
        var fav: Dictionary<String, Bool>?
        if (dict["fav"] != nil) { fav = dict["fav"] as! Dictionary<String, Bool> }
//        guard let fav = dict["fav"] as? Dictionary<String, Bool> else { return nil }
        guard let favCount = dict["favCount"] else { return nil }


        self.coverId = coverId
        self.coverCreator = coverCreator
        self.songTitle = songTitle
        self.songArtist = songArtist
        self.coverContent = coverContent
        self.coverCreatorId = coverCreatorId
        self.fav = fav
        self.favCount = favCount as AnyObject?
    }

    convenience override init() {
        self.init(coverId: "", coverCreator: "", songTitle: "", songArtist: "", coverContent: "", coverCreatorId: "")
    }
}
