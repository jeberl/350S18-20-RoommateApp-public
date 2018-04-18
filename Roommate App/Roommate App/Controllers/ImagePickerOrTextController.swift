//
//  ImagePickerOrTextController.swift
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

class ImagePickerOrTextController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var writeButtonLabel: UILabel!
    
    //What to do with image after recieved
    var onImageUploadClosure : (Bool) -> Void = { _ in}
    var writeButtonLabelText : String = ""
    
    //The bucket to store the image in in the database
    var bucketStorageName : String = ""
    
    //Store where to return to
    var returnToStoryboardWithName : String = ""
    var returnToControllerIdentifier : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = CAGradientLayer()
        let colorOne = UIColor(red: 0x14/255, green: 0x55/255, blue: 0x7B/255, alpha: 0.5).cgColor
        let colorTwo = UIColor(red: 0x7F/255, green: 0xCE/255, blue: 0xC5/255, alpha: 0.5).cgColor
        layer.colors = [colorOne, colorTwo]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        
        writeButtonLabel.text = writeButtonLabelText
        
        imagePicker.delegate = self
        if returnToStoryboardWithName == "" || returnToControllerIdentifier == "" {
            print("No return value specified when getting image")
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
        if let image = image {
            if let data = UIImageJPEGRepresentation(image, 0.8) {
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpg"
                if bucketStorageName == "chore_images" {
                    let choreID = currentChoreID!
                    ImageStorage.getInstance().setChoreImage(choreID: choreID, data: data, metadata: metaData, view: self)
                }
                
                onImageUploadClosure(true)
                
            }
        }
        print("Image not found")
        onImageUploadClosure(false)
        returnToPreviousView()
    }

    func returnToPreviousView() {
        print("returning")
        let storyboard = UIStoryboard(name: returnToStoryboardWithName, bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: returnToControllerIdentifier) as UIViewController
        
        self.present(controller, animated: true, completion: nil)
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
