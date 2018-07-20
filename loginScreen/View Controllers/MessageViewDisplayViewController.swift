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

class MessageViewDisplayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    
    private var cellHeights: [CGFloat] = []
    
    @IBOutlet weak var pickerViewTest: UIPickerView!
    
    private var publicMessages: [PublicMessage]? = nil
    private var messagesRequested = false
    
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.pickerViewTest.layer.zPosition = 2
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorStyle = .none
        
        self.pickerViewTest.dataSource = self;
        self.pickerViewTest.delegate = self;
        
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
        
        // Assign the team name
        cell.teamNameLabel.text = message.teamName
        
        // Display the message
        cell.messageLabel.text = message.content
        
        // Set the correct height
        cellHeights[row] = cell.messageLabel.frame.maxY
        
        return cell
        
    }

    @IBAction func onPickerViewTestTapped(_ sender: Any) {
        
        self.pickerViewTest.isHidden = true;
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var a = ["a", "b", "c", "d", "e"]
        return a[row]
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()

    }
    
}

class MessageTableViewCell: UITableViewCell {
        
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
}
