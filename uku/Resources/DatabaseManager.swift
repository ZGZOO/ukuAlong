//
//  DatabaseManager.swift
//  uku
//
//  Created by admin on 11/5/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
}
// MARK: - Account Management
extension DatabaseManager {
    
    /// Check user exists in database
//    public func userExists(with email: String,
//                           completion:@escaping((Bool) -> Void)) {
//        var safeEmail = email.replacingOccurrences(of: "@", with: "-")
//        safeEmail = safeEmail.replacingOccurrences(of: ".", with: "-")
//        print("Safe Email : \(safeEmail)")
//        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
//            guard snapshot.value as? String != nil else {
//                completion(false)
//                return
//            }
//            
//            completion(true)
//        })
//    }
    
    /// Get user details
    public func getUserDetails(with uid: String,
                               completion:@escaping((Result<String,Error>)->Void)) {
        database.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let firstname = value?["first_name"] as? String ?? ""
            let lastname = value?["last_name"] as? String ?? ""
            completion(.success("\(firstname) \(lastname)"))
          }) { (error) in
            print(error.localizedDescription)
        }
    }
    /// Inserts new user to database
    public func insertUser(with user: UkuAlongUser, completion: @escaping (Bool) -> Void) {
        print("Inserting in database")
        database.child("users").child(user.userUID).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName,
            "email_address": user.emailAddress,
            "safe_email": user.safeEmail
        ], withCompletionBlock: { error, _ in
            guard error==nil else {
                print("failed to write to database")
                completion(false)
                return
            }
            completion(true)
        })
        print("Inserting in database successful")
    }
    
    /// Insert new song cover to database
//    public func insertCover(with cover: UkuAlongCover, completion: @escaping (Bool)->Void) {
//        print("Inserting cover to database")
//        var safeSongName = cover.songTitle.replacingOccurrences(of: " ", with: "-")
//        database.child("covers").child(safeSongName).setValue([
//            "coverId": cover.coverId,
//            "coverCreator": cover.coverCreator,
//            "songTitle": cover.songTitle,
//            "songArtist": cover.songArtist,
//            "coverContent": cover.coverContent,
////            "recordings": cover.recordings,
//            "fav": cover.fav
//        ], withCompletionBlock: { error, _ in
//            guard error==nil else {
//                print("Failed to write cover to database")
//                completion(false)
//                return
//            }
//            completion(true)
//        })
//    }
    
    /// Get all covers (songs)
    public func getAllCovers(completion: @escaping (Result<Any, Error>) -> Void) {
        database.child("covers").observe(.value, with: { (snapshot) in
//            let value = snapshot.value as? [String: Any]
//            print(value)
            let dict = snapshot.value as? [String:Any]
            
//                print(dictionary)
//                guard let coverId = dictionary["coverId"] as? String,
//                    let coverCreator = dictionary["coverCreator"] as? String,
//                    let coverContent = dictionary!["coverContent"] as? String,
//                    let songTitle = dictionary!["songTitle"] as? String,
//                    let songArtist = dictionary!["songTitle"] as? String,
//                    let fav = dictionary!["fav"] as? Int else {
//                        return nil
//                }
//                return UkuAlongCover(coverId: coverId,
//                                     coverCreator: coverCreator,
//                                     songTitle: songTitle,
//                                     songArtist: songArtist,
//                                     coverContent: coverContent,
//                                     fav: fav)
//            })
            completion(.success(snapshot.value))
          }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    // Database Errors
    public enum DatabaseError: Error {
        case failedToFetch

        public var localizedDescription: String {
            switch self {
            case .failedToFetch:
                return "This means blah failed"
            }
        }
    }
}

struct UkuAlongUser {
    let userUID: String
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    var profilePictureFileName: String {
       return "\(safeEmail)_profile_picture.png"
    }
}

//struct UkuAlongCover {
//    var coverId: String
//    var coverCreator: String
//    var songTitle: String
//    var songArtist: String
//    var coverContent: String
////    var recordings: [CoverRecording]
//    var fav: Int
//}
