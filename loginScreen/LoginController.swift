//
//  LoginController.swift
//  loginScreen
//
//  Created by Siegler, Dylan on 6/18/18.
//  Copyright © 2018 Wyant, Benjamin. All rights reserved.
//

import Foundation

class LoginController {
    
    static let shared = LoginController()
    
    let baseURL = URL(string: "http://localhost:8080/")!
    
    func attemptLogin(_ username: String, _ passwordHash: String, completion: @escaping (UserAccount?) -> Void) {
        
        let loginURL = baseURL.appendingPathComponent("login").withQueries(["username": username, "password": passwordHash])!
                        
        let task = URLSession.shared.dataTask(with: loginURL, completionHandler: { (data, response, error) in
            
            let jsonDecoder = JSONDecoder()
                        
            if let data = data, let userAccount = try? jsonDecoder.decode(UserAccount.self, from: data) {
                
                completion(userAccount)
                
            }
            
            else {
                
                completion(nil)
                
            }
            
        })
        
        task.resume()
        
    }
    
}
