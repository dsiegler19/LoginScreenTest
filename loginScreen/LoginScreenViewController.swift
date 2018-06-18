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
        
        LoginController.shared.attemptLogin(username, passwordHash) { (UserAccount) in
            
            
            
        }
        
        /*if let acc = LoginController.shared.attemptLogin(username, passwordHash) {
            
            userAccount = acc
            
            self.performSegue(withIdentifier: "LoginSuccessful", sender: nil)
            
        }*/
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "LoginSuccessful" {
            
            let colorViewController = segue.destination as! ColorViewController
            colorViewController.userAccount = userAccount!
            
        }
        
    }
    
    
}
