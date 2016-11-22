//
//  ViewController.swift
//  Social-Network
//
//  Created by Ron Ramirez on 11/20/16.
//  Copyright © 2016 Mochi Apps. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookButtonTapped(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result,error) in
            
            if error != nil {
                print("ERROR : \(error)")
            }else if result?.isCancelled == true {
                print("User cancelled Facebook Authentication")
            }else {
                
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
                
            }
        }
        
        
    }
    
    //MARK: Helper Functions
    
    func firebaseAuth(_ credential : FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion : { (user, error) in
            
            if error != nil {
                print("ERROR: \(error)")
            } else {
                print("Successfully authenticated with Firebase")
            }
        })
    }

}

