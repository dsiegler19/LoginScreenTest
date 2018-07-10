//
//  Team.swift
//  loginScreen
//
//  Created by Siegler, Dylan on 7/9/18.
//  Copyright © 2018 Wyant, Benjamin. All rights reserved.
//

import Foundation
import MapKit

struct Team: Codable {
    
    var teamName: String
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        
        case teamName = "team_name"
        case latitude
        case longitude
        
    }
    
}

struct Teams: Codable {
    
    let teams: [Team]
    
}

class TeamAnnotation: NSObject, MKAnnotation {
    
    var teamName: String?
    var coordinate: CLLocationCoordinate2D
    
    var title: String? {
        
        return teamName
        
    }
    
    init(team: Team) {
        
        self.teamName = team.teamName
        self.coordinate = CLLocationCoordinate2D(latitude: team.latitude, longitude: team.longitude)
        
        super.init()
        
    }
    
}

