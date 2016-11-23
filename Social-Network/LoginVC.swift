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
    @IBOutlet weak var emailTxtField: CustomTextField!

    @IBOutlet weak var passwordTxtField: CustomTextField!
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
    @IBAction func signinButtonTapped(_ sender: Any) {
        
        if let email = emailTxtField.text, let password = passwordTxtField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if error == nil {
                    print("Email user is authenticated")
                }else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        
                        if error != nil {
                            print("Unable to authenticate with Firebase using email")
                        } else {
                            print("Sucessfully authenticated with Firebase")
                        }
                    })
                }
        })
        
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

