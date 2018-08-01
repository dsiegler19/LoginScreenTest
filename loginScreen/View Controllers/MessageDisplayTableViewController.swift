//
//  MessageDisplayTableTableViewController.swift
//  loginScreen
//
//  Created by Siegler, Dylan on 7/10/18.
//  Copyright © 2018 Wyant, Benjamin. All rights reserved.
//

import UIKit
import MapKit

class MessageDisplayTableTableViewController: UITableViewController {
    
    private var cellHeights: [CGFloat] = []
    
    private var publicMessages: [PublicMessage]? = nil

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        MessageDisplayController.shared.getMessages(userLocation: CLLocationCoordinate2D(latitude: 17, longitude: 22), radius: 1000) { (messages) in
            
            DispatchQueue.main.async {
             
                if let messages = messages {
                    
                    self.publicMessages = messages
                    self.cellHeights = Array(repeating: 100, count: messages.count)
                    
                    self.tableView.reloadData()
                    
                }
                
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            // If publicMessages is set, return its length
            if publicMessages != nil {
                
                return (publicMessages?.count)!
                
            }
            
            // If not, return 0 for now
            else {
                
                return 0
                
            }
            
        }
        
        else {
            
            return 0
            
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageDisplayTableViewCell

        // Configure the cell only if the data is loaded
        if publicMessages != nil {
            
            cell = configure(cell: cell, row: indexPath.row)
            
        }
        
        return cell
        
    }
    
    private func configure(cell: MessageDisplayTableViewCell, row: Int) -> MessageDisplayTableViewCell {
        
        // Get the message (and check an extra time that it isn't nil)
        guard let message = publicMessages?[row] else { return cell }
        
        // Assign the profile picture and make it round
        cell.profilePicture.image = message.teamProfilePicture
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.width / 2
        cell.profilePicture.clipsToBounds = true
        
        // Assign the team name
        cell.teamNameLabel.text = message.teamName
        
        // Display the message
        cell.messageLabel.text = message.content
        
        // Set the correct height
        cellHeights[row] = cell.messageLabel.frame.maxY
        
        return cell
        
    }

}

class MessageDisplayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
}
