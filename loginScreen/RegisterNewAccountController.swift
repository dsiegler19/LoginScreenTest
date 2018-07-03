//
//  RegisterNewAccountController.swift
//  loginScreen
//
//  Created by Siegler, Dylan on 6/19/18.
//  Copyright © 2018 Wyant, Benjamin. All rights reserved.
//

import Foundation
import SwiftHash

struct RegisterNewAccountController {
    
    static let shared = RegisterNewAccountController()
    
    let baseURL = URL(string: "http://localhost:5000/")!
    
    func attemptRegisterNewUser(username: String, passwordString: String, email: String, color: String, completion: @escaping ([String]?) -> Void) {
        
        let passwordHash = MD5(passwordString).lowercased()
        
        let data = ["username": username,
                       "password": passwordHash,
                       "email": email,
                       "color": color]
        
        let registerURL = baseURL.appendingPathComponent("register")
        
        var request = URLRequest(url: registerURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: [])
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            let jsonDecoder = JSONDecoder()
            
            if let data = data, let response = try? jsonDecoder.decode([String: [String]].self, from: data), let validity = response["result"] {
                
                completion(validity)
                
            }
                
            else {
                
                completion(nil)
                
            }
            
        })
        
        task.resume()
        
    }

}
