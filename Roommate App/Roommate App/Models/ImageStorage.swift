//
//  ImageStorage.swift
//  Roommate App
//
//  Created by Jesse Berliner-Sachs on 3/18/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import Foundation

import Firebase
import FirebaseStorage

class ImageStorage  {

    static var instance : ImageStorage? = nil
    var storage : Storage?
    
    private init(){
        //Ensure app has been configured
        let _ = DatabaseAccess.getInstance()
        
        //Set Storage
        storage = Storage.storage()
    }
    
    public static func getInstance() -> ImageStorage {
        if instance == nil {
            instance = ImageStorage()
        }
        return instance!
    }
    
    private func database_error(_ error: Error? = nil, error_header: String = "Error", view: UIViewController) {
        let alert = UIAlertController(title: error_header,
                                      message: error?.localizedDescription ,
                                      preferredStyle: .alert)
        present_popup(alert: alert, view: view, return_to_login: false)
    }
    
    
    private func present_popup(alert: UIAlertController, view: UIViewController, return_to_login: Bool) {
        
        let returnAction = UIAlertAction(title:"Login Again",
                                         style: .default,
                                         handler:  { action in view.performSegue(withIdentifier: "loginErrorSegue", sender: self) })
        
        let continueAction = UIAlertAction(title: "Continue",
                                           style: .default)
        
        alert.addAction(return_to_login ? returnAction : continueAction)
        view.present(alert, animated: true, completion: nil)
    }
    
    //returns false if error uploading
    func uploadChoreImage(image : UIImage, chore_id: String, view: UIViewController){
    
    }
    
    //returns image id of image
    func getChoreImage(imageDownloadURL : String, view: UIViewController) -> UIImage? {
        return nil
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?, choreID: String, view: UIViewController) {
        //userPhoto.image = image
        picker.dismiss(animated: true, completion: nil)
        let data = UIImageJPEGRepresentation(image, 0.8)!
        // set upload path
        let filePath = "chore_images/\(choreID)"
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        self.storage?.reference().child(filePath).putData(data, metadata: metaData){ (metaData, error) in
            if let error = error {
                self.database_error(error, error_header: "Error uploading file to Database", view: view)
                print(error.localizedDescription)
            } else {
                //store downloadURL
                let downloadURL = metaData!.downloadURL()!.absoluteString
                //store downloadURL at database
                DatabaseAccess.getInstance().ref.child("chores/\(choreID)/imageDownloadURL").setValue(downloadURL)
            }
        }
    }
}
