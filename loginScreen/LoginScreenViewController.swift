//
//  LoginScreenViewController.swift
//  loginScreen
//
//  Created by Siegler, Dylan on 6/18/18.
//  Copyright © 2018 Wyant, Benjamin. All rights reserved.
//

import UIKit
import SwiftHash

class LoginScreenViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        
        var username = usernameField.text ?? ""
        var passwordHash = passwordField.text ?? ""
        
        var a = MD5("password")
        
        print(a)
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func unwindSegueToLoginScreenViewController(segue: UIStoryboardSegue) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
