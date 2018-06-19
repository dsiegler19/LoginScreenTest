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
                    
                    // User successfully logged in
                    self.userAccount = acc
                    self.performSegue(withIdentifier: "LoginSuccessful", sender: nil)
                    
                }
                
                else {
                    
                    // Invalid credentials (or some other error)
                    let alert = UIAlertController(title: "Invalid Credentials", message: "Either your username or password are incorrect", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default){ action in
                        
                        self.passwordField.text = nil
                        
                    })
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func unwindToLoginScreenViewController(segue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "LoginSuccessful" {
            
            let colorViewController = segue.destination as! ColorViewController
            colorViewController.userAccount = self.userAccount!
            
        }
        
    }
    
    
}
