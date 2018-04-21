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
    
    @IBOutlet weak var inputDefualtTextPrompt: UILabel!
    @IBOutlet weak var WrittenDescriptionTextView: UITextView!
    @IBOutlet weak var writeButtonLabel: UILabel!
    
    var gottenText : String? = nil
    var gottenImageURl : String? = nil
    
    private var hiddenSettings : imagePickerSettings? = nil
    
    var settings : imagePickerSettings {
        get {
            return hiddenSettings!
        }
        set (newSettings) {
            assert(newSettings.areValid())
            hiddenSettings = newSettings
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = CAGradientLayer()
        let colorOne = UIColor(red: 0x14/255, green: 0x55/255, blue: 0x7B/255, alpha: 0.5).cgColor
        let colorTwo = UIColor(red: 0x7F/255, green: 0xCE/255, blue: 0xC5/255, alpha: 0.5).cgColor
        layer.colors = [colorOne, colorTwo]
        layer.frame = view.frame
        view.layer.insertSublayer(layer, at: 0)
        imagePicker.delegate = self
        
        writeButtonLabel?.text = settings.writeButtonLabelText
        inputDefualtTextPrompt?.text = settings.writePageInputMessagePrompt!
        
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
    
    @IBAction func writeButtonPressed(_ sender: UIButton, forEvent event: UIEvent) {
        if settings.writeShouldGetTextFromDeafultStoryboard {
            print("prompt: \(settings.writePageInputMessagePrompt)")
            performSegue(withIdentifier: "defualtTextInputSegue", sender: self)
            
        } else {
            customWritePageSegue()
        }
    }
    
    // submit button for written description
    @IBAction func WrittenDescriptionSubmitPressed(_ sender: UIButton) {
        gottenText = WrittenDescriptionTextView.text
        moveToRecieverStoryboard()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("imagePickerController called")
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let image = image {
            if let data = UIImageJPEGRepresentation(image, 0.8) {
                let urlClosure : (String?) -> Void = { (url) in
                    self.gottenImageURl = url
                    self.moveToRecieverStoryboard()
                }
                var id = String(Darwin.arc4random()) // ID is a random 32-bit int unless otherwise specified
                if settings.bucketStorageName == "chore_images" {
                    id = currentChoreID!
                }
                ImageStorage.getInstance().uploadImage(data, toBucket: settings.bucketStorageName, withid: id, urlClosure: urlClosure, view: self)
            }
        } else {
            print("Image not found")
            moveToRecieverStoryboard()
        }
    }
    
    func customWritePageSegue() {
        print("moving on custom write segue \(settings.customWriteSegueIdentifier!)")
        performSegue(withIdentifier: settings.customWriteSegueIdentifier!, sender: self)
    }
    
    func moveToRecieverStoryboard() {
        print("moving to chosen storyboard with segue identifier \(settings.onCompleteSegueIdentifier)")
        performSegue(withIdentifier: settings.onCompleteSegueIdentifier, sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing for segue with identifier \(segue.identifier)")
        if segue.identifier == settings.onCompleteSegueIdentifier {
            let destination = segue.destination as! UIViewImageTextPickerDestination
            let gotInfo = gottenImageURl != nil || gottenText != nil
            destination.getSelectedImageOrText(wasSuccessful : gotInfo, imageURL : gottenImageURl, text : gottenText)
        }
        if segue.identifier == settings.customWriteSegueIdentifier {
            settings.prepareCustomWriteClosure(segue.destination)
        }
        if segue.identifier == "defualtTextInputSegue" {
            let destination = segue.destination as! ImagePickerOrTextController
            destination.settings = settings
        }
    }
}

protocol UIViewImageTextPickerDestination {
    func getSelectedImageOrText(wasSuccessful : Bool, imageURL : String?, text : String?)
}

class imagePickerSettings {
    // Where to return after page
    var onCompleteSegueIdentifier : String

    //What to do with image after recieved
    var bucketStorageName : String // The bucket to store the image in in the database
    
    //Settings for what to do on write button pressed
    var writeShouldGetTextFromDeafultStoryboard : Bool
    //for defualt
    var writeButtonLabelText : String? = nil
    var writePageInputMessagePrompt : String? = nil
    //for custom
    var prepareCustomWriteClosure : (UIViewController) -> Void = { (controller) in }
    var customWriteSegueIdentifier : String? = nil
    
    
    init(onCompleteSegueIdentifier : String, writeShouldGetTextFromDeafultStoryboard : Bool,bucketStorageName : String) {
        self.onCompleteSegueIdentifier = onCompleteSegueIdentifier
        self.bucketStorageName = bucketStorageName

        self.writeShouldGetTextFromDeafultStoryboard = writeShouldGetTextFromDeafultStoryboard
    }
    
    func setDefualtWritePage(writeButtonLabelText : String, writePageInputMessagePrompt : String) {
        self.writeButtonLabelText = writeButtonLabelText
        self.writePageInputMessagePrompt = writePageInputMessagePrompt
    }
    
    func setCustomWritePage(prepareCustomWriteClosure : @escaping (UIViewController) -> Void, customWriteSegueIdentifier : String) {
        self.prepareCustomWriteClosure = prepareCustomWriteClosure
        self.customWriteSegueIdentifier = customWriteSegueIdentifier
    }
    
    func areValid() -> Bool {
        var areSetCorretly = true
        if !writeShouldGetTextFromDeafultStoryboard {
            if customWriteSegueIdentifier == nil {
                print("If trying to move to custom view controller on write must specify segue to use")
                areSetCorretly = false
            }
        } else {
            if writePageInputMessagePrompt == nil {
                print("If trying to move to defualt text input view controller on write button pressed must specify message prompt")
                areSetCorretly = false
            }
        }
        return areSetCorretly
    }
}
