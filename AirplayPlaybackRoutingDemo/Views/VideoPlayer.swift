//
//  VideoPlayer.swift
//  AirplayPlaybackRoutingDemo
//
//  Created by Itsuki on 2025/11/01.
//


import AVKit
import SwiftUI

// Wrapper around AVPlayerViewController to hide system controls
struct VideoPlayer: UIViewControllerRepresentable {
    let player: AVPlayer
    
    init(player: AVPlayer) {
        self.player = player
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerController = AVPlayerViewController()
        
        playerController.showsPlaybackControls = false
        playerController.player = self.player
        
        return playerController
    }
    
    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        playerController.updatesNowPlayingInfoCenter = true
    }
}
