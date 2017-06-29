//
//  DetailViewController.swift
//  Instagram
//
//  Created by Michael Hamlett on 6/28/17.
//  Copyright © 2017 Michael Hamlett. All rights reserved.
//

import UIKit
import ParseUI
import Parse


class DetailViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    var post: PFObject?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let post = post {
            
            let image = post["media"] as! PFFile
            let likes = post["likesCount"] as! Int
            let caption = post["caption"] as! String
            let username = (post["author"] as! PFUser).username!
            
            image.getDataInBackground({ (image: Data?,error: Error?) in
                if (error != nil) {
                    print(error?.localizedDescription ?? "")
                } else {
                    let finalImage = UIImage(data: image!)
                    self.postImageView.image = finalImage
                }
            })
            
            usernameLabel.text = username
            captionLabel.text = caption
            likesLabel.text = "\(likes) likes"
        }

        
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
