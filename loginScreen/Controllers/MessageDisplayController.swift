//
//  MessageDisplayController.swift
//  loginScreen
//
//  Created by Siegler, Dylan on 7/12/18.
//  Copyright © 2018 Wyant, Benjamin. All rights reserved.
//

import Foundation
import MapKit

class MessageDisplayController {
    
    static let shared = MessageDisplayController()
    
    func getMessages(userLocation location: CLLocationCoordinate2D, radius: Double, completion: @escaping ([PublicMessage]?) -> Void) {
        
        let latitude: Double = location.latitude
        let longitude: Double = location.longitude
        
        let queries: [String: String] = [
            "lat": String(latitude),
            "long": String(longitude),
            "radius": String(radius)
        ]
        
        let mapDemoURL = Constants.SERVER_URL.appendingPathComponent("public_messages").withQueries(queries)!
        
        let task = URLSession.shared.dataTask(with: mapDemoURL, completionHandler: { (data, response, error) in
            
            let jsonDecoder = JSONDecoder()
            
            if let data = data, let messages = try? jsonDecoder.decode(PublicMessages.self, from: data) {
                
                completion(messages.messages)
                
            }
                
            else {
                
                completion(nil)
                
            }
            
        })
        
        task.resume()
        
    }
    
}
