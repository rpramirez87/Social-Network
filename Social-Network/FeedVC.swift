//
//  FeedVC.swift
//  Social-Network
//
//  Created by Ron Ramirez on 11/23/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cameraImageView: CustomImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var captionTextField: CustomTextField!
    
    
    static var imageCache : NSCache<NSString, UIImage> = NSCache()
    var didSelectImage = false
    
    var posts = [Post]()
    var imagePicker : UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                //Clear all posts
                self.posts = []
                
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                        
                        
                    }
                }
                self.tableView.reloadData()
            }
            
        })
        

        // Do any additional setup after loading the view.
    }


    @IBAction func signOutButtonTapped(_ sender: Any) {
        let keyChainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("User signed out \(keyChainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goBackToLoginVC", sender: nil)
        
    }
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
            }else {
                cell.configureCell(post: post, img: nil)
            }
            return cell
        }else {
            return PostCell()
        }
    }
    
    //MARK : ImagePicker Delegate Functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            cameraImageView.image = image
            didSelectImage = true
        }else {
            print("A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

 
    @IBAction func postButtonTapped(_ sender: Any) {
        print("Hello")
        guard let caption = captionTextField.text, caption != "" else {
            print("Must enter caption text field")
            return
        }
        
        guard let image = cameraImageView.image, didSelectImage == true else {
            print("Must select an image to post")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(image, 0.2) {
            
            let imgUID = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            DataService.ds.REF_POST_IMAGES.child(imgUID).put(imgData, metadata: metaData) { (metaData,  error) in
                if error != nil {
                    print("Unable to upload image to Firebase Storage")
                }else {
                    print("Successfully downloaded image to Firebase StoragE")
                    let downloadURL = metaData?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imgUrl: url)
                    }
                }
            }
        }
    }
    
    func postToFirebase(imgUrl : String) {
        let post : Dictionary<String, AnyObject> = [
            "caption" : captionTextField.text as AnyObject,
            "imageUrl" : imgUrl as AnyObject,
            "likes" : 0 as AnyObject
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        
        captionTextField.text = ""
        didSelectImage = false
        cameraImageView.image = UIImage(named: "add-image")
        
        self.tableView.reloadData()
        
    }


}
