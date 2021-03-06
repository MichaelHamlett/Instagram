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
import QuartzCore

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{
    
    @IBOutlet weak var feedTableView: UITableView!
    
    var posts: [PFObject] = []
    var refreshControl = UIRefreshControl()
    var isMoreDataLoading = false
    var queryLimit = 15
    //var loadingMoreView:InfiniteScrollActivityView?


    override func viewDidLoad() {
        super.viewDidLoad()
    
        //code to set up refresh control
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(FeedViewController.didPullToRefresh(_:)), for: .valueChanged)
        feedTableView.insertSubview(refreshControl, at: 0)
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        retrievePosts()

        
    }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        
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
        let timestamp = post["timestamp"]
        let user = post["author"] as! PFUser
        
        //setting profile image
        if user["profileImage"] != nil {
            let profilePic = user["profileImage"] as! PFFile
            profilePic.getDataInBackground { (image: Data?, error: Error?) in
                if (error != nil) {
                    print(error?.localizedDescription ?? "error")
                } else {
                    let finalImage = UIImage(data: image!)
                    cell.profileImage.image = finalImage
                }
            }
        }
        
        
        //get the image data and set the UIImageView to display the image
        image.getDataInBackground({ (image: Data?,error: Error?) in
            if (error != nil) {
                print(error?.localizedDescription ?? "")
            } else {
                let finalImage = UIImage(data: image!)
                cell.gramImage.image = finalImage
            }
        })
        
        //Setting up text so that username appears bold before the caption
        let boldName = username
        let attributedString = NSMutableAttributedString(string:" \(caption)")
        let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 15)]
        let boldString = NSMutableAttributedString(string:boldName, attributes:attrs)
        boldString.append(attributedString)
        
        
        
        
        cell.usernameLabel.text = username
        cell.captionLabel.attributedText = boldString
        cell.likesLabel.text = "\(likes) likes"
        cell.timeStampLabel.text = (timestamp as! String)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("tableView Count: \(posts.count):")
        return posts.count
    }
    
    func retrievePosts() {
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        queryLimit += 5
        query.limit = queryLimit
        
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if posts != nil {
                //print(posts!)
                //print(posts!.count)
                self.posts = posts!
                self.feedTableView.reloadData()
                self.isMoreDataLoading = false
                self.refreshControl.endRefreshing()
                print(self.queryLimit)
                
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
                PFUser.logOutInBackground()
                let logInScreen = self.storyboard?.instantiateInitialViewController()
                self.present(logInScreen!, animated: true, completion: nil)
            }
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = feedTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - feedTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && feedTableView.isDragging) {
                self.pleaseWait()
                isMoreDataLoading = true
                retrievePosts()
                self.clearAllNotice()
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
    
    
    
    
