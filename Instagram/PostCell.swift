//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by Michael Hamlett on 6/27/17.
//  Copyright © 2017 Michael Hamlett. All rights reserved.
//

import UIKit
import Foundation
import Parse
import ParseUI

class PostCell: UITableViewCell {

    @IBOutlet weak var gramImage: PFImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    @IBOutlet weak var timeStampLabel: UILabel!
    
    
    var instagramPost: PFObject! {
        didSet {
            self.gramImage.file = instagramPost["image"] as? PFFile
            self.gramImage.loadInBackground()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
