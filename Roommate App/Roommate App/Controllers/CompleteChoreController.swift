//
//  CompleteChoreController.swift
//  Roommate App
//
//  Created by Jesse Berliner-Sachs on 3/18/18.
//  Copyright © 2018 Team 20. All rights reserved.
//

import UIKit

class CompleteChoreController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //imagePicker.delegate = self
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
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func WriteDescriptionButtonPressed(_ sender: UIButton) {
        
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
