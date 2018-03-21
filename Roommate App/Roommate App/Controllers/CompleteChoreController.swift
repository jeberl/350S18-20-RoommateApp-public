//
//  CompleteChoreController.swift
//  Roommate App
//
//  Created by Jesse Berliner-Sachs on 3/18/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit
import FirebaseStorage

class CompleteChoreController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    var imageStorage : ImageStorage? = nil
    var chore : ChoreAJ? = nil
    
    @IBOutlet weak var showImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageStorage = ImageStorage.getInstance()
        imagePicker.delegate = self
        if chore?.choreID == nil {
            //Should segue instead back to previous page and throw error

            chore = ChoreAJ(chore_title: "", assignor: "String", assignee: "String", time_assigned: "String", houseID: "String", description: "String")
            chore?.choreID = "testChoreID"
        }
    }

    @IBAction func TakePhotoButtonPressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
        markChoreCompleted()
    }
    
    @IBAction func UploadPhotoButtonPressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion : nil)
            imageStorage?.getChoreImageOnce(choreID: (chore?.choreID!)!, view: self, callback: { (image) in
                if image != nil {
                    self.showImage.image = image
                }
            })
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("imagePickerController called")
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let data = UIImageJPEGRepresentation(image!, 0.8) {
            if let choreID = chore?.choreID {
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpg"
                imageStorage!.setChoreImage(choreID: choreID, data: data, metadata: metaData, view: self)
                markChoreCompleted()
            } else {
                print("ChoreID not found")
            }
        } else {
            print("Image not found")
        }
        
    }

    func markChoreCompleted() {
        
    }
    
    @IBAction func WrittenDescriptionButtonPressed(_ sender: UIButton) {

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
