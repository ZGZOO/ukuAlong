//
//  API.swift
//  uku
//
//  Created by admin on 11/17/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import Foundation

struct API {

    static let apiKey = "7b56c19a09c6dd3e7ed01794baf1b57f"
    
    static func getLyrics(songName:String, songArtist: String, completion: @escaping (String) -> Void) {
        
        let scheme = "https"
        let host = "api.musixmatch.com"
        let path = "/ws/1.1/matcher.lyrics.get"
        let songName = URLQueryItem(name: "q_track", value: songName)
        let songArtist = URLQueryItem(name: "q_artist", value: songArtist)
        let apikey = URLQueryItem(name: "apikey", value: apiKey)


        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [songName,songArtist,apikey]

        let url = (urlComponents.url as? URL)!
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                // ––––– TODO: Get data from API and return it using completion
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                let message = dataDictionary["message"] as! NSDictionary
                guard let body = message["body"] as? NSDictionary else {
                    return completion("Lyrics Not Found")
                }
                let lyricsDictionaries = body["lyrics"] as! NSDictionary
                let lyricsBody = lyricsDictionaries["lyrics_body"] as! String
                return completion(lyricsBody)
                }
            }
            task.resume()
    }
}



/*
 
 {"lyrics":
    {"lyrics_id":6275938,
        "explicit":1,
        "lyrics_body":"Money\nGet away\nYou get a good job with good pay and you're okay\nMoney\nIt's a gas\nGrab that cash with both hands and make a stash\nNew car, caviar, four star daydream\nThink I'll buy me a football team\n\nMoney\nWell, get back\nI'm all right Jack\n...\n\n******* This Lyrics is NOT for Commercial use *******\n(1409620794937)",
    "script_tracking_url":"https:\/\/tracking.musixmatch.com\/t1.0\/m_js\/e_1\/sn_0\/l_6275938\/su_0\/rs_0\/tr_3vUCAM2zGZy-YUpfFusVAL9H7Hqoc6moTiryhVY-XDdcSSpKRm3Ol5qLkS6sK_72Qe8i4vE3bekG4WioJiJkKx-_NprgRQSVF9hZqwWAZvqvDgLys9D-5mISoreIwyCS1Ff0dAgX4KZSbF8wDSpBeCNXyqagk5nAzv2prnscfFx5cqTDTfBbMazfSclf_ykmJnY2mNmxSD9xh25gvVM3Ben5UGIviY7cXMFHIZJZ76qbDdHhICjUHYtZn4yANOCbsm5it5to5YAgXGOt-iWa8tHw4Ba4xsQyRoLAgeYe2k7fSD3P7-omNPbfpPLArlkTb0XJgn6R_dWpDkj6PIhMScBaqtaC1h97h5-mfbOj8vDQeeE1_O4XQ2av96rZ6POBI4pEEAAOtZZU-xIGSdi1rNiTcKq9tEolWlH9Y9q_JDHpBZioQCCMWLdR\/",
    "pixel_tracking_url":"https:\/\/tracking.musixmatch.com\/t1.0\/m_img\/e_1\/sn_0\/l_6275938\/su_0\/rs_0\/tr_3vUCAF3wdWYUTnyLti2RCNme3M5VoGrKnvCmX80jU7j7O2B0RLk4JIPIkUGT96mbStJHgNAM83dbG2nUE7NSoBAqZnqGhEmLgOSG7xUnciHSBrBAXSNdpj6sXbpyIP2jBrjirf-o17yJhPc96kXsbbtuFyDOdacj4fO9pdUQdK_Ua-8HEp_6tGr2pXZqoiLLUDpikpUqOE_OqWD8tHYUv5fvWuAnPyTeqgZWwdc0MBoA8PMwsF6yFT3swdLJ-Ri4iJcSGhXU9uxbkOgKcYk5oZMjHqg2LDIcszbk-lLQHlt_z7rbpt8OL1-sJERBoVIPnJzhkKY-tDcmzbnHJgWXBAUsPyidiVyg_HEj4RIw1739rgpVG9vKRE7G6YfwYM0Z9wL9cx1VNLR933jm2iKDxFYBP13SH9XPzmB9u5d2cpvwX5fxAvq8XVm5\/",
        "lyrics_copyright":"Lyrics powered by www.musixmatch.com. This Lyrics is NOT for Commercial use and only 30% of the lyrics are returned.",
        "updated_time":"2019-07-29T13:10:47Z"
    }
 }
 */



