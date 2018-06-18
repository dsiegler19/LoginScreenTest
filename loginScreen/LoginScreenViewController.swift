//
//  LoginScreenViewController.swift
//  loginScreen
//
//  Created by Siegler, Dylan on 6/18/18.
//  Copyright © 2018 Wyant, Benjamin. All rights reserved.
//

import UIKit
import SwiftHash
import Foundation

class LoginScreenViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var userAccount: UserAccount?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        let username = usernameField.text ?? ""
        let passwordHash = MD5(passwordField.text ?? "").lowercased()
        
        LoginController.shared.attemptLogin(username, passwordHash) { (acc) in
            
            DispatchQueue.main.async {
                
                if let acc = acc {
                    
                    self.userAccount = acc
                    self.performSegue(withIdentifier: "LoginSuccessful", sender: nil)
                    
                }
                
                else {
                    
                    print("Invalid")
                    // Find a way to display this
                    
                }
                
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "LoginSuccessful" {
            
            let colorViewController = segue.destination as! ColorViewController
            colorViewController.userAccount = self.userAccount!
            
        }
        
    }
    
    
}
