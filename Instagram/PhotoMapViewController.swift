//
//  ViewController.swift
//  Instagram
//
//  Created by Michael Hamlett on 6/26/17.
//  Copyright © 2017 Michael Hamlett. All rights reserved.
//

import UIKit
import Fusuma
import MBProgressHUD

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, FusumaDelegate {
    
    @IBOutlet weak var instagramPost: UIImageView!
    @IBOutlet weak var postTextField: UITextField!
    @IBOutlet weak var initiatePostButton: UIButton!
    
    
    @IBAction func initiatePost(_ sender: Any) {
        
        /*
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = UIImagePickerControllerSourceType.camera
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
            vc.sourceType = .photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
        */
        
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.hasVideo = false
        self.present(fusuma, animated: true, completion: nil)
 
 
    }
    
    @IBAction func sharePost(_ sender: Any) {
        print("sharePost pressed")
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Post.postUserImage(image: instagramPost.image, withCaption: postTextField.text) { (success: Bool, error: Error?) in
            print("postUserImage called")
            if success {
                print("Post Succesful")
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                MBProgressHUD.hide(for: self.view, animated: true)
                self.present(vc, animated: true, completion: nil)
            }
            else {
                print(error?.localizedDescription ?? "error")
            }
        }
        
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        instagramPost.image = nil
        initiatePostButton.alpha = 0.3
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        instagramPost.image = editedImage
        initiatePostButton.alpha = 0
        
        dismiss(animated: true, completion: nil)
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        postTextField.delegate = self
        
    }
    
   
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        postTextField.resignFirstResponder()
        
        return true
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode){
        instagramPost.image = image
        initiatePostButton.alpha = 0
        print("image selected")
        
    }
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode){
        
    }
    func fusumaVideoCompleted(withFileURL fileURL: URL){
        
    }
    func fusumaCameraRollUnauthorized(){
        
    }
    
    
    
    
    
    


}

