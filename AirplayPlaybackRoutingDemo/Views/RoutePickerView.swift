//
//  RoutePickerView.swift
//  AirplayPlaybackRoutingDemo
//
//  Created by Itsuki on 2025/11/01.
//


import SwiftUI
import AVKit

struct RoutePickerView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> AVRoutePickerView {
        let routePickerView = AVRoutePickerView()
        
        // set delegate
        routePickerView.delegate = context.coordinator

        // Configure the route picker view
        routePickerView.backgroundColor = UIColor.clear
        routePickerView.tintColor = UIColor.black
        routePickerView.activeTintColor = UIColor.blue
        routePickerView.prioritizesVideoDevices = true

        return routePickerView
    }
    
    func updateUIView(_ uiView: AVRoutePickerView, context: Context) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, AVRoutePickerViewDelegate {
        var parent: RoutePickerView
        
        init(_ parent: RoutePickerView) {
            self.parent = parent
        }
        
        func routePickerViewWillBeginPresentingRoutes(_ routePickerView: AVRoutePickerView) {
            print(#function)
        }
        
        func routePickerViewDidEndPresentingRoutes(_ routePickerView: AVRoutePickerView) {
            print(#function)
        }
        
    }
}

