//
//  TestTableViewController.swift
//  loginScreen
//
//  Created by Siegler, Dylan on 7/16/18.
//  Copyright © 2018 Wyant, Benjamin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import TCPickerView

class MessageViewDisplayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButton: UIButton!
    
    private var cellHeights: [CGFloat] = []
    
    private var publicMessages: [PublicMessage]? = nil
    private var messagesRequested = false
    
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.filterButton.setTitleColor(.gray, for: .highlighted)
        self.filterButton.setTitleColor(.gray, for: .selected)

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorStyle = .none
                
        self.locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            
            locationManager.requestWhenInUseAuthorization()
            
        }
        
        getMessages()
        
    }
    
    func getMessages() {
        
        if (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse) && !self.messagesRequested {
            
            self.messagesRequested = true
            
            MessageDisplayController.shared.getMessages(userLocation: (locationManager.location?.coordinate)!, radius: 1000) { (messages) in
                
                DispatchQueue.main.async {
                    
                    if let messages = messages {
                        
                        self.publicMessages = messages
                        self.cellHeights = Array(repeating: 100, count: messages.count)
                        
                        self.tableView.reloadData()
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        self.getMessages()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageTableViewCell
        
        // Configure the cell only if the data is loaded
        if publicMessages != nil {
            
            cell = configure(cell: cell, row: indexPath.row)
            
        }
        
        return cell
        
    }
    
    private func configure(cell: MessageTableViewCell, row: Int) -> MessageTableViewCell {
        
        // Get the message (and check an extra time that it isn't nil)
        guard let message = publicMessages?[row] else { return cell }
        
        // Assign the profile picture and make it round
        cell.profilePicture.image = message.teamProfilePicture
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.width / 2
        cell.profilePicture.clipsToBounds = true
        
        // Assign the team name and the time posted
        let boldFont = UIFont(descriptor: cell.teamNameAndTimePosted.font.fontDescriptor.withSymbolicTraits(.traitBold)!, size: cell.teamNameAndTimePosted.font.pointSize)
        let teamNameAndTimePosted = NSMutableAttributedString()
        teamNameAndTimePosted.append(NSAttributedString(string: message.teamName, attributes: [NSAttributedStringKey.font: boldFont]))
        teamNameAndTimePosted.append(NSAttributedString(string:  " • " + timeAgoPostedString(message.timePosted)))
        cell.teamNameAndTimePosted.attributedText = teamNameAndTimePosted
        
        // Display the message
        cell.messageLabel.text = message.content
        
        // Add a small gray footer
        cell.grayFooter.backgroundColor = UIColor(red: 225.0 / 255.0, green: 225.0 / 255.0, blue: 225.0 / 255.0, alpha: 1.0)
        
        // Set the correct height
        cellHeights[row] = cell.messageLabel.frame.maxY
        
        return cell
        
    }
    
    private func timeAgoPostedString(_ timePosted: Date) -> String {
        
        let timeDifference = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: timePosted, to: Date())
        
        if timeDifference.year! > 0 {
            
            return String(timeDifference.year!) + " year" + (timeDifference.year! == 1 ? "" : "s") + " ago"
            
        }
        
        else if timeDifference.month! > 0 {
            
            return String(timeDifference.month!) + " month" + (timeDifference.month! == 1 ? "" : "s") + " ago"

        }
        
        else if timeDifference.day! > 0 {
            
            let days = timeDifference.day!
            
            if days < 7 {
                
                return String(timeDifference.day!) + " day" + (timeDifference.day! == 1 ? "" : "s") + " ago"
                
            }
            
            if days >= 7 {
                
                return String(timeDifference.day! / 7) + " week" + (timeDifference.day! / 7 == 1 ? "" : "s") + " ago"
                
            }
            
        }
        
        else if timeDifference.hour! > 0 {
            
            return String(timeDifference.hour!) + "h ago"
            
        }
            
        else if timeDifference.minute! > 0 {
            
            return String(timeDifference.minute!) + "m ago"
            
        }
        
        return "Now"
        
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        
        print("filter button tapped")
        
        var picker = TCPickerView()
        picker.title = "Cars"
        let cars = [
            "Chevrolet Bolt EV",
            "Subaru WRX",
            "Porsche Panamera",
            "BMW 330e",
            "Chevrolet Volt",
            "Ford C-Max Hybrid",
            "Ford Focus"
        ]
        let values = cars.map { TCPickerView.Value(title: $0) }
        picker.values = values
        picker.selection = .single
        picker.completion = { (selectedIndexes) in
            for i in selectedIndexes {
                print(values[i].title)
            }
        }
        picker.show()
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()

    }
    
}

class MessageTableViewCell: UITableViewCell {
        
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var teamNameAndTimePosted: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var grayFooter: UIImageView!
    
}
