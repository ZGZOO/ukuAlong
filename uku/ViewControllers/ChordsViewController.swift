//
//  ChordsViewController.swift
//  uku
//
//  Created by admin on 11/8/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit
import FirebaseStorage
import MobileCoreServices

class ChordsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onRecord(_ sender: Any) {
        presentVideoActionSheet()
        
    }
    
}

extension ChordsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentVideoActionSheet() {
        let actionSheet = UIAlertController(title: "Cover Recording",
                                            message: "How would you like to upload a cover ?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Record Video",
                                            style: .default,
                                            handler: { [weak self] _ in self?.presentCamera() } ))
        actionSheet.addAction(UIAlertAction(title: "Choose Video",
                                            style: .default,
                                            handler: { [weak self] _ in self?.presentVideoPicker() } ))
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = true
        picker.mediaTypes = ["public.movie"]
        picker.videoQuality = .typeMedium
        present(picker, animated: true)
    }
    
    func presentVideoPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        picker.mediaTypes = ["public.movie"]
        picker.videoQuality = .typeMedium
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let videoURL = info[.mediaURL] as? URL {
            let filename = "recording.mov"
            print("Record URL : \(videoURL)")
            
            var fireURL = videoURL
            
            do {
                if #available(iOS 13, *) {
                    //If on iOS13 slice the URL to get the name of the file
                    let urlString = videoURL.relativeString
                    let urlSlices = urlString.split(separator: ".")
                    //Create a temp directory using the file name
                    let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                    fireURL = tempDirectoryURL.appendingPathComponent(String(urlSlices[1])).appendingPathExtension(String(urlSlices[2]))

                    //Copy the video over
                    try FileManager.default.copyItem(at: videoURL, to: fireURL)
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
            
            print("Fire URL: \(fireURL)")
            StorageManager.shared.uploadRecording(with: fireURL, fileName: filename, completion: { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                
                switch result {
                case .success(let urlString):
                    print("Uploaded Message Video: \(urlString)")
                    
                case .failure(let error):
                    print("Failed to upload recording: \(error)")
                }
            })
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
