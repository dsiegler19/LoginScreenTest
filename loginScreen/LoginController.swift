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
    
    func attemptLogin(_ username: String, _ passwordHash: String) {
        
        let verifyURL = baseURL.appendingPathComponent("verify").withQueries(["username": username, "password": passwordHash])!
        
        print(verifyURL)
        
        let task = URLSession.shared.dataTask(with: verifyURL, completionHandler: { (data, response, error) in
            
            if let data = data, let jsonDictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                
                print(jsonDictionary)
                print(jsonDictionary?["username"])
                print(type(of: jsonDictionary?["username"]!))
                
            }
            
        })
        
        task.resume()
        
    }
    
}
