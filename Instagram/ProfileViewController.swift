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
    
    var posts: [PFObject] = []

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
        
        return cell
        
    }
    
    
   
    func retrievePosts() {
        
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.limit = 20
        
        //query.whereKey("author", matchesKey: "username", in: posts)
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
        let cell = sender as! UICollectionViewCell
        
        if let indexPath = collectionView.indexPath(for: cell){
            let post = posts[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.post = post
            
        }
    }
    
        
    
        

}