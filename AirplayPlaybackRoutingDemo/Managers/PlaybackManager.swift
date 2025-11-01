//
//  PlaybackManager.swift
//  AirplayPlaybackRoutingDemo
//
//  Created by Itsuki on 2025/11/01.
//

import SwiftUI
import Combine
import AVKit

extension Notification.Name {
    var publisher: NotificationCenter.Publisher {
        return NotificationCenter.default.publisher(for: self)
    }
}


@Observable
class PlaybackManager {
    
    // MARK: Routes Detection properties
    var isDetectingRoutes: Bool = false {
        didSet {
            // Enabling route detection significantly increases power consumption.
            // Only Turn it on when we need it.
            self.routeDetector.isRouteDetectionEnabled = isDetectingRoutes
        }
    }
    
    
    private(set) var routesDetected: Bool = false
    
    private let routeDetector: AVRouteDetector = AVRouteDetector()
    
    @ObservationIgnored
    private var routeDetectionCancellable: AnyCancellable?
    
    
    // MARK: AVPlayer properties
    private(set) var player: AVPlayer
    
    var isExternalPlaybackActive: Bool {
        return self.player.isExternalPlaybackActive
    }
    
    var currentPlayerItem: AVPlayerItem? {
        return self.player.currentItem
    }

    var playerStatus: AVPlayer.TimeControlStatus {
        return self.player.timeControlStatus
    }
    
    var playbackRate: Float {
        get {
            return self.player.rate
        }
        set {
            self.player.rate = newValue
        }
    }


    // MARK: init & deinit
    init() {
        // to support monitoring playback state with Observation
        AVPlayer.isObservationEnabled = true

        let player = AVPlayer()
        player.volume = 1.0
        player.allowsExternalPlayback = true
        player.externalPlaybackVideoGravity = .resizeAspect
        // A Boolean value that indicates whether the player should automatically switch to external playback mode while the external screen mode is active.
        player.usesExternalPlaybackWhileExternalScreenIsActive = true
        self.player = player
        
        // Set detectsCustomRoutes to true if your app uses an instance of AVCustomRoutingController.
        self.routeDetector.detectsCustomRoutes = false
        self.setupRouteDetectionNotification()
        
        // set up audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default, policy: .longFormVideo)
            try audioSession.setActive(true)
        } catch(let error) {
            print(error)
        }
    }
    
    deinit {
        self.routeDetectionCancellable?.cancel()
        self.routeDetectionCancellable = nil
        try? AVAudioSession.sharedInstance().setActive(false)
    }

}


// MARK: Player controls
extension PlaybackManager {
    func updatePlayerItem(_ url: URL) {
        let playerItem = AVPlayerItem(url: url)
        self.player.replaceCurrentItem(with: playerItem)
    }
    
    func play() {
        if self.player.currentTime() == self.currentPlayerItem?.duration {
            self.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
        }
        self.player.play()
    }
    
    func pause() {
        self.player.pause()
    }

    // fast forward, fast backward
    func seek(by delta: Double) {
        let targetTime = self.player.currentTime().seconds + delta
        
        self.seek(to: CMTime(seconds: targetTime, preferredTimescale: 1))
    }

}


// MARK: Private helpers
extension PlaybackManager {
    
    private func seek(to time: CMTime) {
        self.player.seek(
            to: time,
            toleranceBefore: .zero,
            toleranceAfter: .zero
        )
    }

    
    private func setupRouteDetectionNotification() {
        // AVRouteDetectorMultipleRoutesDetectedDidChange: A notification the system posts when changes occur to its detected routes.
        self.routeDetectionCancellable = NSNotification.Name.AVRouteDetectorMultipleRoutesDetectedDidChange.publisher.receive(
            on: DispatchQueue.main
        ).sink { _ in
            if self.isDetectingRoutes {
                self.routesDetected = self.routeDetector.multipleRoutesDetected
            }
        }
    }
}
