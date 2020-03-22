//
//  SettingsView.swift
//  RobotHand
//
//  Created by Christian on 13/3/20.
//  Copyright © 2020 Christian. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var hand: Hand
    var body: some View {
        
        let url = Binding<String> (
            get: { self.hand.settings.url },
            set: { newValue in
                self.hand.settings.url = newValue
            }
        )
        
        let port = Binding<String> (
            get: { self.hand.settings.port },
            set: { newValue in
                self.hand.settings.port = newValue
            }
        )
        
        return Form {
            Section {
                HStack {
                    RoundedRectangle(cornerRadius: self.hand.connected ? 100 : 2)
                        .frame(width: 10, height: 10, alignment: .leading)
                        .foregroundColor(self.hand.connected ? .green : .red)
                        .animation(.spring(blendDuration: 1))
                        
                    Text(self.hand.connected ? "Connected!" : "Not Connected!")
                        .animation(.spring(blendDuration: 1))
                }
            }
            Section {
                HStack {
                    Text("URL: ")
                        .foregroundColor(.secondary)
                    TextField("URL", text: url)
                }
                HStack {
                    Text("Port: ")
                        .foregroundColor(.secondary)
                    TextField("Port", text: port)
                }
                Button(action: {
                    self.hand.connect()
                }, label: {
                    Text("Apply Changes")
                })
            }
            Section {
                Button(action: {
                    self.hand.connect()
                }, label: {
                    Text("Restart Connection")
                })
                Button(action: {
                    self.hand.stop()
                }, label: {
                    Text("Stop Connection")
                })
            }
        }.navigationBarTitle("Settings", displayMode: .inline)
    }
}
