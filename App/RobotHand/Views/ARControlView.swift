//
//  ARControlView.swift
//  RobotHand
//
//  Created by Christian on 14/3/20.
//  Copyright © 2020 Christian. All rights reserved.
//
#if !targetEnvironment(macCatalyst)
import SwiftUI
import RealityKit
import ARKit
import Vision

struct ARControlView: View {
    
    // Load the environment hand object.
    @EnvironmentObject var hand: Hand
    
    // Store the
    let arView = ARViewContainer()
    
    var body: some View {
        ZStack {
            arView.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(height: 100)
                        .opacity(0.5)
                        .blendMode(.screen)
                    VStack {
                        Text("Recognised gesture: \(self.hand.arGesture.rawValue)").animation(.linear)
                        Text("With confidence: \(Int(self.hand.arGestureConfidence*100))%")
                    }
                }
            }.edgesIgnoringSafeArea(.bottom)
        }
        .onAppear {
            self.arView.restartArSession()
        }
        .onDisappear {
            self.arView.pauseArSession()
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    var arView = ARView(frame: .init(x: 1, y: 1, width: 1, height: 1), cameraMode: .ar, automaticallyConfigureSession: false)
    @EnvironmentObject var hand: Hand
    
    func makeUIView(context: Context) -> ARView {
        arView.session.delegate = context.coordinator
        arView.session.run(AROrientationTrackingConfiguration())
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func pauseArSession() {
        arView.session.pause()
    }
    
    func restartArSession() {
        arView.session.run(AROrientationTrackingConfiguration())
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        
        var parent: ARViewContainer
        
        private var currentBuffer: CVPixelBuffer? // This variable holds the frame that will be processed.
        private let visionQueue = DispatchQueue(label: "com.priva28.robothand") // This states the seperate queue/thread we use to run the vision requests so we don't freeze up the main queue running the UI.
        
        private var identifierString = "" // Holds the string of the identified gesture
        private var confidence: VNConfidence = 0.0 // Holds the confidence of the identified gesture
        private var result: Gesture = .none
        
        private lazy var classificationRequest: VNCoreMLRequest = {
            do {
                // Instantiate the model from its generated Swift class.
                let model = try VNCoreMLModel(for: HandML().model)
                let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                    self?.processClassifications(for: request, error: error)
                })
                
                // Use CPU for Vision processing to ensure that there are adequate GPU resources for rendering.
                request.usesCPUOnly = false
                
                return request
            } catch {
                fatalError("Failed to load Vision ML model: \(error)")
            }
        }()
        
        // Whenever the camera updates a new frame.
        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            // Do not enqueue other buffers for processing while another Vision task is still running.
            // The camera stream has only a finite amount of buffers available so holding too many buffers for analysis would starve the camera.
            guard currentBuffer == nil, case .normal = frame.camera.trackingState else {
                return
            }
            
            // Set the buffer to the frame that was just updated.
            currentBuffer = frame.capturedImage
            
            // Classify the frame.
            classifyCurrentImage()
        }
        
        // Classify the grabbed frame.
        private func classifyCurrentImage() {
            let orientation = CGImagePropertyOrientation(UIDevice.current.orientation) // Most computer vision tasks are not rotation agnostic so it is important to pass in the orientation of the image with respect to device.
            
            let requestHandler = VNImageRequestHandler(cvPixelBuffer: currentBuffer!, orientation: orientation) // This is how we handle and make the request.
            
            // Classify on the vision queue that we created.
            visionQueue.async {
                do {
                    // Release the pixel buffer when done, allowing the next buffer to be processed.
                    defer { self.currentBuffer = nil }
                    try requestHandler.perform([self.classificationRequest])
                } catch {
                    print("Error: Vision request failed with error \"\(error)\"")
                }
            }
        }
        
        // Process the result of the classification.
        func processClassifications(for request: VNRequest, error: Error?) {
            guard let results = request.results else {
                print("Unable to classify image.\n\(error!.localizedDescription)")
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
            
            // Show a label for the highest-confidence result (but only above a minimum confidence threshold).
            if let bestResult = classifications.first(where: { result in result.confidence > 0.2 }),
                let label = bestResult.identifier.split(separator: ",").first {
                identifierString = String(label)
                confidence = bestResult.confidence
            } else {
                identifierString = "Negative"
                confidence = 1
            }
            
            switch identifierString {
                case "Negative":
                    result = .none
                case "fist":
                    result = .fist
                case "fivefingers":
                    result = .fivefingers
                case "peace":
                    result = .peace
                case "thumb":
                    result = .thumb
                default:
                    result = .none
            }
            DispatchQueue.main.async {
                self.parent.hand.arGesture = self.result
                self.parent.hand.arGestureConfidence = self.confidence
            }
        }
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> ARViewContainer.Coordinator {
        Coordinator(self)
    }
    
}
#endif
