//
//  ContentView.swift
//  PlaybackRoutingDemo
//
//  Created by Itsuki on 2025/10/31.
//

import SwiftUI
import AVKit


struct ContentView: View {
    @State private var playbackManager: PlaybackManager = PlaybackManager()
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    HStack {
                        Text("Detect Routing Device")
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .layoutPriority(1)

                        Toggle(isOn: $playbackManager.isDetectingRoutes, label: {})
                    }
                    
                    HStack {
                        Text("Pick Routing Device")
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .layoutPriority(1)
                        Spacer()
                        if self.playbackManager.routesDetected {
                            RoutePickerView()
                        } else {
                            Image(systemName: "airplay.video.badge.exclamationmark")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 24)
                                .foregroundStyle(.gray)
                        }
                    }
                }
                                
                VideoPlayer(player: self.playbackManager.player)
                    .padding(.vertical, 8)
                
                HStack {
                    Button(action: {
                        self.playbackManager.seek(by: -10)
                    }, label: {
                        Image(systemName: "10.arrow.trianglehead.counterclockwise")
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        self.playbackManager.playerStatus == .playing ? self.playbackManager.pause() : self.playbackManager.play()
                    }, label: {
                        Image(systemName: self.playbackManager.playerStatus == .playing ? "pause.fill" : "play.fill" )
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        self.playbackManager.seek(by: 10)
                    }, label: {
                        Image(systemName: "10.arrow.trianglehead.clockwise")
                    })
                    
                    Spacer()
                    
                    Menu(content: {
                        Button(action: {
                            self.playbackManager.playbackRate = 0.5
                        }, label: {
                            Text("0.5x")
                        })
                        Button(action: {
                            self.playbackManager.playbackRate = 1.0
                        }, label: {
                            Text("1.0x")
                        })
                        Button(action: {
                            self.playbackManager.playbackRate = 2.0
                        }, label: {
                            Text("2.0x")
                        })
                        
                    }, label: {
                        Text("\(String(format: "%.1f", self.playbackManager.playbackRate))x")
                    })

                }
                .font(.title2)
                .fontWeight(.medium)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.yellow.opacity(0.1))
            .onAppear {
                guard let url = Bundle.main.url(forResource: "demo", withExtension: "mp4") else {
                    return
                }

                self.playbackManager.updatePlayerItem(url)
            }
            .navigationTitle("AirPlay Demo")

        }
    }
}



#Preview {
    ContentView()
}
