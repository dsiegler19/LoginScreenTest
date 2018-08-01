//
//  MessageMarkupParser.swift
//  loginScreen
//
//  Created by Siegler, Dylan on 7/12/18.
//  Copyright © 2018 Wyant, Benjamin. All rights reserved.
//

import Foundation
import UIKit

struct MessageMarkupParser {
    
    static let shared = MessageMarkupParser()
    
    func parseMessage(message: String) {
        
        // Make the string
        var text = NSMutableAttributedString(string: message)
        
        // Do a pass checking for italics
        for index in message.indices {
            
            // print(index);
            // see playtastic.playground
            
        }
        
    }
    
    /*
     Algo to parse:
     Go through each char and look for "opening" and "closing" _, *, etc. then once it finds the closing, annotate it using the method
     in NSMutableAttributedString that allows you to change attributes of parts of text in place
     */
    
}

struct MessageStyleInfo {
    
    let profilePicture: UIImage?
    let text: NSMutableAttributedString
    let attachedImage: UIImage?
    
    init() {
        
        // Fill this in later
        self.profilePicture = nil
        self.text = NSMutableAttributedString()
        self.attachedImage = nil
        
    }
    
    /*
     how to encode the attributed string:
     let attrbStr = NSMutableAttributedString()
     
     let data = NSKeyedArchiver.archivedData(withRootObject: attrbStr)
     
     let encoder = JSONEncoder()
     data.base64EncodedString()
    */
    
}
