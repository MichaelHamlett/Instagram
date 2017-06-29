//
//  Post.swift
//  Instagram
//
//  Created by Michael Hamlett on 6/27/17.
//  Copyright © 2017 Michael Hamlett. All rights reserved.
//

import UIKit
import Parse

class Post: NSObject {
    
   

    
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy HH:mm"
        let result = formatter.string(from: date)
        
        
        let post = PFObject(className: "Post")
        
        post["media"] = getPFFileFromImage(image: image)
        post["author"] = PFUser.current()
        post["caption"] = caption
        post["likesCount"] = 0
        post["commentsCount"] = 0
        post["timestamp"] = result
        
        post.saveInBackground(block: completion)
        
    }
    
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
 
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
