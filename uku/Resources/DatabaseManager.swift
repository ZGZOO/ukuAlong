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
    
    public func userExists(with email: String,
                           completion:@escaping((Bool) -> Void)) {
        print("Reached here")
        var safeEmail = email.replacingOccurrences(of: "@", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: ".", with: "-")
        print("Safe Email : \(safeEmail)")
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            
            completion(true)
        })
    }
    
    /// Inserts new user to database
    public func insertUser(with user: UkuAlongUser, completion: @escaping (Bool) -> Void) {
        print("Inserting in database")
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
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
}

struct UkuAlongUser {
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