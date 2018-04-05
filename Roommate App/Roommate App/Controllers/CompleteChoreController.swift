//
//  CompleteChoreController.swift
//  Roommate App
//
//  Created by Jesse Berliner-Sachs on 3/18/18.
//  Copyright © 2018 Team 20. All rights reserved.
//
// Controls the complete chore page.  Takes in user input for which way they want to complete chore (photo,
// message, etc.) and then marks the chore complete in the database
//

import UIKit
import FirebaseStorage

class CompleteChoreController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    var imageStorage : ImageStorage? = nil
    var choreID : String? = nil
    
    @IBOutlet weak var showImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = CAGradientLayer()
        let colorOne = UIColor(red: 0x14/255, green: 0x55/255, blue: 0x7B/255, alpha: 0.5).cgColor
        let colorTwo = UIColor(red: 0x7F/255, green: 0xCE/255, blue: 0xC5/255, alpha: 0.5).cgColor
        layer.colors = [colorOne, colorTwo]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        
        imageStorage = ImageStorage.getInstance()
        imagePicker.delegate = self
        if choreID == nil {
            //Should segue instead back to previous page and throw error
            choreID = "-L89nwC1sN1RHpSDEbrJ"
        }
    }

    @IBAction func TakePhotoButtonPressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)

        }
        
    }
    
    @IBAction func UploadPhotoButtonPressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion : nil)
        
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("imagePickerController called")
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let data = UIImageJPEGRepresentation(image!, 0.8) {
            if let choreID = choreID {
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpg"
                imageStorage!.setChoreImage(choreID: choreID, data: data, metadata: metaData, view: self)
                markChoreCompleted()
                returnToChoreView()
            } else {
                print("ChoreID not found")
            }
        } else {
            print("Image not found")
        }
    }

    func returnToChoreView() {
        print("returning")
        let storyboard = UIStoryboard(name: "HouseScreen", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "ChoreViewController") as UIViewController
        
        self.present(controller, animated: true, completion: nil)
    }

    
    func markChoreCompleted() {
//        let instance = DatabaseAccess.getInstance()
//        let UIDClosure : (String?) -> Void = { (uid) in
//            if let uid = uid {
//                instance.ref
//            } else {
//                
//            }
//        }
//        
//        instance.getUIDFromEmail(email: chore?.assigned_to, callback: <#T##(String?) -> Void#>)
//        
//        //Update User in db
//        DatabaseAccess.getInstance().ref.child("users/\(")
//        //Update House
//        //Update Chore in db
//        //Update Chore in front end
    }


    // text view for inserting written description
    @IBOutlet weak var WrittenDescriptionTextView: UITextView!
    
    // submit button for written description
    @IBAction func WrittenDescriptionSubmitPressed(_ sender: UIButton) {
        // TODO: insert code that sends the written description to the chore and displays it when the chore is clicked under the "completed chores section"
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
