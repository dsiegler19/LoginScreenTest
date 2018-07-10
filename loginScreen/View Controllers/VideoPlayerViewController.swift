//
//  VideoPlayerViewController.swift
//  loginScreen
//
//  Created by Siegler, Dylan on 6/29/18.
//  Copyright © 2018 Wyant, Benjamin. All rights reserved.
//

import UIKit

class VideoPlayerViewController: UIViewController {

    @IBOutlet weak var videoView: VideoView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        videoView.configure(url: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        videoView.play()

    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()

    }
    
}
