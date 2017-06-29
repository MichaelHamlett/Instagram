//
//  LoginViewController.swift
//  Instagram
//
//  Created by Michael Hamlett on 6/26/17.
//  Copyright © 2017 Michael Hamlett. All rights reserved.
//

import UIKit
import Parse
import Pastel


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        
        let pastelView = PastelView(frame: view.bounds)
        
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 3.0
        
        // Custom Color
        pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                              UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                              UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                              UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
        

        // Do any additional setup after loading the view.
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func onSignIn(_ sender: Any) {
        
        
        PFUser.logInWithUsername(inBackground: usernameField.text! , password: passwordField.text!) { (user: PFUser?, error: Error?) in
            if user != nil {
                print("Login succesful")
                
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
        
    }
    
    
    
    
    
    @IBAction func onSignUp(_ sender: Any) {
        
        let newUser = PFUser()
        //print("onSignUp")
        
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("User Registered successfully")
            
            }
        }
    }

    
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
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
