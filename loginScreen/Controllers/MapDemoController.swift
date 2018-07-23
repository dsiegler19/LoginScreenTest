//
//  MapDemoController.swift
//  loginScreen
//
//  Created by Siegler, Dylan on 7/9/18.
//  Copyright © 2018 Wyant, Benjamin. All rights reserved.
//

import Foundation
import MapKit

class MapDemoController {
    
    static let shared = MapDemoController()
    
    func getTeamsInRadius(userLocation location: CLLocation, radiusInMiles: Double, completion: @escaping ([Team]?) -> Void) {
        
        let latitude: Double = location.coordinate.latitude
        let longitude: Double = location.coordinate.longitude
        
        let queries: [String: String] = [
            "lat": String(latitude),
            "long": String(longitude),
            "radius": String(radiusInMiles)
        ]
        
        let mapDemoURL = Constants.SERVER_URL.appendingPathComponent("mapkit_test").withQueries(queries)!
        
        print(mapDemoURL.absoluteString)
        
        let task = URLSession.shared.dataTask(with: mapDemoURL, completionHandler: { (data, response, error) in
            
            let jsonDecoder = JSONDecoder()
            
            if let data = data, let teams = try? jsonDecoder.decode(Teams.self, from: data) {
                
                completion(teams.teams)
                
            }
                
            else {
                
                completion(nil)
                
            }
            
        })
        
        task.resume()
        
    }
    
}
