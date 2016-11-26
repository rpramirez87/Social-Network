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
    @IBOutlet weak var likeImageView: UIImageView!
    
    
    var post : Post!
    var likesRef : FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(heartImageTapped))
        tap.numberOfTapsRequired = 1
        likeImageView.addGestureRecognizer(tap)
        likeImageView.isUserInteractionEnabled = true
    }
    
    func heartImageTapped() {
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImageView.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            }else {
                self.likeImageView.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        })

        
    }
    
    func configureCell(post : Post, img : UIImage?) {
        self.post = post
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
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

        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImageView.image = UIImage(named: "empty-heart")
            }else {
                self.likeImageView.image = UIImage(named: "filled-heart")
            }
        })
        
    }
}
