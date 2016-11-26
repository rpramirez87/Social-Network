//
//  PostCell.swift
//  Social-Network
//
//  Created by Ron Ramirez on 11/23/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    var post : Post!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(post : Post, img : UIImage?) {
        self.post = post
        self.captionTextView.text = post.caption
        self.likesLabel.text =  "\(post.likes)"
        
        if img != nil {
            self.postImageView.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Unable to download image from Firebase storage")
                } else {
                    print("Image downloaded from Firebase Storage")
                    
                    if let imgData = data {
                        if let img = UIImage(data : imgData) {
                            self.postImageView.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
                
            })
        }
    }
}
