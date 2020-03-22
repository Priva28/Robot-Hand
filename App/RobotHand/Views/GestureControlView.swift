//
//  GestureControlView.swift
//  RobotHand
//
//  Created by Christian on 11/3/20.
//  Copyright © 2020 Christian. All rights reserved.
//

import SwiftUI

struct GestureControlView: View {
    @EnvironmentObject var hand: Hand
    
    @State var thumbIsTapped = false
    @State var indexIsTapped = false
    @State var middleIsTapped = false
    @State var ringIsTapped = false
    @State var pinkyIsTapped = false
    
    var body: some View {
        
        // Geometry reader gives us access to size of parent view.
        GeometryReader { geometry in
            ZStack {
                HStack {
                    
                    // Dot to put your finger on.
                    Circle()
                        .frame(width: 40, height: 40) // Set the size.
                        .opacity(self.thumbIsTapped ? 0.3 : 1)
                        .scaleEffect(self.thumbIsTapped ? 1.3 : 1)
                        .offset(x: self.hand.thumbCurrentPosition.width, y: self.hand.thumbCurrentPosition.height) // Set the offset to how much the user is dragging
                        .gesture( // Add the dragging capabilities.
                            DragGesture(minimumDistance: 0)
                                
                                // When the value changes.
                                .onChanged {
                                    withAnimation(.spring()) {
                                        self.thumbIsTapped = true
                                    }
                                    // Set the translation(how much it moved) in the currentPosition variable.
                                    self.hand.thumbCurrentPosition = CGSize(
                                        width: $0.translation.width + self.hand.thumbNewPosition.width,
                                        height: $0.translation.height + self.hand.thumbNewPosition.height
                                    )
                                    
                                    // Set the final position which will update the server when it changes.
                                    self.hand.thumbPosition = Double(Int((0 - (self.hand.thumbCurrentPosition.height/(geometry.size.height/2.1))) * 100))
                                }
                                
                                // When the user lifts their finger from the screen.
                                .onEnded {
                                    withAnimation(.spring()) {
                                        self.thumbIsTapped = false
                                    }
                                    // Set the final translation(how much it moved) in the currentPosition variable.
                                    self.hand.thumbCurrentPosition = CGSize(
                                        width: $0.translation.width + self.hand.thumbNewPosition.width,
                                        height: $0.translation.height + self.hand.thumbNewPosition.height
                                    )
                                    
                                    // Set the newPosition to be the currentPosition.
                                    self.hand.thumbNewPosition = self.hand.thumbCurrentPosition
                                }
                        )
                    Circle()
                        .frame(width: 40, height: 40)
                        .animation(.spring())
                        .opacity(self.indexIsTapped ? 0.3 : 1)
                        .scaleEffect(self.indexIsTapped ? 1.3 : 1)
                        .offset(x: self.hand.indexCurrentPosition.width, y: self.hand.indexCurrentPosition.height)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged {
                                    withAnimation(.spring()) {
                                        self.indexIsTapped = true
                                    }
                                    self.hand.indexCurrentPosition = CGSize(
                                        width: $0.translation.width + self.hand.indexNewPosition.width,
                                        height: $0.translation.height + self.hand.indexNewPosition.height
                                    )
                                    self.hand.indexPosition = Double(Int((0 - (self.hand.indexCurrentPosition.height/(geometry.size.height/2.1))) * 100))
                                }
                                .onEnded {
                                    self.hand.indexCurrentPosition = CGSize(
                                        width: $0.translation.width + self.hand.indexNewPosition.width,
                                        height: $0.translation.height + self.hand.indexNewPosition.height
                                    )
                                    self.hand.indexNewPosition = self.hand.indexCurrentPosition
                                }
                        )
                    Circle()
                        .frame(width: 40, height: 40)
                        .animation(.spring())
                        .opacity(self.middleIsTapped ? 0.3 : 1)
                        .scaleEffect(self.middleIsTapped ? 1.3 : 1)
                        .offset(x: self.hand.middleCurrentPosition.width, y: self.hand.middleCurrentPosition.height)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged {
                                    withAnimation(.spring()) {
                                        self.middleIsTapped = true
                                    }
                                    self.hand.middleCurrentPosition = CGSize(
                                        width: $0.translation.width + self.hand.middleNewPosition.width,
                                        height: $0.translation.height + self.hand.middleNewPosition.height
                                    )
                                    self.hand.middlePosition = Double(Int((0 - (self.hand.middleCurrentPosition.height/(geometry.size.height/2.1))) * 100))
                                }
                                .onEnded {
                                    self.hand.middleCurrentPosition = CGSize(
                                        width: $0.translation.width + self.hand.middleNewPosition.width,
                                        height: $0.translation.height + self.hand.middleNewPosition.height
                                    )
                                    self.hand.middleNewPosition = self.hand.middleCurrentPosition
                                }
                        )
                    Circle()
                        .frame(width: 40, height: 40)
                        .animation(.spring())
                        .opacity(self.ringIsTapped ? 0.3 : 1)
                        .scaleEffect(self.ringIsTapped ? 1.3 : 1)
                        .offset(x: self.hand.ringCurrentPosition.width, y: self.hand.ringCurrentPosition.height)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged {
                                    withAnimation(.spring()) {
                                        self.ringIsTapped = true
                                    }
                                    self.hand.ringCurrentPosition = CGSize(
                                        width: $0.translation.width + self.hand.ringNewPosition.width,
                                        height: $0.translation.height + self.hand.ringNewPosition.height
                                    )
                                    self.hand.ringPosition = Double(Int((0 - (self.hand.ringCurrentPosition.height/(geometry.size.height/2.1))) * 100))
                                }
                                .onEnded {
                                    self.hand.ringCurrentPosition = CGSize(
                                        width: $0.translation.width + self.hand.ringNewPosition.width,
                                        height: $0.translation.height + self.hand.ringNewPosition.height
                                    )
                                    self.hand.ringNewPosition = self.hand.ringCurrentPosition
                                }
                        )
                    Circle()
                        .frame(width: 40, height: 40)
                        .animation(.spring())
                        .opacity(self.pinkyIsTapped ? 0.3 : 1)
                        .scaleEffect(self.pinkyIsTapped ? 1.3 : 1)
                        .offset(x: self.hand.pinkyCurrentPosition.width, y: self.hand.pinkyCurrentPosition.height)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged {
                                    withAnimation(.spring()) {
                                        self.pinkyIsTapped = true
                                    }
                                    self.hand.pinkyCurrentPosition = CGSize(
                                        width: $0.translation.width + self.hand.pinkyNewPosition.width,
                                        height: $0.translation.height + self.hand.pinkyNewPosition.height
                                    )
                                    self.hand.pinkyPosition = Double(Int((0 - (self.hand.pinkyCurrentPosition.height/(geometry.size.height/2.1))) * 100))
                                }
                                .onEnded {
                                    self.hand.pinkyCurrentPosition = CGSize(
                                        width: $0.translation.width + self.hand.pinkyNewPosition.width,
                                        height: $0.translation.height + self.hand.pinkyNewPosition.height
                                    )
                                    self.hand.pinkyNewPosition = self.hand.pinkyCurrentPosition
                                }
                        )
                }.frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

struct GestureControlView_Previews: PreviewProvider {
    static var previews: some View {
        GestureControlView()
    }
}
