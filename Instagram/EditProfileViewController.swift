//
//  EditProfileViewController.swift
//  Instagram
//
//  Created by Michael Hamlett on 6/29/17.
//  Copyright © 2017 Michael Hamlett. All rights reserved.
//

import UIKit
import Fusuma
import Parse

class EditProfileViewController: UIViewController, UITextFieldDelegate, FusumaDelegate{

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bioTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bioTextField.delegate = self
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func changeProfilePicture(_ sender: Any) {
        print("button pressed")
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.hasVideo = false
        self.present(fusuma, animated: true, completion: nil)
        
    }
    

    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    
    @IBAction func updateInfoPressed(_ sender: Any) {
        if let user = PFUser.current() {
            user["profileImage"] =  Post.getPFFileFromImage(image: profileImageView.image) 
            user["bio"] = bioTextField.text
            
            user.saveInBackground()
            print("succesful")
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode){
        profileImageView.image = image
        print("image selected")
        
    }
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode){
        
    }
    func fusumaVideoCompleted(withFileURL fileURL: URL){
        
    }
    func fusumaCameraRollUnauthorized(){
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        bioTextField.resignFirstResponder()
        return true
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
