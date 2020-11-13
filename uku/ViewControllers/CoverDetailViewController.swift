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
    @IBOutlet weak var coverContent: UILabel!
    
    
    var coverKey = "-MM-RpEGfNqsf8sdBceR" 
    let cover: UkuAlongCover = UkuAlongCover()
    lazy var ref: DatabaseReference = Database.database().reference()
    var coverRef: DatabaseReference!
    var refHandle: DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(coverKey)
        coverRef = ref.child("covers").child(coverKey)
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refHandle = coverRef.observe(DataEventType.value, with: { (snapshot) in
            let coverDict = snapshot.value as? [String : AnyObject] ?? [:]
            self.cover.setValuesForKeys(coverDict)
            
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        songTitle.text = self.cover.songTitle
        songArtist.text = self.cover.songArtist
        coverContent.text = self.cover.coverContent
        coverCreator.text = self.cover.coverCreator
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
