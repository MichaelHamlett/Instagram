//
//  FeedViewController.swift
//  Instagram
//
//  Created by Michael Hamlett on 6/27/17.
//  Copyright © 2017 Michael Hamlett. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class FeedViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var feedTableView: UITableView!
    
    var posts: [PFObject] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedTableView.dataSource = self
        retrievePosts()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        let post = posts[indexPath.row]
        let image = post["media"] as! PFFile
        let likes = post["likesCount"] as! Int
        let caption = post["caption"] as! String
        let username = (post["author"] as! PFUser).username!
        
        
        //get the image data and set the UIImageView to display the image
        image.getDataInBackground({ (image: Data?,error: Error?) in
            if (error != nil) {
                print(error?.localizedDescription ?? "")
            } else {
                let finalImage = UIImage(data: image!)
                cell.gramImage.image = finalImage
            }
        })
        
        cell.usernameLabel.text = username
        cell.captionLabel.text = caption
        cell.likesLabel.text = "\(likes) likes"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableView Count: \(posts.count):")
        return posts.count
    }
    
    func retrievePosts() {
        
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if posts != nil {
                //print(posts!)
                //print(posts!.count)
                self.posts = posts!
                self.feedTableView.reloadData()
                
            } else {
                print(error?.localizedDescription ?? "error")
            }
        }
    }
    

  
    @IBAction func logoutButtonPressed(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
            if let error = error{
                print(error.localizedDescription)
            } else {
                print("logout succesful")
                self.performSegue(withIdentifier: "logOutSegue", sender: self)
            }
            
        }
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
