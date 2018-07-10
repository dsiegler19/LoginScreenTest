//
//  ColorViewController.swift
//  loginScreen
//
//  Created by Siegler, Dylan on 6/18/18.
//  Copyright © 2018 Wyant, Benjamin. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController {
    
    @IBOutlet weak var colorLabel: UILabel!
    
    var userAccount: UserAccount!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        colorLabel.text = userAccount.color
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
}
