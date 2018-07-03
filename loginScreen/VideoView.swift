//
//  VideoView.swift
//  loginScreen
//
//  Created by Siegler, Dylan on 6/29/18.
//  Copyright © 2018 Wyant, Benjamin. All rights reserved.
//

import UIKit

import UIKit
import AVKit
import AVFoundation

class VideoView: UIView {
        
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var isLoop: Bool = false
    
    // Make sure to pass on the decoder
    required init?(coder decoder: NSCoder) {
        
        super.init(coder: decoder)
        
    }
    
    func configure(url: String) {
        
        if let videoURL = URL(string: url) {
            
            player = AVPlayer(url: videoURL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bounds
            playerLayer?.videoGravity = AVLayerVideoGravity.resize
            
            if let playerLayer = self.playerLayer {
                
                layer.addSublayer(playerLayer)
                
            }
            
            NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
            
        }
        
    }
    
    func play() {
        
        if player?.timeControlStatus != AVPlayerTimeControlStatus.playing {
            
            player?.play()
            
        }
        
    }
    
    func pause() {
        
        player?.pause()
        
    }
    
    func stop() {
        
        player?.pause()
        player?.seek(to: kCMTimeZero)
        
    }
    
    @objc func reachTheEndOfTheVideo(_ notification: Notification) {
        
        if isLoop {
            
            player?.pause()
            player?.seek(to: kCMTimeZero)
            player?.play()
            
        }
        
    }
}
