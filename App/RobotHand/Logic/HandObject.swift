//
//  HandObject.swift
//  RobotHand
//
//  Created by Christian on 13/3/20.
//  Copyright © 2020 Christian. All rights reserved.
//

import SwiftUI
import Combine
import Vision

// This class is an observable object meaning that it can be observed by other views and views will be updated when an @Published variable changes inside it.
// This class also handles the websockets logic.
final class Hand: ObservableObject {
    
    @ObservedObject var settings = Settings()
    
    // MARK:- Websockets
    
    // Here we can set up the task for websockets.
    private let urlSession = URLSession(configuration: .default)
    private var webSocketTask: URLSessionWebSocketTask?
    @Published var connected = false
    
    // This function handles connecting to the websockets server.
    func connect() {
        stop()
        webSocketTask = urlSession.webSocketTask(with: URL(string: "ws://\(self.settings.url):\(self.settings.port)")!)
        webSocketTask?.resume()
        receiveMessage()
    }
    
    // This function disconnects from the websockets server.
    func stop() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        DispatchQueue.main.async {
            self.connected = false
        }
    }
    
    // This function takes in a message as a parameter and then sends it to the websocket server.
    func sendMessage(messageString: String) {
        let message = URLSessionWebSocketTask.Message.string(messageString)
        DispatchQueue.global().async { [weak self] in
            self?.webSocketTask?.send(message) { error in
                if let error = error {
                    print("Websocket couldn’t send message because: \(error)")
                    DispatchQueue.main.async {
                        self!.connected = false
                    }
                }
            }
        }
    }
    
    func receiveMessage() {
        webSocketTask?.receive { result in
            switch result {
                case .failure(let error):
                    print("Error in receiving message: \(error)")
                    DispatchQueue.main.async {
                        self.connected = false
                    }
                case .success(let message):
                    switch message {
                        case .string(let text):
                            print("Received string: \(text)")
                            if text == "alive" {
                                DispatchQueue.main.async {
                                    self.connected = true
                                }
                            }
                        default:
                            print("Message recieved could not be interpreted.")
                    }
              self.receiveMessage() // Continue receiving messages.
            }
        }
    }
    
    // MARK:- Hand positions.
    
    // An @Published variable sends a message to all views when the value changes. This means views will always update to show the latest value.
    @Published var thumbCurrentPosition: CGSize = .zero // This holds the current position of the dot used in gesture control.
    @Published var thumbNewPosition: CGSize = .zero // This holds the new position which is the current position when the drag has ended. Lets us calculate where the dot is on the screen.
    @Published var thumbPosition: Double = 0 { // This variable holds the actual physical thumb position.
        // didSet allows us to do something when the variable changes
        didSet {
            // when the variable changes, send the message of the new position the the websockets server.
            sendMessage(messageString: "thumb-\(thumbPosition)")
        }
    }

    @Published var indexCurrentPosition: CGSize = .zero
    @Published var indexNewPosition: CGSize = .zero
    @Published var indexPosition: Double = 0 {
       didSet {
           sendMessage(messageString: "index-\(indexPosition)")
       }
    }
    
    @Published var middleCurrentPosition: CGSize = .zero
    @Published var middleNewPosition: CGSize = .zero
    @Published var middlePosition: Double = 0 {
       didSet {
           sendMessage(messageString: "middle-\(middlePosition)")
       }
    }
    
    @Published var ringCurrentPosition: CGSize = .zero
    @Published var ringNewPosition: CGSize = .zero
    @Published var ringPosition: Double = 0 {
       didSet {
           sendMessage(messageString: "ring-\(ringPosition)")
       }
    }
    
    @Published var pinkyCurrentPosition: CGSize = .zero
    @Published var pinkyNewPosition: CGSize = .zero
    @Published var pinkyPosition: Double = 0 {
       didSet {
           sendMessage(messageString: "pinky-\(pinkyPosition)")
       }
    }
    
    // MARK:- AR
    
    @Published var arGesture: Gesture = .none {
        didSet {
            // We only want to send the message to the server if the value is different. Therefore this guard means the code below it will only be executed when the new value isn't equal to the new value.
            guard arGesture != oldValue else { return }
            print(arGesture)
            sendMessage(messageString: "\(arGesture)gesture")
        }
    }
    
    @Published var arGestureConfidence: VNConfidence = 0
    
}

