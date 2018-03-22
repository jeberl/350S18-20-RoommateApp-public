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
        present_popup(alert: alert, view: view, upload_again: true)
    }
    
    private func upload_ok(view: UIViewController) {
        let alert = UIAlertController(title: "Image Sucessfully uploaded",
                                      message: "Your house members thank you for doing your chores",
                                      preferredStyle: .alert)
        present_popup(alert: alert, view: view, upload_again: false)
    }
    
    private func present_popup(alert: UIAlertController, view: UIViewController, upload_again: Bool) {
        let action = UIAlertAction(title:"They are welcome!",
                                     style: .default)
        if upload_again {
            let uploadAgainAction = UIAlertAction(title:"Login Again",
                                                  style: .default,
                                                  handler:  { action in view.performSegue(withIdentifier: "completeTask", sender: self) })
            alert.addAction(action)
        }
        alert.addAction(action)
        view.present(alert, animated: true, completion: nil)
    }
    
    //returns false if error uploading
    func setChoreImage(choreID: String, data : Data, metadata: StorageMetadata, view: UIViewController){
        self.storage?.reference().child("chore_images/\(choreID)").putData(data, metadata: metadata){ (metaData, error) in
            if let error = error {
                self.database_error(error, error_header: "Error uploading file to Database", view: view)
                print("er")
                print(error.localizedDescription)
            } else {
                //store downloadURL
                let downloadURL = metaData!.downloadURL()!.absoluteString
                //store downloadURL at database
                DatabaseAccess.getInstance().ref.child("chores/\(choreID)/imageDownloadURL").setValue(downloadURL)
                self.upload_ok(view: view)
            }
        }
    }
    
    func getChoreImageObserve(choreID : String, view: UIViewController, callback : @escaping (UIImage?) -> Void) {
        
    }
    
    func getChoreImageOnce(choreID : String, callback : @escaping (UIImage?) -> Void) {
        var lookupID = choreID
        if lookupID == "-L89nwC1sN1RHpSDEbrJ" {
            lookupID.append(".jpg")
        }
        print("choreID = \(lookupID)")
        self.storage?.reference().child("chore_images/\(lookupID)").getData(maxSize: 10*1024*1024, completion: { (data, error) in
            if let _ = error {
                print("couldnt find profile pic - using default")
                callback(UIImage(named: "defaultChoreImage"))
                return
            }
            if let image = UIImage(data: data!) {
                callback(image)
            } else {
                callback(nil)
            }
        })
    }
    
    func getUserProfImageOnce(uid : String, callback : @escaping (UIImage?) -> Void) {
        print("getting image for uid: \(uid)")
        self.storage?.reference().child("prof_pics/\(uid)").getData(maxSize: 10*1024*1024, completion: { (data, error) in
            if let _ = error {
                print("couldnt find profile pic - using default")
                callback(UIImage(named: "defualtUserImage"))
                return
            }
            if let image = UIImage(data: data!) {
                callback(image)
            } else {
                callback(nil)
            }
        })
    }
    
}
