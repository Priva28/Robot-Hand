//
//  Other.swift
//  RobotHand
//
//  Created by Christian on 13/3/20.
//  Copyright © 2020 Christian. All rights reserved.
//

import SwiftUI
import Combine

// Possible AR Gestures
enum Gesture: String {
    case fivefingers = "Five Fingers ✋", fist = "Fist 👊", peace = "Peace ✌️", thumb = "Thumb 👍", none = "None ❌"
}

// This struct lets us create and save a gesture.
struct SavedGesture: Codable {
    var thumbPosition: Double
    var indexPosition: Double
    var middlePosition: Double
    var ringPosition: Double
    var pinkyPosition: Double
}

// This class lets us save settings and values to UserDefaults.
final class Settings: ObservableObject {
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    // @UserDefault is a custom property wrapper that saves the value in UserDefaults when it is changed so that the settings will be saved after the app is closed.
    @UserDefault("url", defaultValue: "")
    var url: String {
        willSet {
            // Update the view when the value changes.
            objectWillChange.send()
        }
    }
    @UserDefault("port", defaultValue: "9030")
    var port: String {
        willSet {
            objectWillChange.send()
        }
    }
    @UserDefault("savedGestures", defaultValue: [])
    var savedGestures: [SavedGesture] {
        willSet {
            objectWillChange.send()
        }
    }
}

// Custom property wrapper that lets us save variables to UserDefaults easily.
@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

// A slider but vertical.
struct VSlider<V: BinaryFloatingPoint>: View {
    var value: Binding<V>
    var range: ClosedRange<V> = 0...100
    var step: V.Stride? = nil
    var label: String
    var onEditingChanged: (Bool) -> Void = { _ in }
    

    private let drawRadius: CGFloat = 13
    private let dragRadius: CGFloat = 25
    private let lineWidth: CGFloat = 3

    @State private var validDrag = false

    init(value: Binding<V>, in range: ClosedRange<V> = 0...1, step: V.Stride? = nil, label: String = "", onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.value = value

        if let step = step {
            self.step = step
            var newUpperbound = range.lowerBound
            while newUpperbound.advanced(by: step) <= range.upperBound{
                newUpperbound = newUpperbound.advanced(by: step)
            }
            self.range = ClosedRange(uncheckedBounds: (range.lowerBound, newUpperbound))
        } else {
            self.range = range
        }
        self.label = label
        self.onEditingChanged = onEditingChanged
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        // Gray section of line
                        Rectangle()
                            .foregroundColor(Color(.systemGray4))
                            .frame(height: self.getPoint(in: geometry).y)
                            .clipShape(RoundedRectangle(cornerRadius: 2))

                        // Blue section of line
                        Rectangle()
                            .foregroundColor(Color(.systemBlue))
                            .frame(height: geometry.size.height - self.getPoint(in: geometry).y)
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                    }
                    .frame(width: self.lineWidth)
                    Text(self.label).frame(height: 100).multilineTextAlignment(.center)
                    Text("\(Int(self.value.wrappedValue))%").frame(height: 100).multilineTextAlignment(.center)
                }

                // Handle
                Circle()
                    .frame(width: 2 * self.drawRadius, height: 2 * self.drawRadius)
                    .position(self.getPoint(in: geometry))
                    .foregroundColor(Color.white)
                    .shadow(radius: 2, y: 2)

                // Catches drag gesture
                Rectangle()
                    .frame(minWidth: CGFloat(self.dragRadius))
                    .foregroundColor(Color.red.opacity(0.001))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded({ _ in
                                self.validDrag = false
                                self.onEditingChanged(false)
                            })
                            .onChanged(self.handleDragged(in: geometry))
                )
            }
        }.frame(width: 60)
    }
}

// Vertical slider logic.
extension VSlider {
    private func getPoint(in geometry: GeometryProxy) -> CGPoint {
        let x = geometry.size.width / 2
        let location = value.wrappedValue - range.lowerBound
        let scale = V(2 * drawRadius - geometry.size.height) / (range.upperBound - range.lowerBound)
        let y = CGFloat(location * scale) + geometry.size.height - drawRadius
        return CGPoint(x: x, y: y)
    }

    private func handleDragged(in geometry: GeometryProxy) -> (DragGesture.Value) -> Void {
        return { drag in
            if drag.startLocation.distance(to: self.getPoint(in: geometry)) < self.dragRadius && !self.validDrag {
                self.validDrag = true
                self.onEditingChanged(true)
            }

            if self.validDrag {
                let location = drag.location.y - geometry.size.height + self.drawRadius
                let scale = CGFloat(self.range.upperBound - self.range.lowerBound) / (2 * self.drawRadius - geometry.size.height)
                let newValue = V(location * scale) + self.range.lowerBound
                let clampedValue = max(min(newValue, self.range.upperBound), self.range.lowerBound)

                if self.step != nil {
                    let step = V.zero.advanced(by: self.step!)
                    self.value.wrappedValue = round((clampedValue - self.range.lowerBound) / step) * step + self.range.lowerBound
                } else {
                    self.value.wrappedValue = clampedValue
                }
            }
        }
    }
}

// CGPoint extension lets us easily calculate distance.
extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}

// Convert device orientation to image orientation for use by Vision analysis.
extension CGImagePropertyOrientation {
    init(_ deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .portraitUpsideDown: self = .left
        case .landscapeLeft: self = .up
        case .landscapeRight: self = .down
        default: self = .right
        }
    }
}
