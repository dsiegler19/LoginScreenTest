//
//  PublicMessage.swift
//  loginScreen
//
//  Created by Siegler, Dylan on 7/10/18.
//  Copyright © 2018 Wyant, Benjamin. All rights reserved.
//

import Foundation
import UIKit
import MapKit

struct PublicMessage: Codable {
    
    var teamName: String
    var teamID: Int
    var content: String
    private var teamProfilePictureEncoded: String
    var teamProfilePicture: UIImage
    private var timePostedString: String
    var timePosted: Date
    var distance: Double
    private var locationLat: Double
    private var locationLong: Double
    var location: CLLocationCoordinate2D
    
    init(from decoder: Decoder) {
        
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        
        self.teamName = (try! container?.decode(String.self, forKey: .teamName))!
        self.teamID = (try! container?.decode(Int.self, forKey: .teamID))!
        self.content = (try! container?.decode(String.self, forKey: .content))!
        
        self.teamProfilePictureEncoded = (try! container?.decode(String.self, forKey: .teamProfilePictureEncoded))!
        let pfpData = Data(base64Encoded: self.teamProfilePictureEncoded)!
        self.teamProfilePicture = UIImage(data: pfpData)!
        
        self.timePostedString = (try! container?.decode(String.self, forKey: .timePostedString))!
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        self.timePosted = dateFormatter.date(from: timePostedString)!
        
        self.distance = (try! container?.decode(Double.self, forKey: .distance))!
        
        self.locationLat = (try! container?.decode(Double.self, forKey: .locationLat))!
        self.locationLong = (try! container?.decode(Double.self, forKey: .locationLong))!
        self.location = CLLocationCoordinate2D(latitude: locationLat, longitude: locationLong)
        
        
    }
    
    enum CodingKeys: String, CodingKey {
        
        case teamName = "team_name"
        case teamID = "team_id"
        case content
        case teamProfilePictureEncoded = "pfp_encoded"
        case timePostedString = "time_posted"
        case distance
        case locationLat = "location_lat"
        case locationLong = "location_long"
        
    }
    
}

struct PublicMessages: Codable {
    
    let messages: [PublicMessage]
    
}
