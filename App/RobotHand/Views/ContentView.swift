//
//  ContentView.swift
//  RobotHand
//
//  Created by Christian on 7/3/20.
//  Copyright © 2020 Christian. All rights reserved.
//

import SwiftUI
import ModalView

struct ContentView: View {
    
    @EnvironmentObject var hand: Hand // An @EnvironmentObject means that when values change the data is available to all views. Nothing gets out of sync.
    
    var body: some View {
        
        // NavigationView so we can easily navigate between views.
        return NavigationView {
            VStack {
                
                // Button to go to manual control view.
                NavigationLink(destination: ManualControlView()) {
                    Rectangle()
                        .frame(width: 180, height: 80)
                        .foregroundColor(Color.init(red: 0, green: 0.7, blue: 1))
                        .overlay(Text("Manual Control").bold())
                        .cornerRadius(15)
                        .shadow(color: Color("Shadow"), radius: 8, x: 2.5, y: 2.5)
                        .padding(20)
                }.foregroundColor(.black)
                
                // Button to go to gesture control view.
                NavigationLink(destination: GestureControlView()) {
                    Rectangle()
                        .frame(width: 180, height: 80)
                        .foregroundColor(Color.init(red: 0, green: 0.7, blue: 1))
                        .overlay(Text("Gesture Control").bold())
                        .cornerRadius(15)
                        .shadow(color: Color("Shadow"), radius: 8, x: 2.5, y: 2.5)
                        .padding(20)
                }.foregroundColor(.black)
                
                // We only want the AR control in iOS, as ARKit is not available on Mac.
                #if !targetEnvironment(macCatalyst)
                // Button to go to AR control view.-- need to implement as UIViewReperesentable for swiftui
                NavigationLink(destination: ARControlView()) {
                    Rectangle()
                        .frame(width: 180, height: 80)
                        .foregroundColor(Color.init(red: 0, green: 0.7, blue: 1))
                        .overlay(
                            Text("AR Control").bold()
                        )
                        .cornerRadius(15)
                        .shadow(color: Color("Shadow"), radius: 8, x: 2.5, y: 2.5)
                        .padding(20)
                }.foregroundColor(.black)
                #endif
                HStack(spacing: 50) {
                    
                    #if !targetEnvironment(macCatalyst)
                    // Button to present help menu as a modal.
                    ModalPresenter {
                        ModalLink(destination: HelpView()) {
                            Image(systemName: "questionmark.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .shadow(color: Color("Shadow"), radius: 8, x: 2.5, y: 2.5)
                        }.foregroundColor(Color("Button"))
                    }
                    #elseif targetEnvironment(macCatalyst)
                    // Present it as a nav link as MacOS doesn't support modals.
                    NavigationLink(destination: HelpView()) {
                        Image(systemName: "questionmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .shadow(color: Color("Shadow"), radius: 8, x: 2.5, y: 2.5)
                    }.foregroundColor(Color("Button"))
                    #endif
                    
                    // Button to go to settings view.
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .shadow(color: Color("Shadow"), radius: 8, x: 2.5, y: 2.5)
                    }.foregroundColor(Color("Button"))
                    
                }.offset(y: 40)
                
            }.navigationBarTitle("Robot Hand")
            
        }.navigationViewStyle(StackNavigationViewStyle())
        // When the view appears, connect to the websocket server.
        .onAppear {
            self.hand.connect()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





