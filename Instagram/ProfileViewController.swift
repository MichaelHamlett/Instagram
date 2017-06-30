//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Michael Hamlett on 6/28/17.
//  Copyright © 2017 Michael Hamlett. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import QuartzCore

class ProfileViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bioLabel: UILabel!
    
    var posts: [PFObject] = []
    
    var profilePic: PFObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = layout.minimumInteritemSpacing
        let cellsPerLine: CGFloat = 3
        let interItemSpacing = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = collectionView.frame.size.width / cellsPerLine - interItemSpacing
        layout.itemSize = CGSize(width: width, height: width)
        
        
        collectionView.dataSource = self
        
        let user = PFUser.current()
        //print(name)
        if let bio = user?["bio"]{
            bioLabel.text = (bio as! String)
        }
        if user!["profileImage"] != nil {
            let profilePic = user!["profileImage"] as! PFFile
            profilePic.getDataInBackground { (image: Data?, error: Error?) in
                if (error != nil) {
                    print(error?.localizedDescription ?? "error")
                } else {
                    let finalImage = UIImage(data: image!)
                    self.profileImageView.image = finalImage
                }
            }
        }
    
        retrievePosts()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gramCell", for: indexPath) as! gramProfileCell
        
        let post = posts[indexPath.row]
        let image = post["media"] as! PFFile
        
        //get the image data and set the UIImageView to display the image
        image.getDataInBackground({ (image: Data?,error: Error?) in
            if (error != nil) {
                print(error?.localizedDescription ?? "")
            } else {
                let finalImage = UIImage(data: image!)
                cell.gramPost.image = finalImage
            }
        })
        
        nameLabel.text = (post["author"] as! PFUser).username!
        
        return cell
        
    }
    
    
   
    func retrievePosts() {
        
        let user = PFUser.current()

        
        
        let predicate = NSPredicate(format: "author = %@", user!)
        let query = PFQuery(className: "Post", predicate: predicate)
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.limit = 20
        
        
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if posts != nil {
                //print(posts!)
                //print(posts!.count)
                self.posts = posts!
                self.collectionView.reloadData()
                //self.refreshControl.endRefreshing()
                
            } else {
                print(error?.localizedDescription ?? "error")
            }
        }
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "collectionViewSegue"{
            let cell = sender as! UICollectionViewCell
            
            if let indexPath = collectionView.indexPath(for: cell){
                let post = posts[indexPath.row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.post = post
            }
        }
        
    }
    
        
    
        

}
