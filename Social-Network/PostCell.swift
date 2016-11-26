//
//  PostCell.swift
//  Social-Network
//
//  Created by Ron Ramirez on 11/23/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    var post : Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post : Post) {
        self.captionTextView.text = post.caption
        self.likesLabel.text =  "\(post.likes)"
        
//        let photoURL = post.imageUrl
//        print(photoURL)
//        let url = NSURL(string : photoURL)
//        
//        //If data can be converted
//        if let data = NSData(contentsOf: url as! URL){
//            //Use the Image
//            let img = UIImage(data : data as Data)
//            self.postImageView.image = img
//        }

        
    }


}
