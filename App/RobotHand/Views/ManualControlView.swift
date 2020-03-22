//
//  ManualControlView.swift
//  RobotHand
//
//  Created by Christian on 13/3/20.
//  Copyright © 2020 Christian. All rights reserved.
//

import SwiftUI

struct ManualControlView: View {
    @EnvironmentObject var hand: Hand
    
    @State var thumbPositionState: Double = 0 // This holds the value of the thumb for the slider
    @State var indexPositionState: Double = 0
    @State var middlePositionState: Double = 0
    @State var ringPositionState: Double = 0
    @State var pinkyPositionState: Double = 0
    
    var body: some View {
        
        // The slider requires a binding so this converts the variable held in the object to a binding and stores it in the state.
        let thumbPosition = Binding<Double> (
            get: { self.hand.thumbPosition },
            set: { newValue in
                if newValue != self.thumbPositionState {
                    print(self.hand.thumbPosition)
                    self.thumbPositionState = newValue
                    self.hand.thumbPosition = newValue
                }
            }
        )
        
        let indexPosition = Binding<Double> (
            get: { self.hand.indexPosition },
            set: { newValue in
                if newValue != self.indexPositionState {
                    self.indexPositionState = newValue
                    self.hand.indexPosition = newValue
                }
            }
        )
        
        let middlePosition = Binding<Double> (
            get: { self.hand.middlePosition },
            set: { newValue in
                if newValue != self.middlePositionState {
                    self.middlePositionState = newValue
                    self.hand.middlePosition = newValue
                }
            }
        )
        
        let ringPosition = Binding<Double> (
            get: { self.hand.ringPosition },
            set: { newValue in
                if newValue != self.ringPositionState {
                    self.ringPositionState = newValue
                    self.hand.ringPosition = newValue
                }
            }
        )
        
        let pinkyPosition = Binding<Double> (
            get: { self.hand.pinkyPosition },
            set: { newValue in
                if newValue != self.pinkyPositionState {
                    self.pinkyPositionState = newValue
                    self.hand.pinkyPosition = newValue
                }
            }
        )
        
        return VStack {
            Text("Open").font(.caption).bold()
            Spacer(minLength: 150)
            HStack {
                VSlider(value: thumbPosition, in: 0...100, step: 1.0, label: "Thumb") // Vertical Slider
                VSlider(value: indexPosition, in: 0...100, step: 1.0, label: "Index")
                VSlider(value: middlePosition, in: 0...100, step: 1.0, label: "Middle")
                VSlider(value: ringPosition, in: 0...100, step: 1.0, label: "Ring")
                VSlider(value: pinkyPosition, in: 0...100, step: 1.0, label: "Pinky")
            }
            Spacer(minLength: 80)
            Button(action: {
                let newGesture = SavedGesture(thumbPosition: self.hand.thumbPosition, indexPosition: self.hand.indexPosition, middlePosition: self.hand.middlePosition, ringPosition: self.hand.ringPosition, pinkyPosition: self.hand.pinkyPosition)
                self.hand.settings.savedGestures.append(newGesture)
            }, label: {
                Text("Save Gesture")
            })
            Text("Closed").font(.caption).bold()
        }
        .navigationBarTitle("Manual Control")
            
        // Ping the server to check if your online.
        .onAppear {
            print(self.hand.settings.savedGestures)
        }
    }
}
