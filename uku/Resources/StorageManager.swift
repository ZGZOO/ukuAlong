//
//  StorageManager.swift
//  uku
//
//  Created by admin on 11/6/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    /*
     /images/john-doe-com_profile_picture.png
     */
    
    public typealias UploadPictureCompletion = (Result<String,Error>) -> Void
    
    /// Uploads profile picture to Firebase Storage and returns completion url string to download
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { metadata, error in
            guard error == nil else {
                //failed
                print("failed to upload data to Firebase Storage")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            let reference = self.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("failedToGetDownloadUrl")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                let urlString = url.absoluteString
                print("Download URL String: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    public func uploadRecording(with fileURL: URL, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("recordings/\(fileName)").putFile(from: fileURL, metadata: nil, completion: { [weak self] metadata,error in
            guard error == nil else {
                print("failed to upload")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self?.storage.child("recordings/\(fileName)").downloadURL(completion: { (url, error) in
                guard let url = url else {
                    print("Failed to get URL")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                let urlString = url.absoluteString
                print("Download URL Absolute String : \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)

        reference.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
            }

            completion(.success(url))
        })
    }
    
//    public func downloadCover(with reference: String, completion:((Result<URL, Error>)->Void )) {
//        storage.child(reference).downloadURL(completion: { url, error in
//            guard let url=url, error == nil else {
//                completion(.failure(StorageErrors.failedToUpload))
//                return
//            }
//            
//            completion(.success(url))
//        })
//    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
}

public struct CoverRecording {
    var recordingID: String
    var coverID: String
    var coverCreatorID: String
    var songName: String
    var url: URL?
    var video: UIImage?
}
